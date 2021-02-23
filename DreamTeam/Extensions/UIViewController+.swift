//
//  UIViewController+.swift
//  DreamTeam
//
//  Created by Николаев Никита on 20.02.2021.
//

import UIKit

extension UIViewController {
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: UIConstants.okButtonTitle, style: .cancel)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    func displayAlertManagedCreatedHero(completion: @escaping (actions) -> Void) {
        let alertController = UIAlertController(title: UIConstants.chooseOptionsAlertTitle,
                                                message: nil,
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: UIConstants.okButtonTitle, style: .cancel)
        let deleteAction = UIAlertAction(title: UIConstants.deleteButtonTitle,
                                         style: .destructive) { action in
            completion(.delete)
        }
        let makeLeaderAction = UIAlertAction(title: UIConstants.leaderButtonTitle, style: .default) { action in
            completion(.makeLeader)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        alertController.addAction(makeLeaderAction)
        self.present(alertController, animated: true)
    }
    
    func displayAlertManagedEditedHero(completion: @escaping (actions) -> Void) {
        let alertController = UIAlertController(title: UIConstants.chooseOptionsAlertTitle,
                                                message: nil,
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: UIConstants.okButtonTitle, style: .cancel)
        let deleteAction = UIAlertAction(title: UIConstants.deleteButtonTitle,
                                         style: .destructive) { action in
            completion(.delete)
        }
        let makeLeader = UIAlertAction(title: UIConstants.leaderButtonTitle,
                                       style: .default) { action in
            completion(.makeLeader)
        }
        let editHero = UIAlertAction(title: UIConstants.editButtonTitle,
                                     style: .default) { action in
            completion(.edit)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        alertController.addAction(makeLeader)
        alertController.addAction(editHero)
        self.present(alertController, animated: true)
    }
    
    func alertForTeamName(completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: UIConstants.enterTeamNameAlertTitle,
                                      message: nil,
                                      preferredStyle: .alert )
        alert.addTextField()
        let saveAction = UIAlertAction(title: UIConstants.saveButtonTitle,
                                 style: .default) { (alertAction) in
            guard let textField = alert.textFields?.first,
                  let text = textField.text,
                  !text.isEmpty else { return }
            completion(text)
        }
        alert.addAction(saveAction)
        self.present(alert, animated: true)
    }
    
    func deleteAllAlert(completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: UIConstants.deleteAllTeamsAlertTitle,
                                                message: nil,
                                                preferredStyle: .alert)
        let yesAction = UIAlertAction(title: UIConstants.yesButtonTitle, style: .destructive) {_ in
            completion()
        }
        let noAction = UIAlertAction(title: UIConstants.noButtonTitle, style: .default)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true)
    }
    
    enum actions {
        case delete
        case makeLeader
        case edit
    }
}


