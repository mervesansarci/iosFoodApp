//
//  HomeViewModel.swift
//  iosYemekUyg
//
//  Created by Merve Sansarcı on 3.06.2024.
//

import Foundation
import RxSwift

class AnasayfaViewModel {
    var yrepo = YemeklerRepository()
    var yemekListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    
    init() {
        yemekListesi = yrepo.yemekListesi
    }
    
    func yemekleriYukle(searchText: String) {
        yrepo.yemekleriYukle(searchText: searchText)
    }
    
    func yemekResimleriYukle(imageName: String) -> URL? {
        return yrepo.yemekResimleriYukle(imageName: imageName)
    }
}
