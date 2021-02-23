//
//  heroTextField.swift
//  DreamTeam
//
//  Created by Николаев Никита on 20.02.2021.
//

import UIKit

class HeroTextField: UITextField {
    // MARK: - Initializiers
    required init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setup() {
        self.backgroundColor = UIConstants.textFieldBackgroundColor
        
        self.textAlignment = .center
        self.textColor = .white
        self.font = UIConstants.textFieldFont
        self.autocorrectionType = .no
        
        self.layer.cornerRadius = Constants.cornerRadius
        self.layer.masksToBounds = true
        
        self.leftView = UIView(frame: Constants.leftViewRect)
        self.rightView = UIView(frame: Constants.leftViewRect)
        self.leftViewMode = .always
        self.rightViewMode = .always
    }
    
    // MARK: - Public methods
    func setPlaceholder(with text: String) {
        let color = UIConstants.textFieldPlaceholderColor
        let placeholder = NSAttributedString(string: text,
                                             attributes: [.foregroundColor : color])
        self.attributedPlaceholder = placeholder
    }
    
    // MARK: - Constants
    private enum Constants {
        static let cornerRadius: CGFloat = 20
        static let leftViewRect: CGRect = CGRect(x: 0, y: 0, width: 15, height: 10)
    }
}
