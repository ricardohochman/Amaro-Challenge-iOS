//
//  CurrencyProtocol.swift
//  Amaro-Challenge-iOS
//
//  Created by Ricardo Hochman on 26/04/19.
//  Copyright © 2019 Ricardo Hochman. All rights reserved.
//

import UIKit

protocol CurrencyProtocol { }

extension CurrencyProtocol {
    func toBrazilianCurrency() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "pt_BR")
        numberFormatter.numberStyle = .currency
        if let number = self as? NSNumber, let convertedString = numberFormatter.string(from: number) {
            return convertedString
        }
        return nil
    }
}

extension Int: CurrencyProtocol { }

extension Double: CurrencyProtocol { }

extension CGFloat: CurrencyProtocol { }
