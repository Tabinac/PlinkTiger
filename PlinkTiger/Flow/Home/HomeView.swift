//
//  HomeView.swift
//  PlinkTiger


import Foundation
import UIKit
import SnapKit

class HomeView: UIView {
    
    private lazy var backImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .bgClassic
        return imageView
    }()
    
    private lazy var tigerImg: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .tigerImg
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
 

    private(set) lazy var playButtons: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(color:.darkGray), for: .normal)
        button.setBackgroundImage(UIImage(color: UIColor.red), for: .highlighted)
        button.setTitle("Play".uppercased(), for: .normal)
        button.titleLabel?.font = UIFont.customFont(font: .lato, style: .light, size: 18)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.orange.cgColor
        button.clipsToBounds = true
        return button
    }()
    
    private(set) lazy var getBonusButtons: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(color:.darkGray), for: .normal)
        button.setBackgroundImage(UIImage(color: UIColor.red), for: .highlighted)
        button.setTitle("Get Bonus".uppercased(), for: .normal)
        button.titleLabel?.font = UIFont.customFont(font: .lato, style: .light, size: 18)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.orange.cgColor
        button.clipsToBounds = true
        return button
    }()
    
    private(set) lazy var leadButtons: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(color:.darkGray), for: .normal)
        button.setBackgroundImage(UIImage(color: UIColor.red), for: .highlighted)
        button.setTitle("leaderboard".uppercased(), for: .normal)
        button.titleLabel?.font = UIFont.customFont(font: .lato, style: .light, size: 18)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.orange.cgColor
        button.clipsToBounds = true
        return button
    }()

    private(set) lazy var buyButtons: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(color:.darkGray), for: .normal)
        button.setBackgroundImage(UIImage(color: UIColor.red), for: .highlighted)
        button.setTitle("buy emerald".uppercased(), for: .normal)
        button.titleLabel?.font = UIFont.customFont(font: .lato, style: .light, size: 18)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.orange.cgColor
        button.clipsToBounds = true
        return button
    }()
    
    private(set) lazy var profileButtons: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(.btnProfile, for: .normal)
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
        [backImage,profileButtons,tigerImg,playButtons,getBonusButtons,leadButtons,buyButtons] .forEach(addSubview(_:))
    }
    
    private func setUpConstraints(){
        
        backImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        profileButtons.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(4)
            make.right.equalToSuperview().offset(-24)
            make.size.equalTo(48)
        }
        
        playButtons.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(280)
        }
        
        tigerImg.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileButtons.snp.bottom).offset(32)
            make.bottom.equalTo(playButtons.snp.top).offset(-32)
        }
        
        getBonusButtons.snp.makeConstraints { (make) in
            make.top.equalTo(playButtons.snp.bottom).offset(28)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(280)
        }
        
        leadButtons.snp.makeConstraints { (make) in
            make.top.equalTo(getBonusButtons.snp.bottom).offset(28)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(280)
        }

        buyButtons.snp.makeConstraints { (make) in
            make.top.equalTo(leadButtons.snp.bottom).offset(28)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(280)
        }

    }
}

extension UIImage {
    convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(cgImage: image.cgImage!)
    }
}
