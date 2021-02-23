//
//  Constants.swift
//  DreamTeam
//
//  Created by Николаев Никита on 20.02.2021.
//

import UIKit

enum UIConstants {
    // MARK: - UI Colors
    static let mainColor = UIColor(red: 0.12, green: 0.13, blue: 0.19, alpha: 1.0)
    static let orangeColor = UIColor(red: 1.0 , green: 0.33, blue: 0.0 , alpha: 1.0)
    static let textFieldBackgroundColor = UIColor(red: 0.17, green: 0.17, blue: 0.23, alpha: 1.0)
    static let textFieldPlaceholderColor = UIColor(red: 0.42, green: 0.42, blue: 0.51, alpha: 1.0)
    static let editSwipeActionColor = UIColor.darkGray
    static let deleteSwipeActionColor = UIColor.systemRed
    
    // MARK: - Text templates
    static let stuffPacks = ["🍗🍖🥫", "⚙️🔩🔧", "💰💳💵", "🗡🔪🪓", "🧬🦠🧪", "💣🧨💥"]
    static let leaderSign = "⭐️"
    
    static let chooseOptionsAlertTitle = "Choose the options"
    static let enterTeamNameAlertTitle = "Enter the team name"
    static let deleteAllTeamsAlertTitle = "Delete all teams?"
    static let notEnoughHeroesAlertTitle = "Not enough heroes"
    static let notEnoughInformationAlertTitle = "Not enough information"
    
    static let notEnoughHeroesMessage = "Add more persons"
    static let chooseLeaderMessage = "Choose a leader"
    static let fillAllFieldsMessage = "Fill in all the fields"
    
    static let okButtonTitle = "OK" 
    static let editButtonTitle = "Edit"
    static let deleteButtonTitle = "Delete"
    static let saveButtonTitle = "Save"
    static let leaderButtonTitle = "Make a leader"
    static let yesButtonTitle = "Yes"
    static let noButtonTitle = "No"
    
    static let heroNamePlaceholder = "Hero name"
    static let heroQuotePlaceholder = "Heroic quote"
    static let heroStuffPackPlaceholder = "❓❓❓"
    
    // MARK: - Fonts
    static let textFieldFont = UIFont(name: "Kohinoor Telugu Light", size: 17)
    static let teamNumberFont = UIFont.boldSystemFont(ofSize: 12)
    static let teamNameFont = UIFont.boldSystemFont(ofSize: 14)
    static let leaderSignFont = UIFont.boldSystemFont(ofSize: 35)
    
    // MARK: - Identifiers
    static let heroCellIdentifier = "Hero"
    static let teamCellIdentifier = "Team"
    static let segueToEditTeamIdentifier = "editTeam"
    
    // MARK: - Metrics
    static let screenHeight = UIScreen.main.bounds.height
    static let screenWidth = UIScreen.main.bounds.width
}
