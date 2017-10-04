//
//  Constants.swift
//  immoapp2
//
//  Created by etudiant on 3/10/17.
//  Copyright © 2017 etudiant. All rights reserved.
//

import Foundation
struct Constants {
    
    static let syncHost = "127.0.0.1"
    
    static let syncRealmPath = "myyyrealmtasks"
    static let defaultListName = "My Tasks"
    static let defaultListID = "80EB1620-165B-4600-A1B1-D97032FDD9A0"
    
   // static let syncServerURL = URL(string: "realm://\(syncHost):9080/~/\(syncRealmPath)")
   
   static let syncServerURL = URL(string: "realm://\(syncHost)::9080/ee7d3fbe38b7f05887579327377c62f2/myyyrealmtasks")
    
    static let syncAuthURL = URL(string: "http://\(syncHost):9080")!
    
    static let appID = Bundle.main.bundleIdentifier!
}
