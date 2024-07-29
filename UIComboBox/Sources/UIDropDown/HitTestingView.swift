//
//  DropDownDismissingView.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import Foundation

final class HitTestingView: UIView {
    
    private let hitTestCallback: (CGPoint, UIEvent?) -> UIView?
    
    private weak var dropDown2: UIView?
    private weak var anchorView: UIView?
    
    init(_ dropDown2: UIView?, _ anchorView: UIView?, hitTestCallback: @escaping (CGPoint, UIEvent?) -> UIView?) {
        self.dropDown2 = dropDown2
        self.anchorView = anchorView
        self.hitTestCallback = hitTestCallback
        super.init(frame: .zero)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //backgroundColor = .clear
        if #available(iOS 13.0, *) {
            backgroundColor = UIColor(cgColor: CGColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 0.2))
        } else {
            backgroundColor = .clear
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for view in [dropDown2, anchorView].compactMap({ $0 }) {
            let point = self.convert(point, to:view)
            if let result = view.hitTest(point, with:event) {
                return result
            }
        }
        return hitTestCallback(point, event)
    }
}
