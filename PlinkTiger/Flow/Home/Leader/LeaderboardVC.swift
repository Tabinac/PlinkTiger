//
//  LeaderboardVC.swift


import Foundation
import UIKit

class LeaderBoardVC: UIViewController {
    
    var users = [User]()
    let getRequestService = GetRequestService.shared
    private var loader: UIActivityIndicatorView!

    private var contentView: LeaderBoardView {
        view as? LeaderBoardView ?? LeaderBoardView()
    }
    
    override func loadView() {
        view = LeaderBoardView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderConfigure()
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

    private func loaderConfigure() {
        loader = UIActivityIndicatorView(style: .medium)
        loader.hidesWhenStopped = true
        loader.color = .white
        contentView.addSubview(loader)
        loader.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        loader.snp.makeConstraints { make in
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
    loader.startAnimating()
    getRequestService.fetchData { [weak self] users in
        guard let self = self else { return }
        self.users = users
        self.contentView.leaderBoardTableView.reloadData()
        self.sorterScoreUsers()
        self.loader.stopAnimating()
    } errorCompletion: { [weak self] error in
        guard self != nil else { return }
        self?.loader.stopAnimating()
        
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

