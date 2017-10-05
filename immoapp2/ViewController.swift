//
//  ViewController.swift
//  immoapp2
//
//  Created by etudiant on 3/10/17.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit
import Realm
import RealmSwift


class ViewController: UIViewController {

    var username: String = "realmuser1@realm.com"//"cc"//"realm@realm.com"
    var password: String = "realm4000"//"cc"//"realm"//
    var items = List<Task>()
    var itemsdogs = List<Dog>()
    var realm: Realm!
    var user: SyncUser!
    
    @IBOutlet weak var labelmain: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // items.append(Task(value: ["text": "My First Task"]))
        
        let usernameCredentials = SyncCredentials.usernamePassword(username: username, password: password)
        
        SyncUser.logIn(with: usernameCredentials,
                       server: Constants.syncAuthURL) { user, error in
                        if let user = user {
                            print("user access okkkk")
                            self.user = user
                            self.setDefaultRealmConfiguration(with: user)
                            //user.logOut()
                            print("config ok")
                            self.realm = try! Realm()
                            // can now open a synchronized Realm with this user
                        } else if let error = error {
                            // handle error
                            self.showError(title: "Unable to Sign In", message: error.localizedDescription)
                        }
        }

       //DispatchQueue.main.async {
       //    self.realm = try! Realm(configuration: Realm.Configuration.defaultConfiguration )
      // }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK:- UTIL
    private func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- IBACTION
    @IBAction func actbutton(_ sender: Any) {
        
        
         DispatchQueue(label: "io.realm.RealmTasks.bg").async {
            let realm = try! Realm()
        do { try realm.write {
                            let myDog = Dog()
                            myDog.name = "Rex888"
                            myDog.age = 10
                            print(myDog.age,myDog.name)
                            realm.add(myDog)
            
                        }
                      }
                      catch let error as NSError {
                            print("Something went wrong: \(error.localizedDescription)")
                        }
    
        }
//            try! self.realm.write {
//                let list = TaskList()
//                //list.id = Constants.defaultListID
//                list.text = Constants.defaultListName
//                //DEBUG
//                print(list.id,list.text)
//                let listLists = TaskListList()
//                listLists.items.append(list)
//                self.realm.add(listLists)
//            
//        }
        
        
        //user.logOut()
        //updateList()
        //grantaccess()
    
    }
    
    private var authenticationFailureCallback: (() -> Void)?
    public func setDefaultRealmConfiguration(with user: SyncUser) {
        SyncManager.shared.errorHandler = { error, session in
            if let authError = error as? SyncAuthError, authError.code == .invalidCredential {
                self.authenticationFailureCallback?()
            }
        }
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            syncConfiguration: SyncConfiguration(user: user, realmURL: Constants.syncServerURL!),
            //objectTypes: [TaskListList.self, TaskList.self, Task.self]
        objectTypes: [Dog.self]
        )
        
    }
        //realm = try! Realm()
        
        //if realm.isEmpty {
            
          //  print("empty")
//          do { try realm.write {
//                let myDog = Dog()
//                myDog.name = "Rex"
//                myDog.age = 10
//                realm.add(myDog)
//            
//            }
//          }
//          catch let error as NSError {
//                print("Something went wrong: \(error.localizedDescription)")
//            }
            
           //updateList2()
          //   add()
//            try! realm.write {
//                let list = TaskList()
//                list.id = Constants.defaultListID
//                list.text = Constants.defaultListName
//                //DEBUG
//                print(list.id,list.text)
//                let listLists = TaskListList()
//                listLists.items.append(list)
//                realm.add(listLists)
//            }
//            realm.beginWrite()
//            do {try realm.commitWrite()
//                }
//            
//            catch let error as NSError {
//                print("Something went wrong: \(error.localizedDescription)")
////            }
//        }
//        else{
//             print("notempty")
//        }
//    }
    func add() {
        let alertController = UIAlertController(title: "New Task", message: "Enter Task Name", preferredStyle: .alert)
        var alertTextField: UITextField!
        alertController.addTextField { textField in
            alertTextField = textField
            textField.placeholder = "Task Name"
        }
        alertController.addAction(UIAlertAction(title: "Add", style: .default) { _ in
            guard let text = alertTextField.text , !text.isEmpty else { return }
            
            let items = self.items
            try! items.realm?.write {
                items.insert(Task(value: ["text": text]), at: items.filter("completed = false").count)
            }
        })
        present(alertController, animated: true, completion: nil)
    }
    
    
    func writelist_to_realmserver(){
        
        let items = realm.objects(TaskListList.self).first!.items
        guard items.count > 1 && !realm.isInWriteTransaction else { return }
        let itemsReference = ThreadSafeReference(to: items)
        // Deduplicate
        DispatchQueue(label: "io.realm.RealmTasks.bg").async {
            let realm = try! Realm(configuration: self.realm.configuration)
            guard let items = realm.resolve(itemsReference), items.count > 1 else {
                return
            }
            realm.beginWrite()
            let listReferenceIDs = NSCountedSet(array: items.map { $0.id })
            for id in listReferenceIDs where listReferenceIDs.count(for: id) > 1 {
                let id = id as! String
                let indexesToRemove = items.enumerated().flatMap { index, element in
                    return element.id == id ? index : nil
                }
                indexesToRemove.dropFirst().reversed().forEach(items.remove(objectAtIndex:))
            }
            try! realm.commitWrite()

        
        
        
        }
    
    }
    
    
    
    //update local list from realm server
    func updateList() {
         let realm = try! Realm()
        
        if  let list = realm.objects(Dog.self).sorted(byKeyPath: "name").first
            /*TaskList.self*/
        {
            self.itemsdogs.append(list) //.items
            print(" LOCAL LIST : \(self.itemsdogs.count) elements")
        }
        //self.tableView.reloadData()
    }
    //grant access
    func grantaccess(){
        
        let permission = SyncPermissionValue(realmPath: realm.configuration.syncConfiguration!.realmURL.path ,userID: "*", // To apply to all users
            accessLevel: .write)
        print("REALM PATH=",realm.configuration.syncConfiguration!.realmURL.path)
        SyncUser.current?.applyPermission(permission) { error in
            if let error = error {
                // handle error
                self.showError(title: "Unable to grant permission", message: error.localizedDescription)
                return
            }
    }
    }
    
    func updateList2() {
        print("first empty in uptadelist2")
        if self.realm.objects(TaskList.self).count == 0 {
            
            print("empty in uptadelist2")
            let list = TaskList()
            list.id = "000001"
            list.text = "lista de prueba"
            print(list.id,list.text)
            
            // Add to the Realm inside a transaction
            try! self.realm.write {
                print("inside try")
                self.realm.add(list)
            }
            
        }
        if self.items.realm == nil, let list = self.realm.objects(TaskList.self).first {
            self.items = list.items
        }
        //self.tableView.reloadData()
    }
    
    
    //EXEMPLE UPDATE
    
    func updatewithrealm(){
        
        
    let realm = try! Realm()
        let person = Dog()
        person.name =  "Jane"
        person.age =  5 // no primary key required
    try! realm.write {
    realm.add(person)
    }
    let personRef = ThreadSafeReference(to: person)
    DispatchQueue(label: "com.example.myApp.bg").async {
    let realm = try! Realm()
    guard let person = realm.resolve(personRef) else {
    return // person was deleted
    }
    try! realm.write {
    person.name = "Jane Doe"
    }
    }
    
    
    }
}

