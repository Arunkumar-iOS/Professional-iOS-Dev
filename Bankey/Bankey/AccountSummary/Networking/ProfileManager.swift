//
//  ProfileManager.swift
//  Bankey
//
//  Created by Arunkumar on 23/05/25.
//

import UIKit


protocol ProfileManagable: AnyObject {
    
    func fetch<T: Codable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void)
}
