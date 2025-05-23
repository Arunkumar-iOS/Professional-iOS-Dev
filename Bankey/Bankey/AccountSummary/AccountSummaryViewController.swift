//
//  AccountSummaryViewController.swift
//  Bankey
//
//  Created by Arunkumar on 19/05/25.
//

import UIKit

class AccountSummaryViewController: UIViewController {
    
    
    //For unit test purpose create a Dependency injector and use like this
    var apiCallManager: ProfileManagable = APICallManager()
    
    var profile: Profile?
    var profileHeaderViewModel = AccountSummaryHeaderView.ViewModel(welcomeText: "Welcome", name: "", date: Date())
    
    let header = AccountSummaryHeaderView()
    
    var accountCellViewModels: [AccountSummaryTableViewCell.ViewModel] = []
    var accounts: [Account] = []
    
    //Components
    var tableView = UITableView()
    let refreshControl = UIRefreshControl()
    var isLoaded = false
    
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
        setupRefreshControl()
        setupSkeletons()
        fetchData()
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = appColor
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupSkeletons() {
        let row = Account.makeSkeleton()
        accounts = Array(repeating: row, count: 10)
        
        configureTableCells(with: accounts)
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
        tableView.register(SkeletonTableViewCell.self, forCellReuseIdentifier: SkeletonTableViewCell.reuseID)
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
        guard !accountCellViewModels.isEmpty else { return UITableViewCell() }
        let account = accountCellViewModels[indexPath.row]

        if isLoaded {
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryTableViewCell.resueIdentifier, for: indexPath) as! AccountSummaryTableViewCell
            tableView.isUserInteractionEnabled = true
            cell.configure(with: account)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonTableViewCell.reuseID, for: indexPath) as! SkeletonTableViewCell
        tableView.isUserInteractionEnabled = false
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
    
    @objc func refreshContent() {
        reset()
        setupSkeletons()
        tableView.reloadData()
        fetchData()
    }
    
    private func reset() {
        profile = nil
        accounts = []
        isLoaded = false
    }
    
}



extension AccountSummaryViewController {
    
    fileprivate func fetchProfile(_ dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        apiCallManager.fetch(url: APIEndPoint.profile.fullURL) { (result: Result<Profile, NetworkError>) in
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(let error):
                self.displayErrorMessage(error: error)
            }
            dispatchGroup.leave()
        }
    }
    
    fileprivate func fetchAccounts(_ dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        WebService.shared.fetch(url: APIEndPoint.accounts.fullURL) { (result: Result<[Account], NetworkError>) in
            
            switch result {
            case .success(let account):
                self.accounts = account
            case .failure(let error):
                self.displayErrorMessage(error: error)
            }
            dispatchGroup.leave()
        }
    }
    
    private func reloadView() {
        self.tableView.refreshControl?.endRefreshing()
        
        guard let profile = self.profile else { return }
        
        self.isLoaded = true
        self.configureHeaderView(withProfile: profile) //
        self.configureTableCells(with: self.accounts) //
        self.tableView.reloadData()
    }
    
    private func fetchData() {
        
        let dispatchGroup = DispatchGroup()
        
        fetchProfile(dispatchGroup)
        fetchAccounts(dispatchGroup)
        
        dispatchGroup.notify(queue: .main) {
            self.reloadView()
        }
    }
    
    func displayErrorMessage(error: NetworkError) {
        let alertContent = error.alertContent
        showAlertMessage(title: alertContent.title, message: alertContent.message)
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


//MARK:- For Unit test purpose
extension AccountSummaryViewController {
    
    func forceFetchProfile() {
        
        fetchProfile(DispatchGroup())
    }
}
