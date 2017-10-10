//
//  Models.swift
//  immoapp2
//
//  Created by etudiant on 3/10/17.
//  Copyright © 2017 etudiant. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class Dog: Object {
    dynamic var name = ""
    dynamic var age = 0
}

protocol ListPresentable {
    associatedtype Item: Object, CellPresentable
    var items: List<Item> { get }
}

protocol CellPresentable {
    var text: String { get set }
    var date: Date? { get set }
    var completed: Bool { get set }
    var isCompletable: Bool { get }
}

final class TaskListList: Object, ListPresentable {
    dynamic var id = NSUUID().uuidString//0 // swiftlint:disable:this variable_name
    let items = List<TaskList>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

final class TaskList: Object, CellPresentable, ListPresentable {
    dynamic var id = NSUUID().uuidString// swiftlint:disable:this variable_name
    dynamic var text = ""
    dynamic var date: Date?
    dynamic var completed = false
    let items = List<Task>()
    
    var isCompletable: Bool {
        return !items.filter("completed == false").isEmpty
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

final class Task: Object, CellPresentable {
    dynamic var text = ""
    dynamic var date: Date?
    dynamic var completed = false
    
    var isCompletable: Bool { return true }
    
    convenience init(text: String) {
        self.init()
        self.text = text
    }
    
    
}
final class BienImmobilier: Object {
    
    dynamic var name = ""
    dynamic var longitude = 0.0
    dynamic var latitude = 0.0
    
    dynamic var created = NSDate()
}



class DossierClient: Object {
    
    dynamic var id = NSUUID().uuidString
    dynamic var name = ""
    dynamic var firstname = ""
    dynamic var scanId = ""
    dynamic var status = ""
    dynamic var textScanResult:String?
    //dynamic var imageData = [NSData]()
    let listimage = List<ImageImmo>()
    override static func primaryKey() -> String? {
        return "id"
    }
}
class ImageImmo: Object {
    dynamic var id = NSUUID().uuidString
    dynamic var fkey_idDossierClient = ""
    dynamic var name = ""
    dynamic var imageString = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    var image: UIImage {
        get { return stringToImage(string: imageString) }
        set { imageString = imageToString(image: newValue) }
    }
    
    
    override class func ignoredProperties() -> [String] {
        return ["image", "hasId"]
    }
    
    
    private func imageToString(image: UIImage?) -> String {
        if (image == nil) {
            return ""
        }
        let data = UIImagePNGRepresentation(image!)
        return data != nil ? data!.base64EncodedString(options: .lineLength64Characters) : ""
        
        
    }
    
    private func stringToImage(string: String) -> UIImage {
        if (string.characters.count == 0) {
            return UIImage()
        }
        
        let imageString = string.replacingOccurrences(of:"\r\n", with: "")
        let options = NSData.Base64DecodingOptions(rawValue: 0)
        let data = NSData(base64Encoded: imageString, options: options)
        let image = data != nil ? UIImage(data: data! as Data) : nil
        return image ?? UIImage()
    }
}
