//
//  HomeVC.swift
//  PlinkTiger
//



import Foundation
import UIKit

class HomeVC: UIViewController {

    private let authRequset = AuthRequestService.shared
    private var activityIndicator: UIActivityIndicatorView!
    private let memory = Memory.shared
    private let postService = PostRequestService.shared

    
    private var contentView: HomeView {
        view as? HomeView ?? HomeView()
    }
    
    override func loadView() {
        view = HomeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tappedButtons()
        configureActivityIndicator()
        authenticateAndCheckToken()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLabels()
    }

    
    private func updateLabels() {
        contentView.scoreCoints.text = "\(Memory.shared.scoreCoints)"
        contentView.scoreMeat.text = "\(Memory.shared.scoreMeat)"

    }
    private func tappedButtons() {
        contentView.profileButtons.addTarget(self, action: #selector(buttonTappedProfile), for: .touchUpInside)
        contentView.playButtons.addTarget(self, action: #selector(buttonTappedPlay), for: .touchUpInside)
        contentView.getBonusButtons.addTarget(self, action: #selector(buttonTappedGet), for: .touchUpInside)
        contentView.buyButtons.addTarget(self, action: #selector(buttonTappedBuy), for: .touchUpInside)
        contentView.infoRullesBtn.addTarget(self, action: #selector(buttonTappedRulles), for: .touchUpInside)
        contentView.leadButtons.addTarget(self, action: #selector(buttonTappedBoard), for: .touchUpInside)
    }
    
    private func authenticateAndCheckToken() {
        Task {
            do {
                activityIndicator.startAnimating()
                try await authRequset.authenticate()
                checkToken()
                createUserIfNeeded()
                activityIndicator.stopAnimating()
            } catch {
                print("Authentication failed. Error: \(error)")
                activityIndicator.stopAnimating()
            }
        }
    }

    private func createUserIfNeeded() {
        if memory.userID == nil {
            let payload = CreateRequestPayload(name: nil, score: 0)
            postService.createUser(payload: payload) { [weak self] createResponse in
                guard let self = self else { return }
                memory.userID = createResponse.id
            } errorCompletion: { error in
                print("Ошибка получени данных с бека")
            }
        }
    }
    
    private func checkToken() {
        guard let token = authRequset.token else {
            return
        }
    }

    
    private func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .red
        contentView.addSubview(activityIndicator)
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
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

