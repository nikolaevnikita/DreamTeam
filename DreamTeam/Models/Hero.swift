//
//  Hero.swift
//  DreamTeam
//
//  Created by Николаев Никита on 21.02.2021.
//

import RealmSwift

class Hero: Object {
    @objc dynamic var name = ""
    @objc dynamic var quote = ""
    @objc dynamic var stuff = ""
    @objc dynamic var isLeader = false
    @objc dynamic var image = Data()
}
