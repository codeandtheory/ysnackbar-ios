//
//  SnackHostView.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 08/11/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit

final class SnackHostView: UIView {
    private(set) weak var nextHostView: SnackHostView?
    private(set) weak var previousHostView: SnackHostView?
    private(set) weak var topConstraint: NSLayoutConstraint?
    private(set) weak var bottomConstraint: NSLayoutConstraint?

    internal var snack: Snack {
        get { snackView.snack }

        set {
            snackView.update(newValue)
            updateView()
        }
    }
    
    private let snackView: SnackUpdatable
    private var shadowSize: CGSize = .zero

    internal init(snackView: SnackUpdatable) {
        self.snackView = snackView
        super.init(frame: .zero)

        build()
    }

    internal required init?(coder: NSCoder) { nil }

    internal func deactivateTopConstraint() {
        topConstraint?.isActive = false
    }

    internal func deactivateBottomConstraint() {
        bottomConstraint?.isActive = false
    }

    internal func setTopConstraint(_ constraint: NSLayoutConstraint?) {
        topConstraint = constraint
    }

    internal func setBottomConstraint(_ constraint: NSLayoutConstraint?) {
        bottomConstraint = constraint
    }

    internal func setNextHostView(_ hostView: SnackHostView?) {
        nextHostView = hostView
    }

    internal func setPreviousHostView(_ hostView: SnackHostView?) {
        previousHostView = hostView
    }

    internal func update(_ snack: Snack) {
        self.snack = snack
    }

    internal func updateShadow() {
        snack.appearance.elevation.apply(layer: layer, cornerRadius: snack.appearance.layout.cornerRadius)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard shadowSize != bounds.size else { return }
        updateShadow()
        shadowSize = bounds.size
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            adjustColors()
        }
    }
}

private extension SnackHostView {
    func build() {
        buildViews()
        buildConstraints()
        configureViews()
        updateView()
    }

    func buildViews() {
        addSubview(snackView)
    }

    func buildConstraints() {
        snackView.constrainEdges()
    }

    func configureViews() {
        let swipeGesture = UISwipeGestureRecognizer()
        swipeGesture.direction = snack.alignment == .top ? .up : .down
        swipeGesture.addTarget(self, action: #selector(didSwipe(sender:)))
        addGestureRecognizer(swipeGesture)
    }

    func updateView() {
        updateShadow()
        snackView.layer.cornerRadius = snack.appearance.layout.cornerRadius
    }

    @objc func didSwipe(sender: UISwipeGestureRecognizer) {
        SnackbarManager.remove(snack: snack)
    }
    
    func adjustColors() {
        let elevation = snack.appearance.elevation
        layer.shadowColor = elevation.color.cgColor
    }
}

/// Methods for unit testing
internal extension SnackHostView {
    /// Simulates a swipe for unit testing
    func simulateSwipe() {
        didSwipe(sender: UISwipeGestureRecognizer())
    }
}
