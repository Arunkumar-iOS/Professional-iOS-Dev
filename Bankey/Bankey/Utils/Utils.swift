//
//  Utils.swift
//  Bankey
//
//  Created by Arunkumar on 17/05/25.
//

import Foundation


extension UserDefaults {
    
    private enum Keys {
        static let hasOnboarded = "hasOnboarded"
    }

    static var hasOnboarded: Bool {
        get { standard.bool(forKey: Keys.hasOnboarded) }
        set { standard.set(newValue, forKey: Keys.hasOnboarded) }
    }
    
    static func removeAll() {
        standard.removeObject(forKey: Keys.hasOnboarded)
    }

}
