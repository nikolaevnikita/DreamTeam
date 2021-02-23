//
//  TeamsTableViewController.swift
//  DreamTeam
//
//  Created by Николаев Никита on 21.02.2021.
//

import UIKit
import RealmSwift

class TeamsTableViewController: UITableViewController {
    // MARK: - Private properties
    var teams: Results<Team>!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        teams = realm.objects(Team.self)
        setupTableView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Private methods
    private func setupTableView() {
        tableView.register(TeamTableViewCell.self,
                           forCellReuseIdentifier: UIConstants.teamCellIdentifier)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIConstants.mainColor
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIConstants.mainColor
    }

    // MARK: - TableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UIConstants.teamCellIdentifier,
                                                 for: indexPath) as! TeamTableViewCell
        let currentTeam = teams[indexPath.row]
        cell.setup(by: currentTeam, for: indexPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: UIConstants.deleteButtonTitle) { (_, _, _) in
            let deletedTeam = self.teams[indexPath.row]
            StorageManager.deleteObject(deletedTeam)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let editAction = UIContextualAction(style: .normal,
                                            title: UIConstants.editButtonTitle) { (_, _, _) in
            let currentTeam = self.teams[indexPath.row]
            self.performSegue(withIdentifier: UIConstants.segueToEditTeamIdentifier,
                              sender: currentTeam)
        }
        deleteAction.backgroundColor = UIConstants.deleteSwipeActionColor
        editAction.backgroundColor = UIConstants.editSwipeActionColor
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return swipeActions
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? EditTeamViewController,
              let editedTeam = sender as? Team else { return }
        destinationVC.editedTeam = editedTeam
    }
    
    // MARK: - Actions
    @IBAction func deleteAllTeams(_ sender: UIBarButtonItem) {
        deleteAllAlert {
            StorageManager.deleteAllObjects()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Constants
    private enum Constants {
        static let rowHeight: CGFloat = 110
    }
}
