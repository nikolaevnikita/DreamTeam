//
//  TeamTableViewCell.swift
//  DreamTeam
//
//  Created by Николаев Никита on 21.02.2021.
//

import UIKit

class TeamTableViewCell: UITableViewCell {
    // MARK: - Public properties
    var team: Team?
    
    // MARK: - Visual components
    private lazy var teamNumberLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.backgroundColor = UIConstants.orangeColor
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIConstants.teamNumberFont
        return label
    }()
    
    private lazy var teamNameLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIConstants.teamNameFont
        return label
    }()
    
    private lazy var herosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .none
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIConstants.mainColor
        selectionStyle = .none
        registerCollectionView()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func addSubviews() {
        contentView.addSubview(teamNumberLabel)
        contentView.addSubview(teamNameLabel)
        contentView.addSubview(herosCollectionView)
    }
    
    private func setupConstraints() {
        teamNumberLabel.snp.makeConstraints { make in
            make.height.width.equalTo(Constants.teamNumberLabelSide)
            make.centerY.equalTo(herosCollectionView)
            make.leading.equalToSuperview().offset(Constants.standardOffset)
        }
        teamNameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.teamNameLabelHeight)
        }
        herosCollectionView.snp.makeConstraints { make in
            make.top.equalTo(teamNameLabel.snp.bottom).offset(Constants.collectionViewTopOffset)
            make.bottom.equalToSuperview().offset(Constants.collectionViewBottomOffset)
            make.leading.equalTo(teamNumberLabel.snp.trailing).offset(Constants.standardOffset)
            make.trailing.equalToSuperview().offset(-Constants.standardOffset)
        }
    }
    
    private func registerCollectionView() {
        herosCollectionView.register(HeroCollectionViewCell.self,
                                     forCellWithReuseIdentifier: UIConstants.heroCellIdentifier)
        herosCollectionView.delegate = self
        herosCollectionView.dataSource = self
    }
    
    // MARK: - Public methods
    func setup(by team: Team, for indexPath: IndexPath) {
        self.team = team
        herosCollectionView.reloadData()
        teamNumberLabel.text = (indexPath.row + 1).description
        teamNameLabel.text = team.name
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TeamTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return team?.members.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIConstants.heroCellIdentifier, for: indexPath) as! HeroCollectionViewCell
        guard let currentHero = team?.members[indexPath.row] else { return cell}
        cell.setupCell(by: currentHero)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TeamTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.collectionCellSide, height: Constants.collectionCellSide)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = Constants.collectionSectionInset
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minimumLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minimumInteritemSpacing
    }
}

// MARK: - Constants
extension TeamTableViewCell {
    private enum Constants {
        static let teamNumberLabelSide: CGFloat = 20
        static let standardOffset: CGFloat = 16
        static let teamNameLabelHeight: CGFloat = 20
        static let collectionViewBottomOffset: CGFloat = -25
        static let collectionViewTopOffset: CGFloat = 5
        
        // Collection view Flow Layout constants
        static let collectionCellSide: CGFloat = 60
        static let collectionSectionInset: CGFloat = .zero
        static let minimumLineSpacing: CGFloat = 10
        static let minimumInteritemSpacing: CGFloat = .zero
    }
}
