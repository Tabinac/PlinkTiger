//
//  LeadCell.swift

import Foundation
import UIKit
import SnapKit

class LeadCell: UITableViewCell {
    
    static let reuseId = String(describing: LeadCell.self)

    private(set) lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(font: .lato, style: .light, size: 20)
        label.textColor = .white
        return label
    }()

    private(set) lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(font: .lato, style: .black, size: 20)
        label.textColor = .white
        return label
    }()
    
    private(set) lazy var leadView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.customBrown.cgColor
        view.backgroundColor = .customDarkRed
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setUpConstraints()
    }
    
        func setupUI() {
            backgroundColor = .clear
            contentView.addSubview(leadView)
            contentView.backgroundColor = .clear
            selectionStyle = .none
            [nameLabel,scoreLabel] .forEach(leadView.addSubview(_:))

    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        scoreLabel.text =  nil
    }
    
    private func setUpConstraints(){
        
        leadView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(345)
        }

        scoreLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(32)
        }
        
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-32)
        }
    }
}
