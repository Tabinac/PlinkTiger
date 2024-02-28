//
//  LoadView.swift
//  PlinkTiger

import Foundation
import UIKit
import SnapKit

class LoadingView: UIView {
    
    private lazy var backImg: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .bgGame
        return imageView
    }()

    private (set) var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Wellcome"
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .customBrown
        return label
    }()

    
    private (set) var tigerImg: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .tigerImg
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
        
    private lazy var loadLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading...".uppercased()
        label.font = UIFont.customFont(font: .montserrat, style: .black, size: 24)
        label.textColor = .customBrown
        label.textAlignment = .center
        return label
    }()
 
    private(set) lazy var loadView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressViewStyle = .bar
        progressView.progress = 0.0
        progressView.progressTintColor = .customBrown
        return progressView
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
        [backImg,tigerImg,titleLabel,loadLabel,loadView] .forEach(addSubview(_:))
   
    }
    
    private func setupConstraints() {
     
        backImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tigerImg.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(300)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(60)
        }
        
        loadLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tigerImg.snp.bottom).offset(60)
        }
        
        loadView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loadLabel.snp.bottom).offset(24)
            make.width.equalTo(126)

        }

    }
}
