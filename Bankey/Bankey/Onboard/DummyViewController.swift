//
//  DummyViewController.swift
//  Bankey
//
//  Created by Arunkumar on 17/05/25.
//

import UIKit

protocol DummyViewControllerDelegate: AnyObject {
    func didTapLogout()
}

class DummyViewController: UIViewController {
    
    let stackView = UIStackView()
    let label = UILabel()
    
    var delegate: DummyViewControllerDelegate?
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.addTarget(self, action: #selector(logoutTapped), for: .primaryActionTriggered)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

extension DummyViewController {
    func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dummy"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        
        view.backgroundColor = .systemBackground
    }
    
    func layout() {
        stackView.addArrangedSubViews([label, logoutButton])
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}


//Mark:- Actions
extension DummyViewController {
    
    @objc func logoutTapped() {
        delegate?.didTapLogout()
    }
}
