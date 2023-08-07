//
//  SnackbarManager.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 15/09/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import Foundation
import UIKit

/// Manages an array of snacks
public class SnackbarManager {
    /// Alignment for the snack. Default is top.
    public static var defaultAlignment: Alignment = .top

    private(set) var containerView: SnackContainerView?

    private(set) var snacks: [Snack] = []
    private let alignment: Alignment
    private(set) var snackTimerDict: [Snack: Timer?] = [:]

    internal static let sharedTop = SnackbarManager(alignment: .top)
    internal static let sharedBottom = SnackbarManager(alignment: .bottom)

    private init(alignment: Alignment) {
        self.alignment = alignment
    }

    internal var appearance: Appearance = .default {
        didSet {
            containerView?.appearance = appearance
        }
    }

    /// Control animation duration and spacing
    public static var appearance: Appearance {
        get { sharedTop.appearance }
        set {
            sharedTop.appearance = newValue
            sharedBottom.appearance = newValue
        }
    }

    /// Adds a snack to the screen
    /// - Parameter snack: snack to be added
    public class func add(snack: Snack) {
        switch snack.alignment {
        case .top:
            sharedTop.add(snack: snack)
        case .bottom:
            sharedBottom.add(snack: snack)
        }
    }

    /// Removes a snack from the screen
    /// - Parameter snack: snack to be removed
    public class func remove(snack: Snack) {
        switch snack.alignment {
        case .top:
            sharedTop.remove(snack: snack)
        case .bottom:
            sharedBottom.remove(snack: snack)
        }
    }

    internal func add(snack: Snack) {
        if let index = snacks.firstIndex(of: snack) {
            invalidateTimerIfNeeded(for: snack)
            snacks.remove(at: index)
            snacks.append(snack)

            let hostView = containerView?.rearrangeHostView(at: index) { [weak self] in
                self?.startTimerIfNeeded(for: snack)
            }

            hostView?.update(snack)
        } else {
            snacks.append(snack)
            makeContainerViewIfNeeded()

            let hostView = SnackHostView(snackView: snack.getSnackAssociatedView())
            containerView?.addHostView(hostView) { [weak self] in
                self?.startTimerIfNeeded(for: snack)
            }
        }
    }

    internal func remove(snack: Snack) {
        guard let index = snacks.firstIndex(of: snack) else { return }
        snacks.remove(at: index)
        containerView?.removeHostView(at: index)
    }

    internal func startTimerIfNeeded(for snack: Snack) {
        guard snack.duration != .nan && snack.duration != .zero else { return }
        
        // Disable auto removal if `voRequiresInteraction` and `isVoiceOverRunning` enable.
        if UIAccessibility.isVoiceOverRunning && snack.voRequiresInteraction {
            return
        }
        let timer = Timer.scheduledTimer(withTimeInterval: snack.duration, repeats: false) { [weak self] _ in
            guard let self = self else { return }

            self.onTimerEnded(snack: snack)
            self.invalidateTimerIfNeeded(for: snack)
        }

        snackTimerDict[snack] = timer
    }

    internal func onTimerEnded(snack: Snack) {
        remove(snack: snack)
    }

    internal func invalidateTimerIfNeeded(for snack: Snack) {
        guard let timer = snackTimerDict[snack] else { return }
        timer?.invalidate()
        snackTimerDict[snack] = nil
    }
}

private extension SnackbarManager {
    func makeContainerViewIfNeeded() {
        if containerView == nil {
            let containerView = SnackContainerView(alignment: alignment, appearance: appearance)
            containerView.delegate = self
            self.containerView = containerView
        }
    }
}

extension SnackbarManager: SnackContainerViewDelegate {
    func didRemoveContainerView() {
        containerView = nil
    }
}

// Test helper
extension SnackbarManager {
    final class SnackbarManagerSpy: SnackbarManager {
        var startTimer = false

        override init(alignment: Alignment) {
            super.init(alignment: alignment)
        }

        override func startTimerIfNeeded(for snack: Snack) {
            super.startTimerIfNeeded(for: snack)
            if startTimer { onTimerEnded(snack: snack) }
        }

        func updateContainerView(_ view: SnackContainerView) {
            containerView = view
        }

        func removeAllSnack() {
            snacks.removeAll()
        }

        class func reset() {
            sharedTop.snacks.removeAll()
            sharedBottom.snacks.removeAll()
            SnackbarManager.defaultAlignment = .top
        }
    }
}
