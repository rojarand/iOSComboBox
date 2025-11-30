//
//  HitTestingView.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import UIKit

final class HitTestingView: UIView {
    private let hitTestCallback: (CGPoint, UIEvent?) -> UIView?

    private weak var dropDownContainer: UIView?
    private weak var anchorView: UIView?

    init(_ dropDownContainer: UIView?, _ anchorView: UIView?, hitTestCallback: @escaping (CGPoint, UIEvent?) -> UIView?) {
        self.dropDownContainer = dropDownContainer
        self.anchorView = anchorView
        self.hitTestCallback = hitTestCallback

        super.init(frame: .zero)
        isAccessibilityElement = false
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for view in [dropDownContainer, anchorView].compactMap({ $0 }) {
            let point = convert(point, to: view)
            if let result = view.hitTest(point, with: event) {
                return result
            }
        }
        return hitTestCallback(point, event)
    }
}
