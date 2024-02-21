//
//  BuyView.swift
//  PlinkTiger
import Foundation
import UIKit
import SnapKit

class BuyView: UIView {
    
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

    private(set) lazy var meatConteiner: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.layer.borderColor = UIColor.customBrown.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private lazy var meatImg: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .meatImg
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private(set) lazy var scoreMeat: UILabel = {
        let label = UILabel()
        label.text = "\(Memory.shared.scoreMeat)"
        label.font = .customFont(font: .lato, style: .bold, size: 18)
        label.textColor = .white
        return label
    }()
    
    private(set) lazy var scoreContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.layer.borderColor = UIColor.customBrown.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private(set) lazy var scoreCoints: UILabel = {
        let label = UILabel()
        label.text = "\(Memory.shared.scoreCoints)"
        label.font = .customFont(font: .lato, style: .bold, size: 18)
        label.textColor = .white
        return label
    }()
    private(set) var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "b u y   g e m s".uppercased()
        label.textAlignment = .center
        label.font = .customFont(font: .lato, style: .bold, size: 28)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .customBrown
        return view
    }()
    
    private lazy var totalView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .total
        return imageView
    }()

    private(set) lazy var buyBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(color:.customDarkRed), for: .normal)
        button.setBackgroundImage(UIImage(color: UIColor.red), for: .highlighted)
        button.setTitle("b u y   m e a t".uppercased(), for: .normal)
        button.setTitle("b u y   m e a t".uppercased(), for: .highlighted)
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
        [backImage,backBtn,meatConteiner,scoreContainer,titleLabel,lineView,totalView,buyBtn] .forEach(addSubview(_:))
        meatConteiner.addSubview(meatImg)
        meatConteiner.addSubview(scoreMeat)
        scoreContainer.addSubview(scoreCoints)
    }
    
    private func setUpConstraints(){
        
        backImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(4)
            make.left.equalToSuperview().offset(24)
            make.size.equalTo(48)
        }

        meatConteiner.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(4)
            make.left.equalTo(backBtn.snp.right).offset(28)
            make.height.equalTo(48)
            make.width.equalTo(88)
        }
        
        meatImg.snp.makeConstraints { (make) in
            make.centerY.equalTo(meatConteiner)
            make.left.equalToSuperview().offset(16)
            make.size.equalTo(24)
        }
        
        scoreMeat.snp.makeConstraints { (make) in
            make.centerY.equalTo(meatConteiner)
            make.right.equalToSuperview().offset(-16)
        }
    
        scoreContainer.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(4)
            make.left.equalTo(meatConteiner.snp.right).offset(28)
            make.height.equalTo(48)
            make.width.equalTo(88)
        }

        scoreCoints.snp.makeConstraints { (make) in
            make.center.equalTo(scoreContainer)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backBtn.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalTo(260)
        }

        totalView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }


        buyBtn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(48)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-82)
        }
    }
}
