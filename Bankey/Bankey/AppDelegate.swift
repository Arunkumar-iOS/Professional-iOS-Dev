//
//  AppDelegate.swift
//  Bankey
//
//  Created by Arunkumar on 14/05/25.
//

import UIKit

let appColor = UIColor.systemTeal

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let loginViewController = LoginViewController()
    let onboardContainerViewController = OnboardingContainerViewController()
    let mainTabbarViewController = MainTabbarContainerViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        navigateToHome()
        
        return true
    }

 
    private func navigateToHome() {
        
        //Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(logoutTapped), name: .logoutButtonTapped, object: nil)
        
        
        loginViewController.delegate = self
        onboardContainerViewController.delegate = self
        
        window = UIWindow()
       // window?.rootViewController = AccountSummaryViewController()
        window?.rootViewController = UserDefaults.hasOnboarded == true ? mainTabbarViewController : loginViewController
       // window?.rootViewController = OnboardingContainerViewController()
       // window?.rootViewController = MainTabbarContainerViewController()
        window?.makeKeyAndVisible()
    }
    
    @objc func logoutTapped() {
        
        transitionTo(loginViewController)
    }
    
    func transitionTo(_ newViewController: UIViewController) {
        
        guard let window = window else { return }
        // Add the new view controller's view temporarily
        newViewController.view.frame = window.bounds
        newViewController.view.alpha = 0
        window.addSubview(newViewController.view)
        
        // Animate the crossfade
        UIView.animate(withDuration: 0.9, animations: {
            newViewController.view.alpha = 1
        }) { _ in
            // Set it as rootViewController after animation completes
            window.rootViewController = newViewController
            window.makeKeyAndVisible()
        }
    }


}

extension AppDelegate: LoginViewControllerDelegate, OnboardContainerViewControllerDelegate {
    
    func didTapLogout() {
        UserDefaults.removeAll()
        transitionTo(loginViewController)
    }
    
    
    func onboardingDidFinish() {
        UserDefaults.hasOnboarded = true
        transitionTo(mainTabbarViewController)
    }
        
    func didLogIn() {
        self.transitionTo(UserDefaults.hasOnboarded == true ? mainTabbarViewController : onboardContainerViewController)
    }
    
    
    
}
