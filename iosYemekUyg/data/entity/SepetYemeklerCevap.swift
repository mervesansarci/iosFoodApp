//
//  CardFoodsResponse.swift
//  iosYemekUyg
//
//  Created by Merve Sansarcı on 3.06.2024.
//

import Foundation

class SepetYemeklerCevap: Codable {
    var sepet_yemekler: [SepetYemekler]?
    var success: Int?
}
