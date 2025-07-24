//
//  CurrencyInfoEntity.swift
//  WorldView
//
//  Created by Mina Gerges on 24/07/2025.
//

import Foundation
import SwiftData

@Model
class CurrencyInfoEntity {
    var code: String?
    var name: String?
    var symbol: String?
    
    init(code: String? = nil, name: String? = nil, symbol: String? = nil) {
        self.code = code
        self.name = name
        self.symbol = symbol
    }
}
