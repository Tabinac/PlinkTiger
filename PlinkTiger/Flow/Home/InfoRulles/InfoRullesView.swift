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
        textView.text = "1.Classic - ... \n\n\n2.CatchBall - ... \n\n\n3.Place Ball - ..."
        textView.textColor = .white
        textView.font = .customFont(font: .lato, style: .regular, size: 20)
        textView.backgroundColor = .clear
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
            make.top.equalTo(titleLabel.snp.bottom).offset(56.autoSize)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(26.autoSize)
            make.left.right.equalToSuperview().inset(28.autoSize)
            make.width.equalTo(374.autoSize)
        }
    }
}
