//
//  MyIOSHelper.swift
//  immoapp2
//
//  Created by etudiant on 5/10/17.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit

class MyIOSHelper: NSObject {
    static func showError(title: String, message: String, sender: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        sender.present(alertController, animated: true, completion: nil)
    }
    
}
