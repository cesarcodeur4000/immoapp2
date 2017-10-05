//
//  Models.swift
//  immoapp2
//
//  Created by etudiant on 3/10/17.
//  Copyright © 2017 etudiant. All rights reserved.
//

import Foundation
import RealmSwift


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
