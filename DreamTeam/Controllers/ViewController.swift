//
//  ViewController.swift
//  DreamTeam
//
//  Created by Николаев Никита on 20.02.2021.
//

import UIKit
import SnapKit

class CreateTeamViewController: UIViewController {
    // MARK: - Visual components
    let heroImageField = HeroInformationField(typeField: .image)
    let heroNameField = HeroInformationField(typeField: .name)
    let heroQuoteField = HeroInformationField(typeField: .quote)
    let heroStuffField = HeroInformationField(typeField: .stuff)
//    let herosCollectionView = UICollectionView(frame: CGRect.zero)

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.mainColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIConstants.mainColor
        setupSubviews()
        setupConstraints()
        addTapGestureToHideKeyboard()
    }
    
    // MARK: - Private methods
    private func setupSubviews() {
        view.addSubview(heroImageField)
        view.addSubview(heroNameField)
        view.addSubview(heroQuoteField)
        view.addSubview(heroStuffField)
//        view.addSubview(herosCollectionView)
    }
    
    private func setupConstraints() {
        heroImageField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        heroNameField.snp.makeConstraints { make in
            make.top.equalTo(heroImageField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        heroQuoteField.snp.makeConstraints { make in
            make.top.equalTo(heroNameField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        heroStuffField.snp.makeConstraints { make in
            make.top.equalTo(heroQuoteField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
//        herosCollectionView.snp.makeConstraints { make in
//            make.top.equalTo(heroStuffField.snp.bottom).offset(20)
//            make.bottom.equalToSuperview().offset(20)
//            make.leading.equalToSuperview().offset(20)
//            make.trailing.equalToSuperview().offset(-20)
//        }
    }
}

//extension UINavigationController {
//   open override var preferredStatusBarStyle: UIStatusBarStyle {
//      return topViewController?.preferredStatusBarStyle ?? .default
//   }
//}
