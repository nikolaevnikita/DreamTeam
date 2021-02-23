//
//  Team.swift
//  DreamTeam
//
//  Created by Николаев Никита on 21.02.2021.
//

import RealmSwift

class Team: Object {
    @objc dynamic var name = ""
    let members = List<Hero>()
}
