//
//  BonusView.swift
//  PlinkTiger
//

import Foundation
import UIKit
import SnapKit

class BonusView: UIView {
    
    let segmentValues = [3, 5, 10, 2, 5, 9, 5, 7]
    private  var corners: [CircleView] = []
    private  let count = 8
    private let colors: [UIColor] = [.clear, .clear, .clear, .clear, .clear, .clear, .clear, .clear]

    
    private(set)  var dailyBonusView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var bgImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .bgClassic
        return imageView
    }()

    
    private(set) lazy var homeButtonsTimer: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(.btnHome, for: .normal)
        return button
    }()
    
    private(set) lazy var homeButtonsDayli: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(.btnHome, for: .normal)
        return button
    }()
    
    private(set)  var titleDayliLabel: UILabel = {
        let label = UILabel()
        label.text = "bonus".uppercased()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.customFont(font: .lato, style: .bold, size: 28)
        label.numberOfLines = 0
        return label
    }()

    private(set) lazy var selectImageView: UIImageView = {
        let image = UIImageView()
        image.image = .rouletteArrowImg
        return image
    }()
    
    private(set) lazy var ellipseIng: UIImageView = {
        let image = UIImageView()
        image.image = .ellipseImg
        return image
    }()

    private(set) lazy var wheelContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()

    private(set) lazy var rouletteImg: UIImageView = {
        let image = UIImageView()
        image.image = .rouletteImg
        return image
    }()

    private(set) lazy var bonusBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(color:.customDarkRed), for: .normal)
        button.setBackgroundImage(UIImage(color: UIColor.red), for: .highlighted)
        button.setTitle("get bonus".uppercased(), for: .normal)
        button.setTitle("get bonus".uppercased(), for: .highlighted)
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

    private(set)  var timerView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private lazy var backImageTimer: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .bgClassic
        return imageView
    }()
    
    private(set)  var titleTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "bonus".uppercased()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.customFont(font: .lato, style: .bold, size: 28)
        label.numberOfLines = 0
        return label
    }()
    

    private(set)  var subtitleTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Time to next bonus:".uppercased()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.customFont(font: .lato, style: .light, size: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private(set) lazy var timecountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.customFont(font: .montserrat, style: .black, size: 60)
        return label
    }()
    
    private lazy var tigetImg: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .tigerImg
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    
    private(set) lazy var okBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(color:.customDarkRed), for: .normal)
        button.setBackgroundImage(UIImage(color: UIColor.red), for: .highlighted)
        button.setTitle("ok".uppercased(), for: .normal)
        button.setTitle("ok".uppercased(), for: .highlighted)
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
        setupCircle()
        setupUI()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(dailyBonusView)
        dailyBonusView.addSubview(bgImage)
        dailyBonusView.addSubview(bonusBtn)
        dailyBonusView.addSubview(titleDayliLabel)
        dailyBonusView.addSubview(wheelContainer)
        wheelContainer.addSubview(rouletteImg)
        dailyBonusView.addSubview(homeButtonsDayli)
        dailyBonusView.addSubview(selectImageView)
        dailyBonusView.addSubview(ellipseIng)
        addSubview(timerView)
        timerView.addSubview(backImageTimer)
        timerView.addSubview(homeButtonsTimer)
        timerView.addSubview(titleTimeLabel)
        timerView.addSubview(subtitleTimeLabel)
        timerView.addSubview(timecountLabel)
        timerView.addSubview(tigetImg)
        timerView.addSubview(okBtn)
        
    }
    
    private func setUpConstraints(){
        
        dailyBonusView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bgImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        homeButtonsDayli.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(34)
            make.left.equalToSuperview().offset(24)
            make.size.equalTo(48)
        }
        
        titleDayliLabel.snp.makeConstraints { make in
            make.top.equalTo(homeButtonsDayli.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
   
        wheelContainer.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(300)
            make.center.equalToSuperview()
        }
        
        rouletteImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        selectImageView.snp.makeConstraints { (make) in
            make.center.equalTo(rouletteImg)
        }
        
        ellipseIng.snp.makeConstraints { (make) in
            make.centerX.equalTo(rouletteImg)
            make.centerY.equalTo(rouletteImg).offset(10)
        }
        
        bonusBtn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(48)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-46)
        }
        
        timerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backImageTimer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        homeButtonsTimer.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(4)
            make.left.equalToSuperview().offset(24)
            make.size.equalTo(48)
        }
        
        titleTimeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(homeButtonsTimer.snp.bottom).offset(40)
        }

        subtitleTimeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleTimeLabel.snp.bottom).offset(40)
        }
        
        timecountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(subtitleTimeLabel.snp.bottom).offset(20)
            make.height.equalTo(46)
            
        }
        
        tigetImg.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timecountLabel.snp.bottom).offset(42)
        }
        
        okBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(48)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-52)
        }
    }
    
    private func setupCircle() {
        for index in 0..<count {
            let corner = CircleView(startAngle: CGFloat(Double(index) / Double(count) * 2 * Double.pi),
                                 endAngle: CGFloat(Double(index + 1) / Double(count) * 2 * Double.pi),
                                 color: colors[index % colors.count])
            wheelContainer.addSubview(corner)
            corners.append(corner)
        }
        corners.forEach { corner in
            corner.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(10)
            }
        }
    }
}
