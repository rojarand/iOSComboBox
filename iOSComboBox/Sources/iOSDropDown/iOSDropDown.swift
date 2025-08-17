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
    private let dropDownPresenter = iOSDropDownPresenter()
    private let keyboardSupport: iOSDropDownKeyboardSupport
    internal let dropDownAnimator = iOSDropDownAnimator()
    internal weak var anchorView: UITextField?
    private lazy var dismissingView: UIView = {
        let view = HitTestingView(tableViewContainer, anchorView) { [weak self] _, _ in
            if !UIAccessibility.isVoiceOverRunning {
                self?.hide()
                self?.anchorView?.resignFirstResponder()
                return self?.anchorView?.window
            } else {
                return nil
            }
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
        keyboardSupport = iOSDropDownKeyboardSupport(dropDownPresenter: dropDownPresenter)
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(handleDropDownWillShow(_:)), name: iOSDropDown.dropDownWillShowNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func show() {
        showDropDown(animate: _tableView == nil, delay: keyboardSupport.isKeyboardVisible == true ? 0.0 : 0.5)
    }
    
    public func hide() {
        tearDown()
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
        _tableView?.register(cellMetadata.cellClass.self, forCellReuseIdentifier: cellMetadata.identifier)
    }
    
    func showDropDown(animate: Bool, delay: TimeInterval, requiresFirstResponder: Bool = false) {
        guard let anchorView = self.anchorView,
              let window = anchorView.window,
              ((requiresFirstResponder && anchorView.isFirstResponder) || !requiresFirstResponder) else { return }
        notifyDropDownWillShow()
        setUp(anchorView, window)
        layout(anchorView: anchorView, window: window, animate: animate, delay: delay)
    }
    
    private func setUp(_ anchorView: UITextField, _ window: UIWindow) {
        dropDownPresenter.setUp(dropDown: self)
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
        dropDownFrame = .zero
        _tableView?.removeFromSuperview()
        _tableView = nil
        dismissingView.removeFromSuperview()
        dropDownPresenter.tearDown()
        dropDownAnimator.cancel()
    }
    
    internal var isHidden: Bool {
        _tableView == nil
    }
    
    private func layout(anchorView: UITextField, window: UIWindow, animate: Bool, delay: TimeInterval) {
        let dropDownLayout = calculateDropDownLayout()
        prepareTableView(offscreenHeight: dropDownLayout.offscreenHeight)
        layoutDropDown(using: dropDownLayout)
        
        func calculateDropDownLayout() -> DropDownLayout {
            tableView.reloadData()
            return iOSDropDownLayoutCalculator.calculateDropDownLayout(
                desirableContainerHeight: tableView.calculateTableViewHeight(),
                anchorViewFrame: anchorView.convert(anchorView.bounds, to: window),
                minYOfDropDown: calculateMinYOfDropDown(),
                maxYOfDropDown: calculateMaxYOfDropDown(window))
        }
        
        func prepareTableView(offscreenHeight: CGFloat) {
            tableView.isScrollEnabled = offscreenHeight > 0.0
        }
    
        func layoutDropDown(using layout: DropDownLayout) {
            dropDownAnimator.cancel()
            if animate {
                if dropDownFrame == .zero {
                    dropDownFrame = layout.initialFrame
                }
                dropDownAnimator.animate(afterDelay: delay) { [weak self] in
                    self?.dropDownFrame = layout.finalFrame
                }
            } else {
                dropDownFrame = layout.finalFrame
            }
            dismissingView.frame = window.bounds
            window.bringSubviewToFront(dismissingView)
        }
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
        if keyboardSupport.isKeyboardVisible == true, let keyboardFrame = keyboardSupport.keyboardFrame {
            keyboardFrame.minY - verticalMargin
        } else {
            window.bounds.maxY - verticalMargin
        }
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
