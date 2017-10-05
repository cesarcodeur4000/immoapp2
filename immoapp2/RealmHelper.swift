//
//  RealmHelper.swift
//  immoapp2
//
//  Created by etudiant on 5/10/17.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit
import RealmSwift

class RealmHelper: NSObject {

    
   static func commonRealmConfig(user: SyncUser) -> Realm.Configuration  {
        let config = Realm.Configuration(syncConfiguration: SyncConfiguration(user: user, realmURL: Constants.syncServerURL!), objectTypes: [Dog.self])
        return config
    }
    
    
}
