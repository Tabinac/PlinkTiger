//
//  HomeVC.swift
//  PlinkTiger
//



import Foundation
import UIKit

class HomeVC: UIViewController {

    
    private var contentView: HomeView {
        view as? HomeView ?? HomeView()
    }
    
    override func loadView() {
        view = HomeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tappedButtons()
    }
    
    private func tappedButtons() {
        contentView.profileButtons.addTarget(self, action: #selector(buttonTappedProfile), for: .touchUpInside)
        contentView.playButtons.addTarget(self, action: #selector(buttonTappedPlay), for: .touchUpInside)
        contentView.getBonusButtons.addTarget(self, action: #selector(buttonTappedGet), for: .touchUpInside)
//        contentView.leadButtons.addTarget(self, action: #selector(buttonTappedLead), for: .touchUpInside)
    }
    
    @objc func buttonTappedPlay() {
        let choseVC = ChoseVC()
        navigationController?.pushViewController(choseVC, animated: true)
    }

    @objc func buttonTappedGet() {
        let bonusVC = BonusVC()
        navigationController?.pushViewController(bonusVC, animated: true)
    }
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
    @objc func buttonTappedProfile() {
        let profileVC = ProfileVC()
        navigationController?.pushViewController(profileVC, animated: true)
    }
}

