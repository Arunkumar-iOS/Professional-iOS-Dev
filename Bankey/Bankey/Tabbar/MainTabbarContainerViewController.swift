//
//  MainTabbarContainerViewController.swift
//  Bankey
//
//  Created by Arunkumar on 17/05/25.
//

import UIKit


class MainTabbarContainerViewController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

extension MainTabbarContainerViewController {
    
    func style() {
        
        setupTabs()
        setupTabBar()
    }
    
    func layout() {

    }
    
    private func setupTabs() {
        
        let summaryNC = UINavigationController(rootViewController: AccountSummaryViewController())
        let moneyNC = UINavigationController(rootViewController: MoveMoneyViewController())
        let moreNC = UINavigationController(rootViewController: MoreViewController())
        
        summaryNC.setTabBarImage(imageName: "list.dash.header.rectangle", title: "Summary")
        moneyNC.setTabBarImage(imageName: "arrow.left.arrow.right", title: "Move Money")
        moreNC.setTabBarImage(imageName: "ellipsis.circle", title: "More")
        
        summaryNC.setStatusBar()
        summaryNC.navigationBar.backgroundColor = .white
   
        viewControllers = [summaryNC, moneyNC, moreNC]
    }
    
    private func setupTabBar() {
        tabBar.tintColor = appColor
        tabBar.isTranslucent = false
    }
    
   
}



//MARK:- Sample ViewControllers
class AccountSummaryViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .systemGreen
        
        title = "Summary"
    }
}

class MoveMoneyViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .systemOrange
    }
}

class MoreViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .systemPurple
    }
}
