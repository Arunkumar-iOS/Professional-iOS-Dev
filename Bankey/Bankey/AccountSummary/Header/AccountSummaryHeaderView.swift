//
//  AccountSummaryHeaderView.swift
//  Bankey
//
//  Created by Arunkumar on 19/05/25.
//

import UIKit


class AccountSummaryHeaderView: UIView {
    
    struct ViewModel {
        let welcomeText: String
        let name: String
        let date: Date
        
        var formattedDate: String {
            return date.monthDayYearString
        }
    }
    
    
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    let shakeyBellView = ShakeyBellView()
    
    // Required for loading from nib
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        
        //Load a nib file
        Bundle.main.loadNibNamed("AccountSummaryHeaderView", owner: self, options: nil)
        addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = appColor
        
        shakeyBellView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shakeyBellView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            //add constraint to shakey bell view
            shakeyBellView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shakeyBellView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 144)
    }
    
    
}


extension AccountSummaryHeaderView {
    
    func configure(viewModel: ViewModel) {
        
        welcomeLabel.text = viewModel.welcomeText
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.formattedDate
    }
}

struct Profile: Codable {
    let id: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
