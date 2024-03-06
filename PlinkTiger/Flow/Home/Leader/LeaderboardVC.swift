//
//  LeaderboardVC.swift


import Foundation
import UIKit

class LeaderBoardVC: UIViewController {
    
    var users = [User]()
    let getRequestService = GetRequestService.shared
    private var activityIndicator: UIActivityIndicatorView!

    private var contentView: LeaderBoardView {
        view as? LeaderBoardView ?? LeaderBoardView()
    }
    
    override func loadView() {
        view = LeaderBoardView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityIndicator()
        loadUsers()
        configureTableView()
        tappedButtons()
    }
    
    private func configureTableView() {
        contentView.leaderBoardTableView.dataSource = self
        contentView.leaderBoardTableView.delegate = self
        contentView.leaderBoardTableView.separatorStyle = .none
        
    }
    
    private func tappedButtons() {
        contentView.backBtn.addTarget(self, action: #selector(goButtonTappedBack), for: .touchUpInside)
    }

    private func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .green
        contentView.addSubview(activityIndicator)
        activityIndicator.transform = CGAffineTransform(scaleX: 5, y: 5)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

@objc func goButtonTappedBack() {
    navigationController?.popViewController(animated: true)
}

func sorterScoreUsers() {
    users.sort {
        $1.score < $0.score
    }
}

func loadUsers() {
    activityIndicator.startAnimating()
    getRequestService.fetchData { [weak self] users in
        guard let self = self else { return }
        self.users = users
        self.contentView.leaderBoardTableView.reloadData()
        self.sorterScoreUsers()
        self.activityIndicator.stopAnimating()
    } errorCompletion: { [weak self] error in
        guard self != nil else { return }
        self?.activityIndicator.stopAnimating()
        
        }
    }
}

extension LeaderBoardVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeadCell.reuseId, for: indexPath)
        
        guard let leaderCell = cell as? LeadCell else {
            
            return cell
        }
        
        
        let index = indexPath.row
        
        let user = users[index]
        
        setupCell(leaderBoardCell: leaderCell, user: user)
        
        return leaderCell
    }
    
    func setupCell(leaderBoardCell: LeadCell, user: User) {
        
        leaderBoardCell.scoreLabel.text = String(user.score)
        leaderBoardCell.nameLabel.text = user.name == nil || user.name == "" ? "USER# \(user.id ?? 0)" : user.name
        
    }
    
}

