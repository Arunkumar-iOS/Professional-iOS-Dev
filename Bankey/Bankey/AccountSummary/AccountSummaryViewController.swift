//
//  AccountSummaryViewController.swift
//  Bankey
//
//  Created by Arunkumar on 19/05/25.
//

import UIKit

class AccountSummaryViewController: UIViewController {
    
//    var profile: Profile?
    var profileHeaderViewModel = AccountSummaryHeaderView.ViewModel(welcomeText: "Welcome", name: "", date: Date())
    
    let header = AccountSummaryHeaderView()
    
    var accountCellViewModels: [AccountSummaryTableViewCell.ViewModel] = []
    var tableView = UITableView()
    
    lazy var navigationBarLogoutBtn: UIBarButtonItem = {
        let logoutBtn = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonTapped))
        logoutBtn.tintColor = .label
        return logoutBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

extension AccountSummaryViewController {
    
    private func setup() {
        setupNavigationBar()
        setupTableView()
        setupHeaderView()
        fetchDataFromServer()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = navigationBarLogoutBtn
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = appColor
        view.addSubview(tableView)
        
        registerCell()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func registerCell() {
        tableView.register(AccountSummaryTableViewCell.self, forCellReuseIdentifier: AccountSummaryTableViewCell.resueIdentifier)
        tableView.rowHeight = AccountSummaryTableViewCell.rowHeight
        tableView.tableFooterView = UIView()
    }
    
    private func setupHeaderView() {
        
        
        // Calculate fitting height based on content
        let targetSize = CGSize(width: tableView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let fittingSize = header.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        
        header.frame = CGRect(origin: .zero, size: fittingSize)
        tableView.tableHeaderView = header

    }
}

extension AccountSummaryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryTableViewCell.resueIdentifier, for: indexPath) as! AccountSummaryTableViewCell
        guard !accountCellViewModels.isEmpty else { return AccountSummaryTableViewCell() }
        let account = accountCellViewModels[indexPath.row]
        cell.configure(with: account)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountCellViewModels.count
    }
}

extension AccountSummaryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK:- Actions
extension AccountSummaryViewController {
    
    @objc func logoutButtonTapped() {
       
        NotificationCenter.default.post(name: .logoutButtonTapped, object: nil)
    }
     
}



extension AccountSummaryViewController {
    
    private func fetchDataFromServer() {
        
        WebService.shared.fetch(url: APIEndPoint.profile.fullURL) { [weak self] (result: Result<Profile, NetworkError>) in
            switch result {
            case .success(let profile):
                self?.configureHeaderView(withProfile: profile)
                self?.tableView.reloadData()
            case .failure(let error):
                print("Error:", error.localizedDescription)
            }
        }
    
        WebService.shared.fetch(url: APIEndPoint.accounts.fullURL) {[weak self] (result: Result<[Account], NetworkError>) in
    
            switch result {
                case .success(let account):
                self?.configureTableCells(with: account)
                self?.tableView.reloadData()
            case .failure(let error):
                print("Error:", error.localizedDescription)
            }
        }
    }
}

//Configuring data's
extension AccountSummaryViewController {
    
    private func configureHeaderView(withProfile profile: Profile) {
        let vm = AccountSummaryHeaderView.ViewModel(welcomeText: "Hello Good morning,",
                                                    name: profile.firstName,
                                                    date: Date())
        header.configure(viewModel: vm)
    }
    
    private func configureTableCells(with accounts: [Account]) {
        //Transform account into account view model
          accountCellViewModels = accounts.map {
              AccountSummaryTableViewCell.ViewModel(accountType: $0.type,
                                           accountName: $0.name,
                                           balance: $0.amount)
          }
      }
}



