//
//  iOSDropDown.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 30/07/2024.
//

import UIKit

struct CellMetadata {
    let cellClass: AnyClass
    let identifier: String
}

open class iOSDropDown: NSObject {
    
    weak var delegate: iOSDropDownDelegate?
    private static let dropDownWillShowNotification = Notification.Name("DropDownWillShow")
    private var propertyObservations = [NSKeyValueObservation]()
    private var showDropDownAnimator: UIViewPropertyAnimator?
    private var showDropDownDelayTimer: Timer?
    private var showLaterWorkItem: DispatchWorkItem?
    private var isKeyboardVisible = false
    private var keyboardFrame = CGRect.zero
    internal weak var anchorView: UITextField?
    private lazy var dismissingView: UIView = {
        let view = HitTestingView(tableViewContainer, anchorView) { [weak self] _, _ in
            self?.hide()
            self?.anchorView?.resignFirstResponder()
            return self?.anchorView?.window
        }
        return view
    }()
    
    private lazy var tableViewContainer: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 4
        view.layer.cornerRadius = 0
        view.isAccessibilityElement = false
        return view
    }()
    
    private var _tableView: UITableView?
    private var tableView: UITableView {
        let tableView = _tableView ?? createTableView()
        _tableView = tableView
        return tableView
    }
    
    private var cellsMetadata = [CellMetadata]()
    private var _separatorStyle: UITableViewCell.SeparatorStyle = .singleLine
    
    private func createTableView() -> UITableView {
        let view = UITableView()
        view.autoresizingMask = []
        view.frame = .zero
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.separatorInset = .zero
        view.separatorStyle = _separatorStyle
        view.layer.cornerRadius = tableViewContainer.layer.cornerRadius
        cellsMetadata.forEach { cellClass in
            view.register(cellClass.cellClass.self, forCellReuseIdentifier: cellClass.identifier)
        }
        return view
    }
    
    init(anchorView: UITextField) {
        self.anchorView = anchorView
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDropDownWillShow(_:)), name: iOSDropDown.dropDownWillShowNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func register<T: UITableViewCell>(cellClass: T.Type) {
        register(cellMetadata: CellMetadata(cellClass: cellClass, identifier: String(describing: T.self)))
    }
    
    @objc public func registerCellClass(_ cellClass: AnyClass, forCellReuseIdentifier identifier: String) {
        register(cellMetadata: CellMetadata(cellClass: cellClass, identifier: identifier))
    }
    
    func reloadData() {
        guard let anchorView = self.anchorView, let window = anchorView.window, !isHidden else { return }
        layout(anchorView: anchorView, window: window, animate: false, delay: 0)
    }
    
    private func register(cellMetadata: CellMetadata) {
        cellsMetadata.append(cellMetadata)
        tableView.register(cellMetadata.cellClass.self, forCellReuseIdentifier: cellMetadata.identifier)
    }
    
    func show() {
        showDropDown(animate: _tableView == nil, delay: _tableView == nil ? 0.0 : 0.5)
    }
    
    private func showDropDown(animate: Bool, delay: TimeInterval, requiresFirstResponder: Bool = false) {
        guard let anchorView = self.anchorView, let window = anchorView.window,
                ((requiresFirstResponder && anchorView.isFirstResponder) || !requiresFirstResponder) else { return }
        notifyDropDownWillShow()
        setUp(anchorView, window)
        layout(anchorView: anchorView, window: window, animate: animate, delay: delay)
    }
    
    public func hide() {
        tearDown()
    }
    
    private func setUp(_ anchorView: UITextField, _ window: UIWindow) {
        hideOnScrollOfViewIfNeeded(anchorView)
        anchorView.superview?.bringSubviewToFront(anchorView)
        if dismissingView.superview == nil {
            window.addSubview(dismissingView)
            window.bringSubviewToFront(dismissingView)
        }
        if tableViewContainer.superview == nil {
            tableViewContainer.translatesAutoresizingMaskIntoConstraints = true
            tableViewContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            window.addSubview(tableViewContainer)
            window.bringSubviewToFront(tableViewContainer)
        }
        if (tableView.superview == nil) {
            tableViewContainer.addSubview(tableView)
        }
    }
    
    private func tearDown() {
        showDropDownDelayTimer?.invalidate()
        showDropDownDelayTimer = nil
        showDropDownAnimator?.stopAnimation(true)
        showDropDownAnimator = nil
        dropDownFrame = .zero
        _tableView?.removeFromSuperview()
        _tableView = nil
        dismissingView.removeFromSuperview()
        propertyObservations.removeAll()
    }
    
    private var isHidden: Bool {
        _tableView == nil
    }
    
    private func layout(anchorView: UITextField, window: UIWindow, animate: Bool, delay: TimeInterval) {
        let dropDownLayout = calculateDropDownLayout()
        prepareTableView(offscreenHeight: dropDownLayout.offscreenHeight)
        layoutDropDown(using: dropDownLayout)
        
        
        func calculateDropDownLayout() -> DropDownLayout {
            tableView.reloadData()
            return DropDownLayoutCalculator.calculateDropDownLayout(
                desirableContainerHeight: tableView.calculateTableViewHeight(),
                anchorViewFrame: anchorView.convert(anchorView.bounds, to: window),
                minYOfDropDown: calculateMinYOfDropDown(),
                maxYOfDropDown: calculateMaxYOfDropDown(window))
        }
        
        func prepareTableView(offscreenHeight: CGFloat) {
            tableView.isScrollEnabled = offscreenHeight > 0.0
        }
    
        func layoutDropDown(using layout: DropDownLayout) {
            
            showDropDownAnimator?.stopAnimation(true)
            showDropDownAnimator = nil
            if animate {
                if dropDownFrame == .zero {
                    dropDownFrame = layout.initialFrame
                }
                showDropDownAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut) { [weak self] in
                    self?.dropDownFrame = layout.finalFrame
                }
                showDropDownAnimator?.startAnimation(afterDelay: delay)
            } else {
                dropDownFrame = layout.finalFrame
            }
            
            dismissingView.frame = window.bounds
            window.bringSubviewToFront(dismissingView)
        }
    }
    
    private func hideOnScrollOfViewIfNeeded(_ view: UIView?) {
        if propertyObservations.isEmpty {
            hideOnScroll(of: view)
        }
    }
    
    private func hideOnScroll(of view: UIView?) {
        guard let currentView = view else { return }
        if let scrollView = currentView as? UIScrollView {
            let observation = scrollView.observe(\.contentOffset, options: [.old, .new]) { [weak self] object, change in
                if change.newValue != change.oldValue {
                    self?.hideIfNeededAndShowLater()
                }
            }
            self.propertyObservations.append(observation)
        }
        hideOnScroll(of: currentView.superview)
    }
    
    private func notifyDropDownWillShow() {
        NotificationCenter.default.post(name: iOSDropDown.dropDownWillShowNotification, object: self)
    }
    
    @objc func handleDropDownWillShow(_ notification: Notification) {
        guard let sender = notification.object as AnyObject? else { return }
        if self !== sender {
            hide()
        }
    }
    
    private var dropDownFrame: CGRect {
        get {
            tableViewContainer.frame
        }
        set {
            tableViewContainer.frame = newValue
            tableView.frame = tableViewContainer.bounds
        }
    }
    
    private var verticalMargin: CGFloat {
        50.0
    }
    
    private func calculateMinYOfDropDown() -> CGFloat {
        verticalMargin
    }
    
    private func calculateMaxYOfDropDown(_ window: UIWindow) -> CGFloat {
        if isKeyboardVisible {
            return keyboardFrame.minY - verticalMargin
        } else {
            return window.bounds.maxY - verticalMargin
        }
    }
    
    private func hideIfNeededAndShowLater() {
        if !isHidden {
            hide()
        } else {
            guard let showLaterWorkItem = self.showLaterWorkItem else { return }
            showLaterWorkItem.cancel()
        }
        let dispatchWorkItem = DispatchWorkItem { [weak self] in
            self?.show()
            self?.showLaterWorkItem = nil
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: dispatchWorkItem)
        self.showLaterWorkItem = dispatchWorkItem
    }
}

// MARK: - UI customisation

extension iOSDropDown {
    var cornerRadius: CGFloat {
        get {
            tableViewContainer.layer.cornerRadius
        }
        set {
            tableViewContainer.layer.cornerRadius = newValue
            _tableView?.layer.cornerRadius = newValue
        }
    }
    
    var shadowRadius: CGFloat {
        get {
            tableViewContainer.layer.shadowRadius
        }
        set {
            tableViewContainer.layer.shadowRadius = newValue
        }
    }
    
    var shadowOffset: CGSize {
        get {
            tableViewContainer.layer.shadowOffset
        }
        set {
            tableViewContainer.layer.shadowOffset = newValue
        }
    }
    
    var shadowColor: CGColor? {
        get {
            tableViewContainer.layer.shadowColor
        }
        set {
            tableViewContainer.layer.shadowColor = newValue
        }
    }
    
    var shadowOpacity: Float {
        get {
            tableViewContainer.layer.shadowOpacity
        }
        set {
            tableViewContainer.layer.shadowOpacity = newValue
        }
    }
    
    var separatorStyle: UITableViewCell.SeparatorStyle {
        get {
            _separatorStyle
        }
        set {
            _separatorStyle = newValue
            _tableView?.separatorStyle = newValue
        }
    }
    
}

// MARK: - Keyboard handling

extension iOSDropDown {
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        isKeyboardVisible = true
        keyboardFrame = keyboardFrame(fromNotification: notification) ?? .zero
        let showDropDownDelay = (keyboardAnimationDuration(fromNotification: notification) ?? Self.defaultKeyboardAnimationDuration) + 0.05
        showDropDownAnimator?.stopAnimation(true)
        showDropDownDelayTimer?.invalidate()
        showDropDownDelayTimer = Timer.scheduledTimer(withTimeInterval: showDropDownDelay, repeats: false) { [weak self] _ in
            self?.showDropDown(animate: true, delay: 0.0, requiresFirstResponder: true)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        isKeyboardVisible = false
        keyboardFrame = keyboardFrame(fromNotification: notification) ?? .zero
    }
    
    private static var defaultKeyboardAnimationDuration: TimeInterval {
        0.25
    }
    
    private func keyboardFrame(fromNotification notification: Notification) -> CGRect? {
        (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }
    
    private func keyboardAnimationDuration(fromNotification notification: Notification) -> TimeInterval? {
        (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
    }
}

