//
//  HeroCollectionViewCell.swift
//  DreamTeam
//
//  Created by Николаев Никита on 21.02.2021.
//

import UIKit
import SnapKit

class HeroCollectionViewCell: UICollectionViewCell {
    //MARK: - Visual Components
    lazy var heroImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.imageViewCornerRadius
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = Constants.imageViewBorderWidth
        imageView.layer.borderColor = UIColor.black.cgColor
        return imageView
    }()
    
    lazy var leaderSignLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = UIConstants.leaderSign
        label.textAlignment = .center
        label.font = UIConstants.leaderSignFont
        label.isHidden = true
        return label
    }()
    
    // MARK: - Initializiers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func addSubviews() {
        self.addSubview(heroImageView)
        self.addSubview(leaderSignLabel)
    }
    
    private func setupConstraints() {
        heroImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        leaderSignLabel.snp.makeConstraints { make in
            make.height.width.equalTo(Constants.leaderSignLabelSide)
            make.top.leading.equalToSuperview()
        }
    }
    
    // MARK: - Public methods
    func setupCell(by hero: Hero) {
        heroImageView.image = nil
        leaderSignLabel.isHidden = !hero.isLeader
        guard let image = UIImage(data: hero.image) else { return }
        heroImageView.image = image
    }
    
    // MARK: - Constants
    private enum Constants {
        static let imageViewCornerRadius: CGFloat = 5
        static let imageViewBorderWidth: CGFloat = 2
        static let leaderSignLabelSide: CGFloat = 40
    }
}
