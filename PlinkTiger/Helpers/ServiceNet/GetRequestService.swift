//
//  GetRequestService.swift

import Foundation

enum UserServiceError: Error {
    case unkonwn
    case noData
}

class GetRequestService {

    static let shared = GetRequestService()
    
    private init() {}
    
    private let urlString = "https://plinko-tiger-backend-6b365cb38ec8.herokuapp.com/api/players"

    func fetchData(successCompletion: @escaping([User]) -> Void, errorCompletion: @escaping (Error) -> Void) {

        guard let url = URL(string: urlString) else {
            print("Неверный URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
     
        
        guard let token = AuthRequestService.shared.token else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorCompletion(UserServiceError.noData)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    errorCompletion(UserServiceError.unkonwn)
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let users = try decoder.decode([User].self, from: data)
                DispatchQueue.main.async {
                    successCompletion(users)
                }
            }catch {
                print("error", error)
                
                DispatchQueue.main.async {
                    errorCompletion(error)
                }
            }
        }
        task.resume()
    }
}
