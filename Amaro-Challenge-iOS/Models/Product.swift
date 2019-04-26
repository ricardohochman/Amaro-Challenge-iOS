//
//  Product.swift
//  Amaro-Challenge-iOS
//
//  Created by Ricardo Hochman on 26/04/19.
//  Copyright © 2019 Ricardo Hochman. All rights reserved.
//

import Foundation

struct Product: Codable {
    let name: String
    let style: String
    let codeColor: String
    let colorSlug: String
    let color: String
    let onSale: Bool
    let regularPrice: String
    let actualPrice: String
    let discountPercentage: String
    let installments: String
    let image: String
    let sizes: [Size]
}
