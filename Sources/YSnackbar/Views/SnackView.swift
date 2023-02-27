//
//  SnackView.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 01/09/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit
import YMatterType

/// A view that represents a `Snack`.
open class SnackView: UIView {
    /// A snack data model for the `SnackView`.
    public private(set) var snack: Snack {
        didSet {
            updateViewContent()
            updateViewAppearance()
        }
    }

    /// A label to display title text.
    public let titleLabel: TypographyLabel = {
        let label = TypographyLabel(typography: .systemLabel.bold)
        label.numberOfLines = 1
        return label
    }()

    /// A  label to display message text.
    public let messageLabel: TypographyLabel = {
        let label = TypographyLabel(typography: .systemLabel)
        label.numberOfLines = 0
        return label
    }()

    /// An image view to display the optional icon.
    public let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()

    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    private var appearance: Appearance { snack.appearance }

    /// Initializes a `SnackView`.
    /// - Parameter snack: data model to use
    public init(snack: Snack) {
        self.snack = snack
        super.init(frame: .zero)

        build()
        updateViewAppearance()
        updateViewContent()
    }

    /// :nodoc:
    required public init?(coder: NSCoder) { nil }
}

private extension SnackView {
    func build() {
        buildViews()
        buildConstraints()
    }

    func buildViews() {
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(messageLabel)

        horizontalStackView.addArrangedSubview(iconImageView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        
        addSubview(horizontalStackView)
    }

    func buildConstraints() {
        iconImageView.constrain(.widthAnchor, constant: appearance.layout.iconSize.width)
        iconImageView.constrain(.heightAnchor, constant: appearance.layout.iconSize.height)

        horizontalStackView.constrainEdges(with: appearance.layout.contentInset)
    }

    func updateViewContent() {
        titleLabel.text = snack.title
        messageLabel.text = snack.message
        iconImageView.image = snack.icon
    }

    func updateViewAppearance() {
        titleLabel.isHidden = snack.title == nil ? true : false
        iconImageView.isHidden = snack.icon == nil ? true : false

        backgroundColor = appearance.backgroundColor
        titleLabel.textColor = appearance.title.textColor
        titleLabel.typography = appearance.title.typography
        messageLabel.textColor = appearance.message.textColor
        messageLabel.typography = appearance.message.typography

        verticalStackView.spacing = appearance.layout.labelSpacing
        horizontalStackView.spacing = appearance.layout.iconToLabelSpacing
    }
}

extension SnackView: SnackUpdatable {
    /// Updates the snack view's model object.
    /// - Parameter snack: new snack object
    public func update(_ snack: Snack) {
        self.snack = snack
    }
}
