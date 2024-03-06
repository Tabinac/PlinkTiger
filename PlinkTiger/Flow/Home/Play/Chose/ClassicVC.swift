//
//  ClassicVC.swift
//  PlinkTiger


import UIKit
import SpriteKit
import SnapKit

final class ClassicVC: UIViewController {
    private let gameSceneView = SKView()
    public var gameScene: ClassicScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGameScene()
        receivingResultComplition()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setConstraints()
    }
}

// MARK: - Setup Subviews

extension ClassicVC {
    private func setupGameScene() {
        let size = CGSize(width: view.bounds.width, height: view.bounds.height)
        gameScene = ClassicScene(size: size)
        gameScene.scaleMode = .aspectFill
        
        gameSceneView.ignoresSiblingOrder = true
        gameSceneView.backgroundColor = .clear
        gameSceneView.presentScene(gameScene)
        view.addSubview(gameSceneView)
        gameScene.view?.showsFPS = false
        gameSceneView.showsPhysics = false
        
    }
    
    private func setConstraints() {
        gameSceneView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Complition result game

extension ClassicVC {
    private func receivingResultComplition() {
        gameScene.resultTransfer = { [weak self] result in
            guard let self else { return }
            if result == .back {
                navigationController?.popViewController(animated: true)
            }
            if result == .updateScoreBackEnd {
            print("UPDATEBACK")
                updateScore()
            }
            if result == .nolifes {
                let alert = UIAlertController(title: "Sorry", message: "You don't have enough meat", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func updateScore() {
        let payload = UpdatePayload(name: nil, score: Memory.shared.scoreCoints)
        PostRequestService.shared.updateData(id: Memory.shared.userID!, payload: payload) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("Success")
                case .failure(let failure):
                    print("Error - \(failure.localizedDescription)")
                }
            }
        }
    }
}
