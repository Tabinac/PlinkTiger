//
//  CatchBallVC.swift


import UIKit
import SpriteKit
import SnapKit

final class CatchBallVC: UIViewController {
    private let catchSceneView = SKView()
    public var catchScene: CatchBallScene!
    
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

extension CatchBallVC {
    private func setupGameScene() {
        let size = CGSize(width: view.bounds.width, height: view.bounds.height)
        catchScene = CatchBallScene(size: size)
        catchScene.scaleMode = .aspectFill
        
        catchSceneView.ignoresSiblingOrder = true
        catchSceneView.backgroundColor = .clear
        catchSceneView.presentScene(catchScene)
        view.addSubview(catchSceneView)
        
    }
    
    private func setConstraints() {
        catchSceneView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Complition result game

extension CatchBallVC {
    private func receivingResultComplition() {
        catchScene.resultCatch = { [weak self] result in
            guard let self else { return }
            if result == .back {
                navigationController?.popViewController(animated: true)
            }
            if result == .updateScoreBackEnd {
                let vc = TotalScoreCatchVC()
                vc.total = catchScene.ballsCollidedWithPanel
                navigationController?.pushViewController(vc, animated: true)
            }
            if result == .nolifes {
                let alert = UIAlertController(title: "Sorry", message: "You don't have enough meat", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
}
