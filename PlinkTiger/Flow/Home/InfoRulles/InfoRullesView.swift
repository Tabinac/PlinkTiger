//
//  InfoRullesView.swift


import Foundation
import UIKit
import SnapKit

class InfoRullesView: UIView {
    
    private lazy var bgImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .bgClassic
        return imageView
    }()

    private(set) lazy var backBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(.btnBack, for: .normal)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .customFont(font: .montserrat, style: .black, size: 28)
        label.text = "g a m e  r u l l e s".uppercased()
        return label
    }()

    private lazy var rullesField: UITextView = {
        let textView = UITextView()
        textView.text = "1.Classic - a game in which a ball falls and bounces off round balls, and each ball is worth 50 points, and the price of one ball is 1 meat, conditions: \nPrice of one ball: 1 meat\nPoints for one ball: 50 points.\nThe game is to hit the bonus platforms with the ball and earn points. Every time the ball hits the platforms with a bonus, you get 50 points multiplied by the coefficient by which it will fall. \n\n\n2.CatchBall - game in which you must catch all five balls using the bonus platform, each ball costs 200 points, conditions:\nGame price: 5 meat. \nEach ball caught multiplies its value by 5. Have a fun game!  \n\n\n3.Place Ball - game in which you choose where the ball will start its path and then bounce off round balls, and each ball costs 50 points, and the price of one ball is 1 meat, conditions: \nPrice of one ball: 1 meat \nPoints for one ball: 50 points \nThe game is to hit the bonus platforms with the ball and earn points. Every time the ball hits the platforms with a bonus, you get 50 points multiplied by the coefficient by which it will fall."
        textView.textColor = .white
        textView.font = .customFont(font: .lato, style: .regular, size: 16)
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        return textView
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
        [bgImage,backBtn,titleLabel,rullesField] .forEach(addSubview(_:))
    }
    
    private func setupConstraints() {
     
        bgImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24.autoSize)
            make.top.equalToSuperview().offset(56.autoSize)
            make.size.equalTo(48.autoSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(backBtn.snp.bottom).offset(56.autoSize)
        }

        rullesField.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-60.autoSize)
            make.left.right.equalToSuperview().inset(28.autoSize)
            make.width.equalTo(374.autoSize)
        }
    }
}
