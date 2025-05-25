//
//  AppDelegate.swift
//  PasswordValidation
//
//  Created by Arunkumar on 25/05/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        navigateToHome()
        
        return true
    }
    
    private func navigateToHome() {
        window = UIWindow()
        window?.backgroundColor = .systemBackground
        window?.rootViewController = PasswordValidationViewController()
        window?.makeKeyAndVisible()
    }


}

