//
//  AppDelegate.swift
//  Bankey
//
//  Created by Arunkumar on 14/05/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let loginViewController = LoginViewController()
    let onboardContainerViewController = OnboardingContainerViewController()
    let dummyViewController = DummyViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        navigateToHome()
        
        return true
    }

 
    private func navigateToHome() {
        
        loginViewController.delegate = self
        onboardContainerViewController.delegate = self
        dummyViewController.delegate = self
        
        window = UIWindow()
        window?.rootViewController = loginViewController
       // window?.rootViewController = OnboardingContainerViewController()
        window?.makeKeyAndVisible()
        
        
    
        
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

extension AppDelegate: LoginViewControllerDelegate, OnboardContainerViewControllerDelegate, DummyViewControllerDelegate {
    
    func didTapLogout() {
        transitionTo(loginViewController)
    }
    
    
    func onboardingDidFinish() {
        UserDefaults.hasOnboarded = true
        transitionTo(dummyViewController)
    }
        
    func didLogIn() {
        self.transitionTo(UserDefaults.hasOnboarded == true ? dummyViewController : onboardContainerViewController)
    }
    
    
    
}
