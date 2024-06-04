//
//  FoodsDaoRepository.swift
//  iosYemekUyg
//
//  Created by Merve Sansarcı on 3.06.2024.
//

import Foundation
import RxSwift
import Alamofire

class YemeklerRepository {
    var yemekListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    var sepetYemekListesi = BehaviorSubject<[SepetYemekler]>(value: [SepetYemekler]())
    var sepetYemekler: [SepetYemekler]?
    
    func yemekleriYukle(searchText: String?) {
        AF.request("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php", method: .get).response { response in
            if let data = response.data {
                do {
                    let res = try JSONDecoder().decode(YemeklerCevap.self, from: data)
                    if var list = res.yemekler {
                        if let searchText = searchText, !searchText.isEmpty {
                            list = list.filter { food in
                                return food.yemek_adi!.localizedCaseInsensitiveContains(searchText)
                            }
                        }
                        self.yemekListesi.onNext(list)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func yemekResimleriYukle(imageName: String) -> URL? {
        return URL(string: ("http://kasimadalan.pe.hu/yemekler/resimler/" + imageName))
    }
    
    func sepeteEkle(cartFood: SepetYemekler) {
        let params: Parameters = ["yemek_adi":cartFood.yemek_adi!,
                                  "yemek_resim_adi":cartFood.yemek_resim_adi!,
                                  "yemek_fiyat":cartFood.yemek_fiyat!,
                                  "yemek_siparis_adet":cartFood.yemek_siparis_adet!,
                                  "kullanici_adi":cartFood.kullanici_adi!]
        
        AF.request("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php", method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let res = try JSONDecoder().decode(CRUDCevap.self, from: data)
                    print("Success: \(res.success!)")
                    print("Message: \(res.message!)")
                } catch {
                    print(error.localizedDescription)
                }
                self.sepetiYukle(kullaniciAdi: cartFood.kullanici_adi!)
            }
        }
    }
    
    func sepetiYukle(kullaniciAdi: String) {
        let params: Parameters = ["kullanici_adi":kullaniciAdi]
        
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php", method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let res = try JSONDecoder().decode(SepetYemeklerCevap.self, from: data)
                    print("Success: \(res.success!)")
                    if let list = res.sepet_yemekler {
                        self.sepetYemekListesi.onNext(list)
                    }
                } catch {
                    print(error.localizedDescription)
                    self.sepetYemekListesi.onNext([])
                }
            }
        }
    }
    
    func sepettenSil(sepet_yemek_id: Int, kullaniciAdi: String) {
        let params: Parameters = ["sepet_yemek_id":sepet_yemek_id, "kullanici_adi":kullaniciAdi]
        
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php", method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let res = try JSONDecoder().decode(CRUDCevap.self, from: data)
                    print("Success: \(res.success!)")
                    print("Message: \(res.message!)")
                } catch {
                    print(error.localizedDescription)
                }
                self.sepetiYukle(kullaniciAdi: kullaniciAdi)
            }
        }
    }
}
