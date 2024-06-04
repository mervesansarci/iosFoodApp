//
//  FoodDetailViewController.swift
//  iosYemekUyg
//
//  Created by Merve Sansarcı on 3.06.2024.
//

import UIKit

class YemekDetay: UIViewController {
    
    @IBOutlet weak var ivYemek: UIImageView!
    @IBOutlet weak var lblYemekAdi: UILabel!
    @IBOutlet weak var lblFiyat: UILabel!
    @IBOutlet weak var lblAdet: UILabel!
    @IBOutlet weak var lblToplamFiyat: UILabel!
    
    var yemek: Yemekler?
    var sepetYemek = SepetYemekler()
    var sepetYemekListesi = [SepetYemekler]()
    let viewModel = SepetViewModel()
    var imageUrl: URL?
    
    var adet: Int?
    var fiyat: Int?
    var toplamFiyat: Int?
    var kullaniciAdi: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appearance()
        
        self.navigationController?.navigationBar.tintColor = UIColor(named: "color4")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.kullaniciAdi = "meru"
        self.viewModel.sepetiYukle(kullaniciAdi: kullaniciAdi!)
        
        _ = self.viewModel.sepetYemekListesi.subscribe(onNext: { liste in
            self.sepetYemekListesi = liste
        })
    }
    
    func adetGuncelle() {
        lblAdet.text = String(adet!)
    }
    
    func fiyatGuncelle() {
        toplamFiyat = adet! * fiyat!
        lblToplamFiyat.text = "Total: \(toplamFiyat!) ₺"
    }
    

    @IBAction func buttonArttir(_ sender: Any) {
        adet! += 1
        adetGuncelle()
        fiyatGuncelle()
    }
    
    @IBAction func buttonAzalt(_ sender: Any) {
        if adet! > 0 {
            adet! -= 1
        }
        if adet! == 0{
           adet!  = 1
        }
            adetGuncelle()
            fiyatGuncelle()
    }
    
    @IBAction func buttonSepeteEkle(_ sender: Any) {
        let sepetKontrol = sepetKontrol()
        let siparisAdet = adet! + sepetKontrol
        
        sepetYemek.yemek_adi = yemek?.yemek_adi
        sepetYemek.yemek_resim_adi = yemek?.yemek_resim_adi
        sepetYemek.yemek_fiyat = String(toplamFiyat! + (sepetKontrol * fiyat!))
        sepetYemek.yemek_siparis_adet = String(siparisAdet)
        sepetYemek.kullanici_adi = kullaniciAdi
        
        viewModel.sepeteEkle(sepettekiYemek: sepetYemek)
    }
    
    func appearance() {
    
        if let food = yemek, let imageUrl = imageUrl {
            adet = 1
            fiyat = 0
            toplamFiyat = 0
            
            lblYemekAdi.text = food.yemek_adi
            
            fiyat = Int(food.yemek_fiyat!)!
            lblFiyat.text = "\(fiyat!) ₺"
            fiyatGuncelle()
            adetGuncelle()
        
            ivYemek.kf.setImage(with: imageUrl)
        }
    }
}

extension YemekDetay {
    func sepetKontrol() -> Int {
        for sepettekiYemek in sepetYemekListesi {
            if sepettekiYemek.yemek_adi == yemek?.yemek_adi {
                let quantity = Int(sepettekiYemek.yemek_siparis_adet!)!
                viewModel.sepettenSil(sepet_yemek_id: Int(sepettekiYemek.sepet_yemek_id!)!, kullanici_adi: self.kullaniciAdi!)
                return quantity
            }
        }
        return(0)
    }
}
