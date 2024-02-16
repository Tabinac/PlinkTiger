//
//  ProfileView.swift
//  PlinkTiger

import Foundation
import UIKit

class ProfileView: UIView,UITextFieldDelegate {
    
    private lazy var bgImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .bgClassic
        return imageView
    }()
    
    private(set) lazy var homeButtons: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(.btnHome, for: .normal)
        return button
    }()
    
    private(set) lazy var infoButtons: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(.btnInfo, for: .normal)
        return button
    }()

    private(set) lazy var setupButtons: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(.btnSetups, for: .normal)
        return button
    }()

    private(set) lazy var chosePhotoBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(.chosePhoto, for: .normal)
        return button
    }()
    
    private lazy var profileTextField: UITextField = {
        let textField = UITextField()
        let placeholderText = NSAttributedString(string: "user#\(Memory.shared.userID ?? 1)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        
        textField.attributedPlaceholder = placeholderText
        if let savedUserName = Memory.shared.userID {
            textField.placeholder = "user#\(savedUserName)"
        }
        textField.font = UIFont.customFont(font: .montserrat, style: .black, size: 24)
        textField.textColor = .white
        textField.backgroundColor = .customDarkRed
        textField.layer.borderWidth = 3
        textField.layer.borderColor = UIColor.customBrown.cgColor
        textField.layer.cornerRadius = 8
        textField.textAlignment = .center
        textField.delegate = self
        textField.returnKeyType = .done
        textField.resignFirstResponder()
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setUpConstraints()
        saveName()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [bgImage,homeButtons,infoButtons,setupButtons,chosePhotoBtn,profileTextField ] .forEach(addSubview(_:))
    }
    
    private func setUpConstraints(){
        
        bgImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        homeButtons.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(34)
            make.left.equalToSuperview().offset(24)
            make.size.equalTo(48)
        }
        
        setupButtons.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(34)
            make.right.equalToSuperview().offset(-24)
            make.size.equalTo(48)
        }
        
        infoButtons.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(34)
            make.right.equalTo(setupButtons.snp.left).offset(-16)
            make.size.equalTo(48)
        }
        
        chosePhotoBtn.snp.makeConstraints { (make) in
            make.top.equalTo(homeButtons.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.size.equalTo(160)
        }
        
        profileTextField.snp.makeConstraints { (make) in
            make.top.equalTo(chosePhotoBtn.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(48)
        }
    }
    
    private func saveName() {
        if let savedUserName = Memory.shared.userName {
            profileTextField.text = savedUserName
        }
    }

    internal func textFieldDidEndEditing(_ textField: UITextField) {
        Memory.shared.userName = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
