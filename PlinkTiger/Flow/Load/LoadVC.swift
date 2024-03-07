//
//  LoadVC.swift
//  PlinkTiger

import Foundation
import UIKit

class LoadingVC: UIViewController {
    
    private let authRequset = AuthRequestService.shared
    private let memory = Memory.shared
    private let postService = PostRequestService.shared
    
    private var contentView: LoadingView {
        view as? LoadingView ?? LoadingView()
    }
    
    override func loadView() {
        view = LoadingView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateProgressBar()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                  self.loadHomeVC()
              }
    }
    
    func animateProgressBar() {
        UIView.animate(withDuration: 3.5) {
            self.contentView.loadView.setProgress(1.0, animated: true)
        }
    }
    
    func loadHomeVC() {
            Task {
                do {
                    try await authRequset.authenticate()
                    checkToken()
                    createUserIfNeeded()
                    let vc = HomeVC()
                    let navigationController = UINavigationController(rootViewController: vc)
                    navigationController.modalPresentationStyle = .fullScreen
                    present(navigationController, animated: true)
                    navigationController.setNavigationBarHidden(true, animated: false)
                } catch {
                    print("Error: \(error.localizedDescription)")
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
}

