//
//  SeparatorView.swift
//  Bankey
//
//  Created by Arunkumar on 14/05/25.
//

import UIKit

class SeparatorView: UIView {
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemFill
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 1)
    }
}


extension SeparatorView {
    
    private func style() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layout() {
        
        addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
