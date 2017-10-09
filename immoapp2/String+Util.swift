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



//USAGE
//"HELLO".localized (voir fichier Localizable.strings)
