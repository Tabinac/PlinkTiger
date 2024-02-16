//
//  CongratilationVC.swift
//  PlinkTiger

import Foundation
import UIKit
import SnapKit

class CongratilationVC: UIViewController {
    
    var total: Int = 0
    
    var contentView: CongratilationView {
        view as? CongratilationView ?? CongratilationView()
    }
    
    override func loadView() {
        view = CongratilationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tappedButtons()
        configureLabel()
    }
    
    private func tappedButtons() {
        contentView.homeBtn.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        contentView.thanksBtn.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    }
    
    private func configureLabel() {
        contentView.scoreMeatLabel.text = "+\(total)\n MEAT"
    }

    @objc func closeView() {
        Memory.shared.lastBonusDate = Date()
        navigationController?.popToRootViewController(animated: true)
    }
}
