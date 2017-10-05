//
//  LoginViewController.swift
//  immoapp2
//
//  Created by etudiant on 5/10/17.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit
import RealmSwift
import RealmLoginKit

class LoginViewController: UIViewController {
    
    
    var loginViewController: LoginViewController!
    var token: NotificationToken!
    var myIdentity = SyncUser.current?.identity!
    
    override func viewDidAppear(_ animated: Bool) {
        loginViewController = LoginViewController(style: .lightOpaque)
        loginViewController.isServerURLFieldHidden = false
        loginViewController.isRegistering = true
        
        if (SyncUser.current != nil) {
            // yup - we've got a stored session, so just go right to the UITabView
            Realm.Configuration.defaultConfiguration = commonRealmConfig(user: SyncUser.current!)
            
            performSegue(withIdentifier: Constants.kLoginToMainView, sender: self)
        } else {
            // show the RealmLoginKit controller
            if loginViewController!.serverURL == nil {
                loginViewController!.serverURL = Constants.syncAuthURL.absoluteString
            }
            // Set a closure that will be called on successful login
            loginViewController.loginSuccessfulHandler = { user in
                DispatchQueue.main.async {
                    // this AsyncOpen call will open the described Realm and wait for it to download before calling its closure
                    Realm.asyncOpen(configuration: commonRealmConfig(user: SyncUser.current!)) { realm, error in
                        if let realm = realm {
                            Realm.Configuration.defaultConfiguration = commonRealmConfig(user: SyncUser.current!)
                            self.loginViewController!.dismiss(animated: true, completion: nil)
                            self.performSegue(withIdentifier: Constants.kLoginToMainView, sender: nil)
                            
                        } else if let error = error {
                            print("An error occurred while logging in: \(error.localizedDescription)")
                        }
                    } // of asyncOpen()
                    
                } // of main queue dispatch
            }// of login controller
            
            present(loginViewController, animated: true, completion: nil)
        }
    }
    
    func commonRealmConfig(user: SyncUser) -> Realm.Configuration  {
        let config = Realm.Configuration(syncConfiguration: SyncConfiguration(user: user, realmURL: Constants.syncServerURL), objectTypes: [Person.self])
        return config
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
