//
//  HeroInformationField.swift
//  DreamTeam
//
//  Created by Николаев Никита on 20.02.2021.
//

import UIKit
import SnapKit

class HeroInformationField: UIView {
    // MARK: - TypeField
    enum TypeField {
        case image
        case name
        case quote
        case stuff
    }
    
    // MARK: - Private properties
    private var stuffPackIndex = 0
    
    // MARK: - Visual components
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(.back)
        button.setImage(image, for: .normal)
        button.tintColor = UIConstants.orangeColor
        return button
    }()
    
    private lazy var forwardButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(.forward)
        button.setImage(image, for: .normal)
        button.tintColor = UIConstants.orangeColor
        return button
    }()
    
    lazy var heroImageView: LoadedImageView = {
        let imageView = LoadedImageView(frame: CGRect.zero)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.imageViewCornerRadius
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = Constants.imageViewBorderWidth
        imageView.layer.borderColor = UIConstants.orangeColor.cgColor
        imageView.image = UIImage(.imagePlaceholder)
        return imageView
    }()
    
    lazy var heroNameTextField: HeroTextField = {
        let textField = HeroTextField()
        textField.setPlaceholder(with: UIConstants.heroNamePlaceholder)
        return textField
    }()
    
    lazy var heroQuoteTextField: UITextField = {
        let textField = HeroTextField()
        textField.setPlaceholder(with: UIConstants.heroQuotePlaceholder)
        return textField
    }()
    
    lazy var heroStuffTextField: UITextField = {
        let textField = HeroTextField()
        textField.isUserInteractionEnabled = false
        textField.setPlaceholder(with: UIConstants.heroStuffPackPlaceholder)
        return textField
    }()
    
    // MARK: - Initializiers
    required init(typeField: TypeField) {
        super.init(frame: CGRect.zero)
        addSubviews(for: typeField)
        setupConstraints(for: typeField)
        addAction(to: forwardButton, for: typeField)
        addAction(to: backButton, for: typeField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func addSubviews(for typeField: TypeField) {
        self.addSubview(backButton)
        self.addSubview(forwardButton)
        switch typeField {
        case .image:
            self.addSubview(heroImageView)
        case .name:
            self.addSubview(heroNameTextField)
        case .quote:
            self.addSubview(heroQuoteTextField)
        case .stuff:
            self.addSubview(heroStuffTextField)
        }
    }
    
    private func setupConstraints(for typeField: TypeField) {
        switch typeField {
        case .image:
            setupConstraintsForImage()
        default:
            setupConstraintsForTextField()
        }
        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(Constants.buttonSide)
            make.centerY.leading.equalToSuperview()
        }
        forwardButton.snp.makeConstraints { make in
            make.height.width.equalTo(Constants.buttonSide)
            make.centerY.trailing.equalToSuperview()
        }
    }
    
    private func setupConstraintsForImage() {
        self.snp.makeConstraints { make in
            make.height.equalTo(Constants.imageInformationFieldHeight)
            make.width.equalTo(UIConstants.screenWidth - Constants.informationFieldPaddingsWidth)
        }
        heroImageView.snp.makeConstraints { make in
            make.height.equalToSuperview().offset(-Constants.viewOffset)
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(heroImageView.snp.height)
        }
    }
    
    private func setupConstraintsForTextField() {
        self.snp.makeConstraints { make in
            make.height.equalTo(Constants.textInformationFieldHeight)
            make.width.equalTo(UIConstants.screenWidth - Constants.informationFieldPaddingsWidth)
        }
        let heroTextField = self.subviews.last
        heroTextField?.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview()
            make.leading.equalTo(backButton.snp.trailing).offset(Constants.viewOffset)
            make.trailing.equalTo(forwardButton.snp.leading).offset(-Constants.viewOffset)
        }
    }
    
    private func addAction(to button: UIButton, for type: TypeField ) {
        switch type {
        case .image:
            button.addTarget(self, action: #selector(getNextImage), for: .touchUpInside)
        case .name:
            button.addTarget(self, action: #selector(getNextName), for: .touchUpInside)
        case .quote:
            button.addTarget(self, action: #selector(getNextQuote), for: .touchUpInside)
        case .stuff:
            button.addTarget(self, action: #selector(getNextStuff), for: .touchUpInside)
        }
    }
    
    // MARK: - Actions
    @objc func getNextImage() {
        NetworkManager.shared.fetchHero { result in
            switch result {
            case .success(let data):
                guard let urlString = data.first?.img,
                      let url = URL(string: urlString) else { return }
                DispatchQueue.main.async {
                    self.heroImageView.loadImage(from: url)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func getNextName() {
        NetworkManager.shared.fetchHero { result in
            switch result {
            case .success(let data):
                guard let name = data.first?.name else { return }
                DispatchQueue.main.async {
                    self.heroNameTextField.text = name
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func getNextQuote() {
        NetworkManager.shared.fetchQuote { result in
            switch result {
            case .success(let data):
                guard let quote = data.first?.quote else { return }
                DispatchQueue.main.async {
                    self.heroQuoteTextField.text = quote
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func getNextStuff() {
        stuffPackIndex += 1
        let nextPackIndex = stuffPackIndex % UIConstants.stuffPacks.count
        DispatchQueue.main.async {
            self.heroStuffTextField.text = UIConstants.stuffPacks[nextPackIndex]
        }
    }
    
    // MARK: - Constants
    enum Constants {
        static let buttonSide: CGFloat = 30
        static let imageViewCornerRadius: CGFloat = 25
        static let imageViewBorderWidth: CGFloat = 2
        
        static let imageInformationFieldHeight: CGFloat = UIConstants.screenHeight / 6
        static let textInformationFieldHeight: CGFloat = 40
        static let informationFieldPaddingsWidth: CGFloat = 50
        
        static let viewOffset: CGFloat = 10
    }
}
