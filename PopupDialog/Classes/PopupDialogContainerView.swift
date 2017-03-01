//
//  PopupDialogContainerView.swift
//  Pods
//
//  Copyright (c) 2016 Orderella Ltd. (http://orderella.co.uk)
//  Author - Martin Wildfeuer (http://www.mwfire.de)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import UIKit

/// The main view of the popup dialog
final public class PopupDialogContainerView: UIView {

    // MARK: - Appearance

    /// The background color of the popup dialog
    override public dynamic var backgroundColor: UIColor? {
        get { return container.backgroundColor }
        set { container.backgroundColor = newValue }
    }

    /// The corner radius of the popup view
    public dynamic var cornerRadius: Float {
        get { return Float(gesturesContainerView.layer.cornerRadius) }
        set {
            let radius = CGFloat(newValue)
            gesturesContainerView.layer.cornerRadius = radius
            container.layer.cornerRadius = radius
        }
    }

    /// Enable / disable shadow rendering
    public dynamic var shadowEnabled: Bool {
        get { return gesturesContainerView.layer.shadowRadius > 0 }
        set { gesturesContainerView.layer.shadowRadius = newValue ? 5 : 0 }
    }

    /// The shadow color
    public dynamic var shadowColor: UIColor? {
        get {
            guard let color = gesturesContainerView.layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set { gesturesContainerView.layer.shadowColor = newValue?.cgColor }
    }

    public dynamic var marginInsets: PopupMargins = PopupMargins(left: 10, right: 10) {
        didSet {
            if oldValue == marginInsets { return }
            removeConstraints(constraints)
            setupConstraints()
        }
    }

    // MARK: - Views

    /// The shadow container is the basic view of the PopupDialog
    /// As it does not clip subviews, a shadow can be applied to it
    internal lazy var gesturesContainerView: UIView = {
        let shadowContainer = UIView(frame: .zero)
        shadowContainer.translatesAutoresizingMaskIntoConstraints = false
        shadowContainer.backgroundColor = UIColor.clear
        shadowContainer.layer.shadowColor = UIColor.black.cgColor
        shadowContainer.layer.shadowRadius = 5
        shadowContainer.layer.shadowOpacity = 0.4
        shadowContainer.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowContainer.layer.cornerRadius = 4
        return shadowContainer
    }()

    /// The container view is a child of shadowContainer and contains
    /// all other views. It clips to bounds so cornerRadius can be set
    internal lazy var container: UIView = {
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.white
        container.clipsToBounds = true
        container.layer.cornerRadius = 4
        return container
    }()

    // The container stack view for buttons
    internal lazy var buttonStackView: UIView = {
        if #available(iOS 9.0, *) {
            let buttonStackView = UIStackView()
            buttonStackView.translatesAutoresizingMaskIntoConstraints = false
            buttonStackView.distribution = .fillEqually
            buttonStackView.spacing = 0
            return buttonStackView
        } else {
            let buttonStackView = TZStackView()
            buttonStackView.translatesAutoresizingMaskIntoConstraints = false
            buttonStackView.distribution = .fillEqually
            buttonStackView.spacing = 0
            return buttonStackView
        }
    }()

    // The main stack view, containing all relevant views
    internal lazy var stackView: UIView = {
        if #available(iOS 9.0, *) {
            let stackView = UIStackView(arrangedSubviews: [self.buttonStackView])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.spacing = 0
            return stackView
        } else {
            let stackView = TZStackView(arrangedSubviews: [self.buttonStackView])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.spacing = 0
            return stackView
        }
    }()

    // MARK: - Constraints

    /// The center constraint of the shadow container
    internal var centerYConstraint: NSLayoutConstraint? = nil

    // MARK: - Initializers

    internal override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View setup
    internal func setupViews() {
        // Add views
        addSubview(gesturesContainerView)
        addSubview(container)
        container.addSubview(stackView)
    }

    func setupConstraints() {
        // Layout views
        let views = ["shadowContainer": gesturesContainerView, "container": container, "stackView": stackView]
        var constraints = [NSLayoutConstraint]()

        // Container constraints
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(==" + "\(marginInsets.left)" + ")-[container]-(==" + "\(marginInsets.right)" + ")-|", options: [], metrics: nil, views: views)

        if let top = marginInsets.top,
            let bottom = marginInsets.bottom {
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-" + "\(top)" + "-[container]-" + "\(bottom)" + "-|", options: [], metrics: nil, views: views)
        } else {
            centerYConstraint = NSLayoutConstraint(item: container, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            constraints.append(centerYConstraint!)
        }

        // Main stack view constraints
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: [], metrics: nil, views: views)

        //gesturesContainerView
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[shadowContainer]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[shadowContainer]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: views)
        
        // Activate constraints
        NSLayoutConstraint.activate(constraints)
    }
}
