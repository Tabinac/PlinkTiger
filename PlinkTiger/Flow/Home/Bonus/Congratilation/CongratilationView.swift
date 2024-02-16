//
//  CongratilationView.swift
//  PlinkTiger

import UIKit
import SnapKit

class CongratilationView: UIView {
    
    private lazy var bgImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .bgGame
        return imageView
    }()
    
    private(set) lazy var homeBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(.btnHome, for: .normal)
        return button
    }()

    private lazy var winImg: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .winImg
        return imageView
    }()
    
    private lazy var meatImg: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .meatImg
        return imageView
    }()
    
    private(set) lazy var scoreMeatLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .customFont(font: .montserrat, style: .black, size: 60)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private(set) lazy var thanksBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(color:.customDarkRed), for: .normal)
        button.setBackgroundImage(UIImage(color: UIColor.red), for: .highlighted)
        button.setTitle("Thanks".uppercased(), for: .normal)
        button.setTitle("Thanks".uppercased(), for: .highlighted)
        button.titleLabel?.font = UIFont.customFont(font: .lato, style: .light, size: 18)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.customBrown.cgColor
        button.clipsToBounds = true
        if let normalTitle = button.title(for: .normal), let highlightedTitle = button.title(for: .highlighted) {
            let normalAttributedString = NSAttributedString(string: normalTitle, attributes: [NSAttributedString.Key.font: UIFont.customFont(font: .lato, style: .light, size: 18)])
            let highlightedAttributedString = NSAttributedString(string: highlightedTitle, attributes: [NSAttributedString.Key.font: UIFont.customFont(font: .lato, style: .bold, size: 18)])
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
        [bgImage,homeBtn,winImg,meatImg,scoreMeatLabel,thanksBtn] .forEach(addSubview(_:))
    }
    
    private func setUpConstraints(){
        
        bgImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        homeBtn.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(4)
            make.left.equalToSuperview().offset(24)
            make.size.equalTo(48)
        }
        
        winImg.snp.makeConstraints { (make) in
            make.top.equalTo(homeBtn.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
        }
        
        meatImg.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }

        scoreMeatLabel.snp.makeConstraints { (make) in
            make.top.equalTo(meatImg.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        thanksBtn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(48)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-52)
        }
    }
}
