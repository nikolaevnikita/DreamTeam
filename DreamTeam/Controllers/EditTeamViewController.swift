//
//  EditTeamViewController.swift
//  DreamTeam
//
//  Created by Николаев Никита on 22.02.2021.
//

import UIKit
import SnapKit

class EditTeamViewController: UIViewController {
    // MARK: - Public roperties
    var editedTeam: Team?
    
    // MARK: - Private roperties
    private var stuffPackIndex = 0
    private var editedHero: Hero?
    
    // MARK: - Visual components
    private lazy var heroImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.heroImageViewCornerRadius
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = Constants.heroImageViewBorderWidth
        imageView.layer.borderColor = UIConstants.orangeColor.cgColor
        imageView.image = UIImage(.imagePlaceholder)
        return imageView
    }()
    
    private lazy var heroNameTextField: HeroTextField = {
        let textField = HeroTextField()
        textField.setPlaceholder(with: UIConstants.heroNamePlaceholder)
        return textField
    }()
    
    private lazy var heroQuoteTextField: UITextField = {
        let textField = HeroTextField()
        textField.setPlaceholder(with: UIConstants.heroQuotePlaceholder)
        return textField
    }()
    
    private lazy var heroStuffTextField: UITextField = {
        let textField = HeroTextField()
        textField.isUserInteractionEnabled = false
        textField.setPlaceholder(with: UIConstants.heroStuffPackPlaceholder)
        return textField
    }()
    
    private lazy var backStuffButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: Constants.backButtonImageSystemName)
        button.setImage(image, for: .normal)
        button.tintColor = UIConstants.orangeColor
        return button
    }()
    
    private lazy var forwardStuffButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: Constants.forwardButtonImageSystemName)
        button.setImage(image, for: .normal)
        button.tintColor = UIConstants.orangeColor
        return button
    }()
    
    private lazy var herosCollectionView: UICollectionView = {
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
        self.navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = UIConstants.mainColor
        addSubviews()
        setupConstraints()
        registerCollectionView()
        registerTextFields()
        addTapGestureToHideKeyboard()
        addActionsToButtons()
        addGestureToHeroImage()
        setup(by: editedTeam?.members.first ?? Hero())
    }
    
    // MARK: - Private methods
    private func addSubviews() {
        view.addSubview(heroImageView)
        view.addSubview(heroNameTextField)
        view.addSubview(heroQuoteTextField)
        view.addSubview(heroStuffTextField)
        view.addSubview(herosCollectionView)
        view.addSubview(backStuffButton)
        view.addSubview(forwardStuffButton)
    }
    
    private func setupConstraints() {
        heroImageView.snp.makeConstraints { make in
            make.height.width.equalTo(Constants.heroImageViewHeight)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        herosCollectionView.snp.makeConstraints { make in
            make.top.equalTo(heroStuffTextField.snp.bottom).offset(Constants.collectionViewOffset)
            make.bottom.equalToSuperview().offset(Constants.collectionViewOffset)
            make.leading.equalToSuperview().offset(Constants.collectionViewOffset)
            make.trailing.equalToSuperview().offset(-Constants.collectionViewOffset)
        }
        backStuffButton.snp.makeConstraints { make in
            make.height.width.equalTo(Constants.buttonSide)
            make.centerY.equalTo(heroStuffTextField.snp.centerY)
            make.leading.equalTo(heroStuffTextField.snp.leading).offset(Constants.buttonPaddingWidth)
        }
        forwardStuffButton.snp.makeConstraints { make in
            make.height.width.equalTo(Constants.buttonSide)
            make.centerY.equalTo(heroStuffTextField.snp.centerY)
            make.trailing.equalTo(heroStuffTextField.snp.trailing).offset(-Constants.buttonPaddingWidth)
        }
        setupTextFieldsConstraints()
    }
    
    private func setupTextFieldsConstraints() {
        heroNameTextField.snp.makeConstraints { make in
            make.height.equalTo(Constants.textFieldHeight)
            make.width.equalToSuperview().offset(-Constants.textFieldPaddingsWidth)
            make.top.equalTo(heroImageView.snp.bottom).offset(Constants.textFieldVerticalOffset)
            make.centerX.equalToSuperview()
        }
        heroQuoteTextField.snp.makeConstraints { make in
            make.height.equalTo(Constants.textFieldHeight)
            make.width.equalToSuperview().offset(-Constants.textFieldPaddingsWidth)
            make.top.equalTo(heroNameTextField.snp.bottom).offset(Constants.textFieldVerticalOffset)
            make.centerX.equalToSuperview()
        }
        heroStuffTextField.snp.makeConstraints { make in
            make.height.equalTo(Constants.textFieldHeight)
            make.width.equalToSuperview().offset(-Constants.textFieldPaddingsWidth)
            make.top.equalTo(heroQuoteTextField.snp.bottom).offset(Constants.textFieldVerticalOffset)
            make.centerX.equalToSuperview()
        }
    }
    
    private func registerCollectionView() {
        herosCollectionView.register(HeroCollectionViewCell.self,
                                     forCellWithReuseIdentifier: UIConstants.heroCellIdentifier)
        herosCollectionView.delegate = self
        herosCollectionView.dataSource = self
    }
    
    private func registerTextFields() {
        heroNameTextField.delegate = self
        heroQuoteTextField.delegate = self
        heroStuffTextField.delegate = self
    }
    
    private func addActionsToButtons() {
        backStuffButton.addTarget(self, action: #selector(getPreviousStuff), for: .touchUpInside)
        forwardStuffButton.addTarget(self, action: #selector(getNextStuff), for: .touchUpInside)
    }
    
    private func setup(by hero: Hero) {
        heroImageView.image = UIImage(data: hero.image)
        heroNameTextField.text = hero.name
        heroQuoteTextField.text = hero.quote
        heroStuffTextField.text = hero.stuff
        editedHero = hero
    }
    
    private func createNewHero() -> Hero {
        let newHero = Hero()
        newHero.name = UIConstants.heroNamePlaceholder
        newHero.quote = UIConstants.heroQuotePlaceholder
        newHero.stuff = UIConstants.heroStuffPackPlaceholder
        guard let imageData = UIImage(.imagePlaceholder)?.pngData() else { return newHero}
        newHero.image = imageData
        return newHero
    }
    
    private func addGestureToHeroImage() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openPhotoLibrary))
        heroImageView.isUserInteractionEnabled = true
        heroImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Actions
    @objc func getNextStuff() {
        stuffPackIndex += 1
        let nextPackIndex = stuffPackIndex % UIConstants.stuffPacks.count
        let nextStuffPack = UIConstants.stuffPacks[nextPackIndex]
        DispatchQueue.main.async {
            self.heroStuffTextField.text = nextStuffPack
        }
        try! realm.write {
            editedHero?.stuff = nextStuffPack
        }
    }
    @objc func getPreviousStuff() {
        stuffPackIndex -= 1
        if stuffPackIndex < 0 {
            stuffPackIndex = UIConstants.stuffPacks.count - 1
        }
        let nextPackIndex = stuffPackIndex % UIConstants.stuffPacks.count
        let nextStuffPack = UIConstants.stuffPacks[nextPackIndex]
        DispatchQueue.main.async {
            self.heroStuffTextField.text = nextStuffPack
        }
        try! realm.write {
            editedHero?.stuff = nextStuffPack
        }
    }
    @IBAction func addNewHero(_ sender: UIBarButtonItem) {
        let newHero = createNewHero()
        setup(by: newHero)
        try! realm.write {
            editedTeam?.members.append(editedHero!)
        }
        herosCollectionView.reloadData()
    }
    
    @objc func openPhotoLibrary() {
        chooseImagePicker(source: .photoLibrary)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension EditTeamViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return editedTeam?.members.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIConstants.heroCellIdentifier, for: indexPath) as! HeroCollectionViewCell
        guard let currentHero = editedTeam?.members[indexPath.row] else { return cell }
        cell.setupCell(by: currentHero)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        displayAlertManagedEditedHero { action in
            switch action {
            case .delete:
                try! realm.write {
                    self.editedTeam?.members.remove(at: indexPath.row)
                }
                self.herosCollectionView.reloadData()
            case .makeLeader:
                try! realm.write {
                    self.editedTeam?.members.forEach { $0.isLeader = false }
                    self.editedTeam?.members[indexPath.row].isLeader = true
                }
                self.herosCollectionView.reloadData()
            case .edit:
                self.setup(by: self.editedTeam?.members[indexPath.row] ?? Hero())
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension EditTeamViewController: UICollectionViewDelegateFlowLayout {
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

// MARK: - UITextFieldDelegate
extension EditTeamViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        try! realm.write {
            editedHero?.name = heroNameTextField.text!
            editedHero?.quote = heroQuoteTextField.text!
            editedHero?.stuff = heroStuffTextField.text!
            guard let image = heroImageView.image?.pngData() else { return }
            editedHero?.image = image
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension EditTeamViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker (source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let editedImage = info[.editedImage] as? UIImage else { return }
        try! realm.write {
            guard let image = editedImage.pngData() else { return }
            editedHero?.image = image
        }
        heroImageView.image = editedImage
        herosCollectionView.reloadData()
        dismiss(animated: true)
    }
}

// MARK: - Constants
extension EditTeamViewController {
    private enum Constants {
        static let heroImageViewHeight: CGFloat = UIConstants.screenHeight / 6
        static let heroImageViewBorderWidth: CGFloat = 2
        static let heroImageViewCornerRadius: CGFloat = 25
        
        static let collectionViewOffset: CGFloat = 20
        static let collectionItemPerRow: CGFloat = 3
        static let collectionInset: CGFloat = 10
        
        static let textFieldHeight: CGFloat = 40
        static let textFieldPaddingsWidth: CGFloat = 32
        static let textFieldVerticalOffset: CGFloat = 10
        
        static let buttonSide: CGFloat = 30
        static let buttonPaddingWidth: CGFloat = 16
        static let backButtonImageSystemName = "chevron.left"
        static let forwardButtonImageSystemName = "chevron.right"
    }
}

