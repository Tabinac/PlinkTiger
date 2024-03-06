//
//  RequestPayload.swift
//  PlinkTiger

import Foundation

struct CreateRequestPayload: Encodable {
    let name: String?
    let score: Int
    func makeBody() -> String
    {
        var data = [String]()
        data.append("score=\(score)")
        if let name = name {
            data.append("name=\(name)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
}

struct CreateResponse: Decodable {
    let name: String?
    let id: Int
    let score: Int
    let imageURL: String?
    
}

struct UpdatePayload: Encodable {
    
    let name: String?
    let score: Int?
}

