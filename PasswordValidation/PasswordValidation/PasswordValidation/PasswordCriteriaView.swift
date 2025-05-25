//
//  PasswordCriteriaView.swift
//  PasswordValidation
//
//  Created by Arunkumar on 25/05/25.
//

import UIKit


class PasswordCriteriaView: UIView {
    
    var labelText: String
    var showDescription: Bool = false
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    lazy var descriptionlabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        label.attributedText = setTextColorforSomePart(fullText: "Use at least 3 of these 4 criteria when setting your password:", changeColorTo: "3 of these 4")
        return label
    }()
    
    let checkBoxImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "circle")!.withTintColor(.tertiaryLabel, renderingMode: .alwaysOriginal))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.frame = .init(x: 0, y: 0, width: 30, height: 30)
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    let descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    init(labelText: String, showDescription: Bool = false) {
        self.labelText = labelText
        self.showDescription = showDescription
        
        super.init(frame: .zero)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        .init(width: 200, height: 50)
    }
}

extension PasswordCriteriaView {
    
    private func style() {
        textLabel.text = labelText
        
        descriptionlabel.isHidden = !showDescription
        descriptionStackView.layoutIfNeeded()
    }
    
    private func layout() {
        
        stackView.addArrangedSubviews([checkBoxImageView, textLabel])
        
        descriptionStackView.addArrangedSubviews([stackView, descriptionlabel])
        
        addSubview(descriptionStackView)
        
        NSLayoutConstraint.activate([
            descriptionStackView.topAnchor.constraint(equalTo: topAnchor),
            descriptionStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionStackView.bottomAnchor.constraint(equalTo: bottomAnchor) 
        ])
    }
}


extension UIView {
    /// Sets attributed text with one part bolded, works with UILabel or UITextView
    func setTextColorforSomePart(fullText: String, changeColorTo: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if let boldRange = fullText.range(of: changeColorTo) {
            let nsRange = NSRange(boldRange, in: fullText)
            
            // Add bold font and custom color
               attributedString.addAttributes([
                .font: UIFont.systemFont(ofSize: 14, weight: .medium),
                   .foregroundColor: UIColor.systemRed // Change to any color you want
               ], range: nsRange)
        }

     return attributedString
    }
}
