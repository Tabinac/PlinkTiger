//
//  HomeVC.swift
//  PlinkTiger
//



import Foundation
import UIKit

class HomeVC: UIViewController {

    private let memory = Memory.shared
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLabels()
    }

    
    private func updateLabels() {
        contentView.scoreCoints.text = "\(memory.scoreCoints)"
        contentView.scoreMeat.text = "\(memory.scoreMeat)"

    }
    private func tappedButtons() {
        contentView.profileButtons.addTarget(self, action: #selector(buttonTappedProfile), for: .touchUpInside)
        contentView.playButtons.addTarget(self, action: #selector(buttonTappedPlay), for: .touchUpInside)
        contentView.getBonusButtons.addTarget(self, action: #selector(buttonTappedGet), for: .touchUpInside)
        contentView.buyButtons.addTarget(self, action: #selector(buttonTappedBuy), for: .touchUpInside)
        contentView.infoRullesBtn.addTarget(self, action: #selector(buttonTappedRulles), for: .touchUpInside)
        contentView.leadButtons.addTarget(self, action: #selector(buttonTappedBoard), for: .touchUpInside)
    }
    
    @objc func buttonTappedPlay() {
        let choseVC = ChoseVC()
        navigationController?.pushViewController(choseVC, animated: true)
    }

    @objc func buttonTappedGet() {
        let bonusVC = BonusVC()
        navigationController?.pushViewController(bonusVC, animated: true)
    }
    
    @objc func buttonTappedBuy() {
        let buyVC = BuyVC()
        navigationController?.pushViewController(buyVC, animated: true)
    }
    
    @objc func buttonTappedProfile() {
        let profileVC = ProfileVC()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc func buttonTappedRulles() {
        let vc = InfoRullesVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func buttonTappedBoard() {
        let boardVC = LeaderBoardVC()
        navigationController?.pushViewController(boardVC, animated: true)
    }

}

