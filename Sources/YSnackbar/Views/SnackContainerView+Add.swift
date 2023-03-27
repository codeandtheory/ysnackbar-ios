//
//  SnackContainerView+Add.swift
//  YSnackbar
//
//  Created by Mark Pospesel on 3/27/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit

internal extension SnackContainerView {
    func addHostViewWithInitialAppearance(_ hostView: SnackHostView) {
        addSubview(hostView)
        setupInitialConstraints(for: hostView)
        if !isReduceMotionEnabled {
            updateConstraintsOnAdding(hostView: hostView)
        }
        linkHostViewsOnAdding(hostView: hostView)

        switch alignment {
        case .top:
            hostViews.append(hostView)
        case .bottom:
            hostViews.insert(hostView, at: .zero)
        }
    }
}

private extension SnackContainerView {
    func setupInitialConstraints(for hostView: SnackHostView) {
        guard let superview = superview else { return }

        let constraint: NSLayoutConstraint?

        if isReduceMotionEnabled {
            // put the view into its final position
            constraint = nil
            updateConstraintsOnAdding(hostView: hostView)
            hostView.alpha = 0
        } else {
            switch alignment {
            case .top:
                let offset = max(hostView.snack.appearance.elevation.extent.bottom, 0)
                constraint = hostView.constrain(.bottomAnchor, to: superview.topAnchor, constant: -offset)
            case .bottom:
                let offset = max(hostView.snack.appearance.elevation.extent.top, 0)
                constraint = hostView.constrain(.topAnchor, to: superview.bottomAnchor, constant: offset)
            }
        }

        hostView.constrain(.leadingAnchor, to: leadingAnchor)
        hostView.constrain(.trailingAnchor, to: trailingAnchor)

        layoutIfNeeded()

        constraint?.isActive = false
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
}
