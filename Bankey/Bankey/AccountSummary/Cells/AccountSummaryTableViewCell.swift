//
//  AccountSummaryTableViewCell.swift
//  Bankey
//
//  Created by Arunkumar on 19/05/25.
//

import UIKit


struct Account: Codable {
    let id: String
    let type: AccountType
    let name: String
    let amount: Decimal
    let createdDateTime: Date
}

enum AccountType: String, Codable {
    case Banking
    case Investment
    case CreditCard
}


class AccountSummaryTableViewCell: UITableViewCell {
    
    struct ViewModel {
        let accountType: AccountType
        let accountName: String
        let balance: Decimal
        
        var balanceAsAttributedString: NSAttributedString {
            return CurrencyFormatter().makeAttributedCurrency(balance)//CurrencyFormatter.formattedBalanceWithSuperscript(from: balance)
        }
    }
    
    let viewModel: ViewModel? = nil
    
    static let resueIdentifier = "AccountSummaryTableViewCell"
    static let rowHeight: CGFloat = UIScaler.scaled(100)
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Account Type"
        return label
    }()
    
    let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = appColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: UIScaler.scaled(4)).isActive = true
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Account Name"
        return label
    }()
    
    let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let balanceTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = "Some balance"
        return label
    }()
    
    lazy var balanceAmtTextLabel: UILabel = {
        let label = UILabel()
  //      label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    let chevronImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.right")!.withTintColor(appColor, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension AccountSummaryTableViewCell {
    
    private func setup() {
      //  balanceAmtTextLabel.attributedText = makeFormattedBalance(dollars: "929,466.63", cents: "23")//"$929,466.63"

    }
    
    private func layout() {
        
        contentView.addSubview(typeLabel)
        contentView.addSubview(underLineView)
        contentView.addSubview(nameLabel)
        
        stackView.addArrangedSubViews([balanceTextLabel, balanceAmtTextLabel])
        
        contentView.addSubview(stackView)
        contentView.addSubview(chevronImageView)
        
        //add constraints
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: topAnchor, constant: UIScaler.scaled(16)),
            typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIScaler.scaled(16)),
            
            underLineView.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: UIScaler.scaled(8)),
            underLineView.leadingAnchor.constraint(equalTo: typeLabel.leadingAnchor),
            underLineView.trailingAnchor.constraint(equalTo: typeLabel.trailingAnchor, constant: UIScaler.scaled(8)),
            
            nameLabel.topAnchor.constraint(equalTo: underLineView.bottomAnchor, constant: UIScaler.scaled(16)),
            nameLabel.leadingAnchor.constraint(equalTo: underLineView.leadingAnchor),
            
            chevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: UIScaler.scaled(-8)),
            chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            stackView.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: UIScaler.scaled(-16)),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

extension AccountSummaryTableViewCell {
    
    private func makeFormattedBalance(dollars: String, cents: String) -> NSMutableAttributedString {
        let dollarSignAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .callout), .baselineOffset: 8]
        let dollarAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .title2)]
        let centAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .footnote), .baselineOffset: 8]
        
        let rootString = NSMutableAttributedString(string: "$", attributes: dollarSignAttributes)
        let dollarString = NSAttributedString(string: dollars, attributes: dollarAttributes)
        let centString = NSAttributedString(string: cents, attributes: centAttributes)
        
        rootString.append(dollarString)
        rootString.append(centString)
        
        return rootString
    }
}


extension AccountSummaryTableViewCell {
    
    func configure(with vm: ViewModel) {
                
        typeLabel.text = vm.accountType.rawValue
        nameLabel.text = vm.accountName
        balanceAmtTextLabel.attributedText = vm.balanceAsAttributedString
        
        switch vm.accountType {
            
        case .Banking:
            underLineView.backgroundColor = appColor
            balanceTextLabel.text = "Current balance"
        case .CreditCard:
            underLineView.backgroundColor = .systemOrange
            balanceTextLabel.text = "Current balance"
        case .Investment:
            underLineView.backgroundColor = .systemPurple
            balanceTextLabel.text = "Value"
        }
    }
}
