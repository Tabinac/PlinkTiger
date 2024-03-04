//
//  ChoseView.swift
//  PlinkTiger


import Foundation
import UIKit
import SnapKit

class ChoseView: UIView {
    
    private lazy var backImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .bgClassic
        return imageView
    }()
    
    private(set) lazy var backBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(.btnBack, for: .normal)
        return button
    }()

    
    private(set) var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Chose game".uppercased()
        label.textAlignment = .center
        label.font = .customFont(font: .lato, style: .bold, size: 28)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    private lazy var cloudImg: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .cloudImg
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
 
    
    private(set) lazy var classicBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(color:.customDarkRed), for: .normal)
        button.setBackgroundImage(UIImage(color: UIColor.red), for: .highlighted)
        button.setTitle("classic".uppercased(), for: .normal)
        button.setTitle("classic".uppercased(), for: .highlighted)
        button.titleLabel?.font = UIFont.customFont(font: .lato, style: .light, size: 20)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.customBrown.cgColor
        button.clipsToBounds = true
        if let normalTitle = button.title(for: .normal), let highlightedTitle = button.title(for: .highlighted) {
            let normalAttributedString = NSAttributedString(string: normalTitle, attributes: [NSAttributedString.Key.font: UIFont.customFont(font: .lato, style: .light, size: 20)])
            let highlightedAttributedString = NSAttributedString(string: highlightedTitle, attributes: [NSAttributedString.Key.font: UIFont.customFont(font: .lato, style: .bold, size: 20)])
            button.setAttributedTitle(normalAttributedString, for: .normal)
            button.setAttributedTitle(highlightedAttributedString, for: .highlighted)
        }
        return button
    }()
    
    private(set) lazy var catchBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(color:.customDarkRed), for: .normal)
        button.setBackgroundImage(UIImage(color: UIColor.red), for: .highlighted)
        button.setTitle("catch ball".uppercased(), for: .normal)
        button.setTitle("catch ball".uppercased(), for: .highlighted)
        button.titleLabel?.font = UIFont.customFont(font: .lato, style: .light, size: 20)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.customBrown.cgColor
        button.clipsToBounds = true
        if let normalTitle = button.title(for: .normal), let highlightedTitle = button.title(for: .highlighted) {
            let normalAttributedString = NSAttributedString(string: normalTitle, attributes: [NSAttributedString.Key.font: UIFont.customFont(font: .lato, style: .light, size: 20)])
            let highlightedAttributedString = NSAttributedString(string: highlightedTitle, attributes: [NSAttributedString.Key.font: UIFont.customFont(font: .lato, style: .bold, size: 20)])
            button.setAttributedTitle(normalAttributedString, for: .normal)
            button.setAttributedTitle(highlightedAttributedString, for: .highlighted)
        }
        return button
    }()
    
    private(set) lazy var placeBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(color:.customDarkRed), for: .normal)
        button.setBackgroundImage(UIImage(color: UIColor.red), for: .highlighted)
        button.setTitle("place ball".uppercased(), for: .normal)
        button.setTitle("place ball".uppercased(), for: .highlighted)
        button.titleLabel?.font = UIFont.customFont(font: .lato, style: .light, size: 20)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.customBrown.cgColor
        button.clipsToBounds = true
        if let normalTitle = button.title(for: .normal), let highlightedTitle = button.title(for: .highlighted) {
            let normalAttributedString = NSAttributedString(string: normalTitle, attributes: [NSAttributedString.Key.font: UIFont.customFont(font: .lato, style: .light, size: 20)])
            let highlightedAttributedString = NSAttributedString(string: highlightedTitle, attributes: [NSAttributedString.Key.font: UIFont.customFont(font: .lato, style: .bold, size: 20)])
            button.setAttributedTitle(normalAttributedString, for: .normal)
            button.setAttributedTitle(highlightedAttributedString, for: .highlighted)
        }
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setUpConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [backImage,backBtn,titleLabel,cloudImg,classicBtn,catchBtn,placeBtn] .forEach(addSubview(_:))
    }
    
    private func setUpConstraints(){
        
        backImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(4.autoSize)
            make.left.equalToSuperview().offset(24)
            make.size.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backBtn.snp.bottom).offset(40.autoSize)
            make.centerX.equalToSuperview()
        }
        
        cloudImg.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(36.autoSize)
        }

        classicBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(80.autoSize)
            make.width.equalTo(280.autoSize)
        }

        catchBtn.snp.makeConstraints { (make) in
            make.top.equalTo(classicBtn.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(80)
            make.width.equalTo(280)
        }
        
        placeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(catchBtn.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(80)
            make.width.equalTo(280)
        }
    }
}
