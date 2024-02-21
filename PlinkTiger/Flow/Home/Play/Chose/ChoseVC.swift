//
//  ChoseVC.swift
//  PlinkTiger
//
import Foundation
import UIKit

class ChoseVC: UIViewController {

    
    private var contentView: ChoseView {
        view as? ChoseView ?? ChoseView()
    }
    
    override func loadView() {
        view = ChoseView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tappedButtons()
    }
    
    private func tappedButtons() {
        contentView.backBtn.addTarget(self, action: #selector(buttonTappedBack), for: .touchUpInside)
        contentView.classicBtn.addTarget(self, action: #selector(buttonTappedPlay), for: .touchUpInside)
//        contentView.getBonusButtons.addTarget(self, action: #selector(buttonTappedGet), for: .touchUpInside)
    }

    @objc func buttonTappedPlay() {
        let classicVC = ClassicVC()
        navigationController?.pushViewController(classicVC, animated: true)
    }
//
//    @objc func buttonTappedPlayReleased() {
//        contentView.playButtons.layer.borderColor = UIColor.white.cgColor
//    }
//
//    @objc func buttonTappedGet() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.contentView.getBonusButtons.layer.borderColor = UIColor.customOrange.cgColor
//           }
//        let bonusVC = GetBonusVC()
//        navigationController?.pushViewController(bonusVC, animated: true)
//    }
//
//    @objc func buttonTappedGetReleased() {
//        contentView.getBonusButtons.layer.borderColor = UIColor.white.cgColor
//    }
//
//    @objc func buttonTappedLead() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.contentView.leadButtons.layer.borderColor = UIColor.customOrange.cgColor
//           }
//        let leaderboardVC = LeaderboardVC()
//        navigationController?.pushViewController(leaderboardVC, animated: true)
//    }
//
//    @objc func buttonTappedLeadReleased() {
//        contentView.leadButtons.layer.borderColor = UIColor.white.cgColor
//    }
//
//
    @objc func buttonTappedBack() {
        navigationController?.popViewController(animated: true)
    }
}

