//
//  StoreManager.swift
//  DreamTeam
//
//  Created by Николаев Никита on 21.02.2021.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    static func saveObject(_ object: Object) {
        try! realm.write {
            realm.add(object)
        }
    }
    
    static func deleteObject(_ object: Object) {
        try! realm.write {
            realm.delete(object)
        }
    }
    
    static func deleteAllObjects() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}
