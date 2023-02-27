//
//  SnackContainerView.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 15/09/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit

internal class SnackContainerView: UIView {
    internal let alignment: Alignment

    internal var keyWindow: UIWindow? {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }

    private var latestHostView: SnackHostView? {
        switch alignment {
        case .top:
            return hostViews.last
        case .bottom:
            return hostViews.first
        }
    }

    weak var delegate: SnackContainerViewDelegate?

    internal var appearance: SnackbarManager.Appearance

    private(set) var hostViews: [SnackHostView] = []

    private var dampingRatio: CGFloat { 0.6 }
    private var velocity: CGFloat { 0.4 }
    private var rearrangeAnimationDuration: CGFloat { 0.4 }

    internal init(alignment: Alignment, appearance: SnackbarManager.Appearance) {
        self.alignment = alignment
        self.appearance = appearance
        super.init(frame: .zero)
    }

    internal required init?(coder: NSCoder) { nil }

    internal func addHostView(_ hostView: SnackHostView, completion: @escaping () -> Void) {
        if window == nil { build() }

        addHostViewWithAnimation(hostView, completion: completion)
    }

    internal func removeHostView(at index: Int) {
        let snackIndex = alignment == .top ? index : (hostViews.count - 1) - index
        removeHostViewWithAnimation(hostViews[snackIndex], at: snackIndex) { [weak self] in
            $0.removeFromSuperview()
            self?.removeContainerViewIfNeeded()
        }
    }

    internal func removeHostViewWithAnimation(
        _ hostView: SnackHostView,
        at index: Int,
        completion: @escaping (UIView) -> Void
    ) {
        updateConstraintsOnRemoving(hostView: hostView)
        linkHostViewsOnRemoving(hostView: hostView)

        UIView.animate(
            withDuration: appearance.removeAnimationDuration,
            delay: .zero,
            options: .curveEaseIn,
            animations: { self.layoutIfNeeded() }
        ) { _ in
            completion(hostView)
        }

        hostViews.remove(at: index)
    }

    internal func rearrangeHostView(at index: Int, completion: @escaping () -> Void) -> SnackHostView {
        let hostIndex = alignment == .top ? index : (hostViews.count - 1) - index
        let hostView = hostViews[hostIndex]

        guard let latestHostView = latestHostView,
              latestHostView != hostView else {
            completion()
            return hostView
        }

        updateConstraintsOnRearrange(hostView: hostView)
        linkHostViewsOnRearrange(hostView: hostView)

        bringSubviewToFront(hostView)

        UIView.animate(
            withDuration: rearrangeAnimationDuration,
            animations: { self.layoutIfNeeded() }
        ) {  _ in
            completion()
        }

        hostViews.remove(at: hostIndex)

        switch alignment {
        case .top:
            hostViews.append(hostView)
        case .bottom:
            hostViews.insert(hostView, at: .zero)
        }

        return hostView
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in hostViews {
            guard subview.isUserInteractionEnabled else { continue }

            let pointInView = convert(point, to: subview)

            if subview.point(inside: pointInView, with: event) {
                return true
            }
        }

        return false
    }
}

private extension SnackContainerView {
    func build() {
        buildViews()
        buildConstraints()
    }

    func buildViews() {
        guard let keyWindow = keyWindow else { return }
        keyWindow.addSubview(self)
    }

    func buildConstraints() {
        guard let superview = superview else { return }

        constrainEdges(
            alignment == .top ? .top : .bottom,
            to: superview.safeAreaLayoutGuide,
            with: appearance.contentInset
        )
        
        constrainEdges(
            .horizontal,
            to: superview.safeAreaLayoutGuide,
            relatedBy: .greaterThanOrEqual,
            with: appearance.contentInset
        )

        constrain(.centerXAnchor, to: superview.centerXAnchor)
        constrain(.widthAnchor, relatedBy: .lessThanOrEqual, constant: appearance.maxSnackWidth)
        constrain(.widthAnchor, constant: appearance.maxSnackWidth, priority: .defaultHigh)
    }
}

private extension SnackContainerView {
    func removeContainerViewIfNeeded() {
        if subviews.isEmpty {
            removeFromSuperview()
            delegate?.didRemoveContainerView()
        }
    }

    func setupInitialConstraints(for hostView: SnackHostView) {
        guard let superview = superview else { return }

        let constraint: NSLayoutConstraint?

        switch alignment {
        case .top:
            let offset = max(hostView.snack.appearance.elevation.extent.bottom, 0)
            constraint = hostView.constrain(.bottomAnchor, to: superview.topAnchor, constant: -offset)
        case .bottom:
            let offset = max(hostView.snack.appearance.elevation.extent.top, 0)
            constraint = hostView.constrain(.topAnchor, to: superview.bottomAnchor, constant: offset)
        }

        hostView.constrain(.leadingAnchor, to: leadingAnchor)
        hostView.constrain(.trailingAnchor, to: trailingAnchor)

        layoutIfNeeded()

        constraint?.isActive = false
    }

    func addHostViewWithAnimation(_ hostView: SnackHostView, completion: @escaping () -> Void) {
        addSubview(hostView)
        setupInitialConstraints(for: hostView)

        updateConstraintsOnAdding(hostView: hostView)
        linkHostViewsOnAdding(hostView: hostView)

        UIView.animate(
            withDuration: appearance.addAnimationDuration,
            delay: .zero,
            usingSpringWithDamping: dampingRatio,
            initialSpringVelocity: velocity,
            animations: { self.layoutIfNeeded() }
        ) { _ in
            completion()
        }

        switch alignment {
        case .top:
            hostViews.append(hostView)
        case .bottom:
            hostViews.insert(hostView, at: .zero)
        }
    }

    func updateConstraintsOnAdding(hostView: SnackHostView) {
        let latestHostView = latestHostView

        switch alignment {
        case .top:
            hostView.setTopConstraint(hostView.constrain(
                .topAnchor,
                to: latestHostView?.bottomAnchor ?? topAnchor,
                constant: latestHostView == nil ? .zero : appearance.snackSpacing
            ))
        case .bottom:
            hostView.setBottomConstraint(hostView.constrain(
                .bottomAnchor,
                to: latestHostView?.topAnchor ?? bottomAnchor,
                constant: latestHostView == nil ? .zero : -appearance.snackSpacing
            ))
        }
    }

    func linkHostViewsOnAdding(hostView: SnackHostView) {
        let latestHostView = latestHostView
        hostView.setPreviousHostView(latestHostView)
        latestHostView?.setNextHostView(hostView)
    }

    func updateConstraintsOnRemoving(hostView: SnackHostView) {
        guard let superview = superview else { return }

        let nextHostView = hostView.nextHostView
        let previousHostView = hostView.previousHostView

        hostView.deactivateBottomConstraint()
        hostView.deactivateTopConstraint()

        switch alignment {
        case .top:
            let offset = max(hostView.snack.appearance.elevation.extent.bottom, 0)
            hostView.setTopConstraint(
                hostView.constrain(
                    .bottomAnchor,
                    to: superview.topAnchor,
                    constant: -offset
                )
            )

            nextHostView?.deactivateTopConstraint()

            nextHostView?.setTopConstraint(nextHostView?.constrain(
                .topAnchor,
                to: previousHostView?.bottomAnchor ?? topAnchor,
                constant: previousHostView == nil ? .zero : appearance.snackSpacing
            ))
        case .bottom:
            let offset = max(hostView.snack.appearance.elevation.extent.top, 0)
            hostView.setBottomConstraint(
                hostView.constrain(
                    .topAnchor,
                    to: superview.bottomAnchor,
                    constant: offset
                )
            )

            nextHostView?.deactivateBottomConstraint()

            nextHostView?.setBottomConstraint(nextHostView?.constrain(
                .bottomAnchor,
                to: previousHostView?.topAnchor ?? bottomAnchor,
                constant: previousHostView == nil ? .zero : -appearance.snackSpacing
            ))
        }
    }

    func linkHostViewsOnRemoving(hostView: SnackHostView) {
        let nextHostView = hostView.nextHostView
        let previousHostView = hostView.previousHostView

        previousHostView?.setNextHostView(nextHostView)
        nextHostView?.setPreviousHostView(previousHostView)
    }

    func updateConstraintsOnRearrange(hostView: SnackHostView) {
        let nextHostView = hostView.nextHostView

        switch alignment {
        case .top:
            hostView.deactivateTopConstraint()
            nextHostView?.deactivateTopConstraint()

            nextHostView?.setTopConstraint(nextHostView?.constrain(
                .topAnchor,
                to: hostView.previousHostView?.bottomAnchor ?? topAnchor,
                constant: hostView.previousHostView == nil ? .zero : appearance.snackSpacing
            ))

            hostView.setTopConstraint(hostView.constrain(
                .topAnchor,
                to: latestHostView?.bottomAnchor ?? topAnchor,
                constant: appearance.snackSpacing
            ))
        case .bottom:
            hostView.deactivateBottomConstraint()
            nextHostView?.deactivateBottomConstraint()

            nextHostView?.setBottomConstraint(nextHostView?.constrain(
                .bottomAnchor,
                to: hostView.previousHostView?.topAnchor ?? bottomAnchor,
                constant: hostView.previousHostView == nil ? .zero : -appearance.snackSpacing
            ))

            hostView.setBottomConstraint(hostView.constrain(
                .bottomAnchor,
                to: latestHostView?.topAnchor ?? bottomAnchor,
                constant: -appearance.snackSpacing
            ))
        }
    }

    func linkHostViewsOnRearrange(hostView: SnackHostView) {
        let nextHostView = hostView.nextHostView
        let previousHostView = hostView.previousHostView
        let latestHostView = latestHostView

        previousHostView?.setNextHostView(nextHostView)
        nextHostView?.setPreviousHostView(previousHostView)

        hostView.setNextHostView(latestHostView?.nextHostView)
        hostView.setPreviousHostView(latestHostView)

        latestHostView?.setNextHostView(hostView)
    }
}
