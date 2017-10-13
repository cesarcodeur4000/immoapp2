//
//  String+Util.swift
//  immoapp2
//
//  Created by etudiant on 9/10/17.
//  Copyright © 2017 etudiant. All rights reserved.
//

import Foundation



extension String{
    
    
    
    var localized: String {
        
        return NSLocalizedString(self, comment: "")
    }
}

func timer(_ second: Double ){
let when = DispatchTime.now() + second // change 2 to desired number of seconds
DispatchQueue.main.asyncAfter(deadline: when) {
    // Your code with delay
}
}
//USAGE
//"HELLO".localized (voir fichier Localizable.strings)
