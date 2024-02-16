//
//  InfoVC.swift
//  PlinkTiger


import Foundation
import UIKit

class InfoVC: UIViewController {
    
    private var contentView: InfoView {
        view as? InfoView ?? InfoView()
    }
    
    override func loadView() {
        view = InfoView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tappedButtons()
    }
    
    
    private func tappedButtons() {
        contentView.homeBtn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}

