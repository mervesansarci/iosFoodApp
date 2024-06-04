//
//  FoodsResponse.swift
//  iosYemekUyg
//
//  Created by Merve Sansarcı on 3.06.2024.
//

import Foundation

class YemeklerCevap : Codable {
    var yemekler: [Yemekler]?
    var success: Int?
}
