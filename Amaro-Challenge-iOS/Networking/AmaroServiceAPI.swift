//
//  AmaroServiceAPI.swift
//  Amaro-Challenge-iOS
//
//  Created by Ricardo Hochman on 26/04/19.
//  Copyright © 2019 Ricardo Hochman. All rights reserved.
//

import UIKit

class AmaroServiceAPI {
    
    // MARK: - Constants
    public static let shared = AmaroServiceAPI()
    private init() {}
    private let baseURL = URL(string: "http://www.mocky.io/v2/")!
    
    // MARK: - Endpoint
    enum Endpoint: String {
        case products = "59b6a65a0f0000e90471257d"
    }
    
    func fetchData(from endpoint: Endpoint, completion: @escaping (Result<ProductsResponse, APIServiceError>) -> Void) {
        let url = baseURL.appendingPathComponent(endpoint.rawValue)
        RequestManager.fetchResources(url: url, completion: completion)
    }
    
    func getImage(url: String, completion: @escaping (Result<UIImage, APIServiceError>) -> Void) {
        guard let url = URL(string: url) else { return }
        RequestManager.getImage(url: url, completion: completion)
    }
}
