//
//  LeaderboardView.swift
//  PlinkTiger
import Foundation
import UIKit

class LeaderBoardView: UIView {
    
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
        label.text = "leaderboard".uppercased()
        label.textAlignment = .center
        label.font = .customFont(font: .lato, style: .regular, size: 28)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .customBrown
        return view
    }()

    private(set) lazy var leaderBoardTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.register(LeadCell.self, forCellReuseIdentifier: LeadCell.reuseId)
        tableView.separatorStyle = .none
        return tableView
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
        [backImage,backBtn,titleLabel,lineView,leaderBoardTableView] .forEach(addSubview(_:))
    }
    private func setUpConstraints(){
        
        backImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        backBtn.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(34)
            make.left.equalToSuperview().offset(24)
            make.size.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backBtn.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(66)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalTo(260)
        }

        leaderBoardTableView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-48)
        }
    }
}
