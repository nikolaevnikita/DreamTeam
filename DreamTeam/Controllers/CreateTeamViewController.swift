//
//  ViewController.swift
//  DreamTeam
//
//  Created by Николаев Никита on 20.02.2021.
//

import UIKit
import SnapKit
import RealmSwift

class CreateTeamViewController: UIViewController {
    // MARK: - Private properties
    private var newTeam: Team!
    
    // MARK: - Visual components
    let heroImageField = HeroInformationField(typeField: .image)
    let heroNameField = HeroInformationField(typeField: .name)
    let heroQuoteField = HeroInformationField(typeField: .quote)
    let heroStuffField = HeroInformationField(typeField: .stuff)
    
    lazy var herosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .none
        collectionView.allowsSelection = true
        collectionView.isUserInteractionEnabled = true
        return collectionView
    }()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        newTeam = Team()
        view.backgroundColor = UIConstants.mainColor
        setupBars()
        addSubviews()
        setupConstraints()
        addTapGestureToHideKeyboard()
        registerCollectionView()
    }
    
    // MARK: - Private methods
    private func setupBars() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIConstants.mainColor
        tabBarController?.tabBar.isTranslucent = false
        tabBarController?.tabBar.barTintColor = UIConstants.mainColor
        tabBarController?.tabBar.tintColor = UIConstants.orangeColor
    }
    
    private func addSubviews() {
        view.addSubview(heroImageField)
        view.addSubview(heroNameField)
        view.addSubview(heroQuoteField)
        view.addSubview(heroStuffField)
        view.addSubview(herosCollectionView)
    }
    
    private func setupConstraints() {
        heroImageField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        heroNameField.snp.makeConstraints { make in
            make.top.equalTo(heroImageField.snp.bottom).offset(Constants.fieldsVerticalOffset)
            make.centerX.equalToSuperview()
        }
        heroQuoteField.snp.makeConstraints { make in
            make.top.equalTo(heroNameField.snp.bottom).offset(Constants.fieldsVerticalOffset)
            make.centerX.equalToSuperview()
        }
        heroStuffField.snp.makeConstraints { make in
            make.top.equalTo(heroQuoteField.snp.bottom).offset(Constants.fieldsVerticalOffset)
            make.centerX.equalToSuperview()
        }
        herosCollectionView.snp.makeConstraints { make in
            make.top.equalTo(heroStuffField.snp.bottom).offset(Constants.collectionOffset)
            make.bottom.equalToSuperview().offset(Constants.collectionOffset)
            make.leading.equalToSuperview().offset(Constants.collectionOffset)
            make.trailing.equalToSuperview().offset(-Constants.collectionOffset)
        }
    }
    
    private func registerCollectionView() {
        herosCollectionView.register(HeroCollectionViewCell.self,
                                     forCellWithReuseIdentifier: UIConstants.heroCellIdentifier)
        herosCollectionView.delegate = self
        herosCollectionView.dataSource = self
    }
    
    private func checkFields() -> Bool {
        guard let checkName = heroNameField.heroNameTextField.text?.isEmpty,
              let checkQuote = heroQuoteField.heroQuoteTextField.text?.isEmpty else { return false }
        if !checkName && !checkQuote {
            return true
        }
        return false
    }
    
    private func checkLeader() -> Bool {
        for hero in newTeam.members {
            if hero.isLeader { return true }
        }
        return false
    }
    
    private func clearInformationFields() {
        heroImageField.heroImageView.image = UIImage(.imagePlaceholder)
        heroNameField.heroNameTextField.text = nil
        heroQuoteField.heroQuoteTextField.text = nil
        heroStuffField.heroStuffTextField.text = UIConstants.heroStuffPackPlaceholder
        
    }
    
    // MARK: - Actions
    @IBAction func saveTeam(_ sender: UIBarButtonItem) {
        guard newTeam.members.count >= 3 else {
            displayAlert(title: UIConstants.notEnoughHeroesAlertTitle,
                         message: UIConstants.notEnoughHeroesMessage)
            return
        }
        guard checkLeader() else {
            displayAlert(title: UIConstants.notEnoughInformationAlertTitle,
                         message: UIConstants.chooseLeaderMessage)
            return
        }
        alertForTeamName { teamName in
            self.newTeam.name = teamName
            StorageManager.saveObject(self.newTeam)
            self.newTeam = Team()
            self.herosCollectionView.reloadData()
            self.clearInformationFields()
        }
    }
    
    @IBAction func addHero(_ sender: UIBarButtonItem) {
        if checkFields() {
            guard let image = heroImageField.heroImageView.image?.pngData(),
                  let name = heroNameField.heroNameTextField.text,
                  let quote = heroQuoteField.heroQuoteTextField.text,
                  let stuff = heroStuffField.heroStuffTextField.text else { return }
            let hero = Hero()
            hero.image = image
            hero.name = name
            hero.quote = quote
            hero.stuff = stuff
            newTeam.members.append(hero)
            herosCollectionView.reloadData()
        } else {
            displayAlert(title: UIConstants.notEnoughInformationAlertTitle,
                         message: UIConstants.fillAllFieldsMessage)
        }
    }
    
    // MARK: - Constants
    private enum Constants {
        static let fieldsVerticalOffset: CGFloat = 10
        static let collectionOffset: CGFloat = 20
        static let collectionItemPerRow: CGFloat = 3
        static let collectionInset: CGFloat = 10
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CreateTeamViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newTeam?.members.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIConstants.heroCellIdentifier, for: indexPath) as! HeroCollectionViewCell
        guard let currentHero = newTeam?.members[indexPath.row] else { return cell }
        cell.setupCell(by: currentHero)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        displayAlertManagedCreatedHero { action in
            switch action {
            case .delete:
                self.newTeam.members.remove(at: indexPath.row)
                self.herosCollectionView.reloadData()
            case .makeLeader:
                self.newTeam.members.forEach { $0.isLeader = false }
                self.newTeam.members[indexPath.row].isLeader = true
                self.herosCollectionView.reloadData()
            case .edit:
                break
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CreateTeamViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow = Constants.collectionItemPerRow
        let inset = Constants.collectionInset
        let paddingWidth = inset * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = Constants.collectionInset
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.collectionInset
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.collectionInset
    }
}

