//
//  InfoView.swift
//  PlinkTiger


import Foundation
import UIKit
import SnapKit

class InfoView: UIView {
    
    private lazy var bgImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .bgClassic
        return imageView
    }()

    private(set) lazy var homeBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(.btnHome, for: .normal)
        return button
    }()

    private(set) lazy var imageConteinerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.customBrown.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private (set) var iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private(set) var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "\(Settings.appTitle)".uppercased()
        label.textAlignment = .center
        label.font = .customFont(font: .lato, style: .black, size: 20)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    private lazy var contentLabel: UILabel = {
        let label = UILabel()
                label.text = "This game combines elements of the classic Plinko game with unique variations called Classic, CatchBall and PlaceBall. The goal of the game is to feed the hungry tiger by releasing balls into the maze of tiles and guiding them to the place where the tiger is waiting for his food.\nRules of the game on the home screen.\nIf you run out of meat, you can always try your luck in our GET BONUS once every 24 hours and get extra meat. We wish you good luck and have a lot of fun."
        label.textColor = .white
        label.font = .customFont(font: .lato, style: .regular, size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private(set) lazy var infoConteinerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 32
        return view
    }()
    
    private(set) lazy var infoScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        scrollView.isScrollEnabled = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [bgImage,infoScrollView,homeBtn] .forEach(addSubview(_:))
        infoScrollView.addSubview(infoConteinerView)
        infoConteinerView.addSubview(imageConteinerView)
        infoConteinerView.addSubview(subTitleLabel)
        infoConteinerView.addSubview(contentLabel)
        imageConteinerView.addSubview(iconImage)
    }
    
    private func setupConstraints() {
     
        bgImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        homeBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(56)
            make.size.equalTo(48)
        }
        
        infoScrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        infoConteinerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        imageConteinerView.snp.makeConstraints { make in
            make.top.equalTo(homeBtn.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.size.equalTo(180)
        }
        
        iconImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImage.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
    }
}
