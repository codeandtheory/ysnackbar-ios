//
//  SnackContainerView.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 15/09/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit
import YCoreUI

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

    internal var latestHostView: SnackHostView? {
        switch alignment {
        case .top:
            return hostViews.last
        case .bottom:
            return hostViews.first
        }
    }

    weak var delegate: SnackContainerViewDelegate?

    internal var appearance: SnackbarManager.Appearance

    internal var hostViews: [SnackHostView] = []

    /// Override for isReduceMotionEnabled. Default is `nil`.
    ///
    /// For unit testing. When non-`nil` it will be returned instead of
    /// `UIAccessibility.isReduceMotionEnabled`,
    internal var reduceMotionOverride: Bool?

    /// Accessibility reduce motion is enabled or not.
    internal var isReduceMotionEnabled: Bool {
        reduceMotionOverride ?? UIAccessibility.isReduceMotionEnabled
    }

    internal init(alignment: Alignment, appearance: SnackbarManager.Appearance) {
        self.alignment = alignment
        self.appearance = appearance
        super.init(frame: .zero)
    }

    internal required init?(coder: NSCoder) { nil }

    internal func addHostView(_ hostView: SnackHostView, completion: @escaping () -> Void) {
        if window == nil { build() }

        addHostViewWithInitialAppearance(hostView)
        performAddAnimation(on: hostView, completion: completion)
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

        if isReduceMotionEnabled {
            // update the positions before the transition
            self.layoutIfNeeded()
            UIView.transition(
                with: self,
                duration: appearance.removeAnimation.duration,
                options: .transitionCrossDissolve,
                animations: {
                    hostView.alpha = 0
                }
            ) { _ in
                completion(hostView)
            }
        } else {
            UIView.animate(
                with: appearance.removeAnimation,
                animations: {
                    self.layoutIfNeeded()
                }
            ) {  _ in
                completion(hostView)
            }
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

        updateConstraintsOnRearrange(hostView: hostView, latest: latestHostView)
        linkHostViewsOnRearrange(hostView: hostView)

        bringSubviewToFront(hostView)

        if isReduceMotionEnabled {
            // update the positions before the transition
            self.layoutIfNeeded()
            UIView.transition(
                with: self,
                duration: appearance.rearrangeAnimation.duration,
                options: .transitionCrossDissolve,
                animations: { }
            ) { _ in
                completion()
            }
        } else {
            UIView.animate(
                with: appearance.rearrangeAnimation,
                animations: {
                    self.layoutIfNeeded()
                }
            ) {  _ in
                completion()
            }
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

    func performAddAnimation(on hostView: SnackHostView, completion: @escaping () -> Void) {
        if isReduceMotionEnabled {
            UIView.transition(
                with: self,
                duration: appearance.addAnimation.duration,
                options: .transitionCrossDissolve,
                animations: {
                    hostView.alpha = 1
                }
            ) { _ in
                completion()
            }
        } else {
            UIView.animate(
                with: appearance.addAnimation,
                animations: {
                    self.layoutIfNeeded()
                }
            ) { _ in
                completion()
            }
        }
    }

    func updateConstraintsOnRemoving(hostView: SnackHostView) {
        guard let superview = superview else { return }

        let nextHostView = hostView.nextHostView
        let previousHostView = hostView.previousHostView

        switch alignment {
        case .top:
            hostView.deactivateBottomConstraint()
            if !isReduceMotionEnabled {
                hostView.deactivateTopConstraint()
                let offset = max(hostView.snack.appearance.elevation.extent.bottom, 0)
                hostView.setTopConstraint(
                    hostView.constrain(
                        .bottomAnchor,
                        to: superview.topAnchor,
                        constant: -offset
                    )
                )
            }

            nextHostView?.deactivateTopConstraint()

            nextHostView?.setTopConstraint(nextHostView?.constrain(
                .topAnchor,
                to: previousHostView?.bottomAnchor ?? topAnchor,
                constant: previousHostView == nil ? .zero : appearance.snackSpacing
            ))
        case .bottom:
            hostView.deactivateTopConstraint()
            if !isReduceMotionEnabled {
                hostView.deactivateBottomConstraint()
                let offset = max(hostView.snack.appearance.elevation.extent.top, 0)
                hostView.setBottomConstraint(
                    hostView.constrain(
                        .topAnchor,
                        to: superview.bottomAnchor,
                        constant: offset
                    )
                )
            }

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

    func updateConstraintsOnRearrange(hostView: SnackHostView, latest latestHostView: SnackHostView) {
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
                to: latestHostView.bottomAnchor,
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
                to: latestHostView.topAnchor,
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
