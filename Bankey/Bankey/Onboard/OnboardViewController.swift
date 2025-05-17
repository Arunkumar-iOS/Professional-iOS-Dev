//
//  OnboardViewController.swift
//  Bankey
//
//  Created by Arunkumar on 17/05/25.
//

import UIKit



class OnboardViewController: UIViewController {
    
    let labelText: String
    let imgName: String
    
    
    let stackView: UIStackView = {
        let stackView = VerticalStackView()
        stackView.spacing = UIScaler.scaled(16)
        return stackView
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    let OnboardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    init(labelText: String, imageName: String) {
        self.labelText = labelText
        self.imgName = imageName
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()

    }
}


extension OnboardViewController {
    
    private func style() {
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .systemBackground
        
        textLabel.text = labelText
        OnboardImageView.image = UIImage(named: imgName)
        
    }
    
    private func layout() {
        
        stackView.addArrangedSubview(OnboardImageView)
        stackView.addArrangedSubview(textLabel)
        
        view.addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
