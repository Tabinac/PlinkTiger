//
//  PlaceBallVC.swift



import UIKit
import SpriteKit
import SnapKit

final class PlaceBallVC: UIViewController {
    private let placeSceneView = SKView()
    public var placeScene: PlaceBallScene!
    
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

extension PlaceBallVC {
    private func setupGameScene() {
        let size = CGSize(width: view.bounds.width, height: view.bounds.height)
        placeScene = PlaceBallScene(size: size)
        placeScene.scaleMode = .aspectFill
        
        placeSceneView.ignoresSiblingOrder = true
        placeSceneView.backgroundColor = .clear
        placeSceneView.presentScene(placeScene)
        view.addSubview(placeSceneView)
        
    }
    
    private func setConstraints() {
        placeSceneView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Complition result game

extension PlaceBallVC {
    private func receivingResultComplition() {
        placeScene.resultPlace = { [weak self] result in
            guard let self else { return }
            if result == .back {
                navigationController?.popViewController(animated: true)
            }
            if result == .updateScoreBackEnd {
            print("UPDATEBACK")
            }
            if result == .nolifes {
                let alert = UIAlertController(title: "Sorry", message: "You don't have enough meat", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
}