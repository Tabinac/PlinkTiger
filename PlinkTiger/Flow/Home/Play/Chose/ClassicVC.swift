//
//  ClassicVC.swift
//  PlinkTiger


import UIKit
import SpriteKit
import SnapKit

enum GameAction {
    case toHome
    case nextLevel
}

typealias ResultingAction = ((GameAction) -> Void)

final class ClassicVC: UIViewController {
    private let gameSceneView = SKView()
    
//    private let model = UserModel.shared
    
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
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
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
            if result == .home {
//                self.router?.popRootView(animated: true)
            }
            if result == .pause {
//                self.pauseToggle()
                self.setupPopupWindow(type: result)
            }
            
            if result == .settings {
//                self.router?.push(scene: .settingsScene, animated: true)
                self.receivingResultComplition()
            }
        }
    }
}

// MARK: - Calculation and Other Methods

extension ClassicVC {
    private func setupPopupWindow(type: GameState) {
//        let popupsView = PopupsView(frame: view.frame, popupType: type)
//        view.addSubview(popupsView)
//
//        popupsView.pauseActionTransfer = { [weak self] action in
//            switch action {
//            case .home:
//                self?.router?.popRootView(animated: true)
//                
//            case .back:
//                NotificationCenter.default.post(name: ConstantsApp.pauseDisabledNotificationName, object: nil)
//                UserModel.shared.firstPlay ? UserModel.shared.firstPlay = false : ()
//            }
//        }
    }
    
//    private func pauseToggle() {
//        gameScene.isPaused.toggle()
//    }
}
