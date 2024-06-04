//
//  FoodCartViewModel.swift
//  iosYemekUyg
//
//  Created by Merve Sansarcı on 3.06.2024.
//

import Foundation
import RxSwift

class SepetViewModel {
    
    var yrepo = YemeklerRepository()
    var sepetYemekListesi = BehaviorSubject<[SepetYemekler]>(value: [SepetYemekler]())
    
    init() {
        sepetYemekListesi = yrepo.sepetYemekListesi
    }
    
    func sepeteEkle(sepettekiYemek: SepetYemekler) {
        yrepo.sepeteEkle(cartFood: sepettekiYemek)
    }
    
    func yemekResimleriYukle(imageName: String) -> URL? {
        return yrepo.yemekResimleriYukle(imageName: imageName)
    }
    
    func sepettenSil(sepet_yemek_id: Int, kullanici_adi: String) {
        yrepo.sepettenSil(sepet_yemek_id: sepet_yemek_id, kullaniciAdi: kullanici_adi)
    }
    
    func sepetiYukle(kullaniciAdi: String) {
        yrepo.sepetiYukle(kullaniciAdi: kullaniciAdi)
    }
    
}
