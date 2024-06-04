//
//  FoodCartViewController.swift
//  iosYemekUyg
//
//  Created by Merve Sansarcı on 3.06.2024.
//

import UIKit
import RxSwift
import UserNotifications

class Sepet: UIViewController {
    
    var izinKontrol = false

    @IBOutlet weak var sepetTV: UITableView!
    @IBOutlet weak var lblToplam: UILabel!

    var sepetYemekler = [SepetYemekler]()
    var viewModel = SepetViewModel()
    var kullaniciAdi: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sepetTV.delegate = self
        sepetTV.dataSource = self
        
        let appearanceNav = UINavigationBarAppearance()
        appearanceNav.backgroundColor = UIColor(named: "color1")
        appearanceNav.titleTextAttributes = [.foregroundColor: UIColor(named: "color4")!,.font:UIFont.boldSystemFont(ofSize: 22)]
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.standardAppearance = appearanceNav
        navigationController?.navigationBar.compactAppearance = appearanceNav
        navigationController?.navigationBar.scrollEdgeAppearance = appearanceNav
        
        _ = viewModel.sepetYemekListesi.subscribe(onNext: { liste in
            self.sepetYemekler = liste
            DispatchQueue.main.async {
                self.sepetTV.reloadData()
            }
        })
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound,.badge], completionHandler:{
            granted, error in
            self.izinKontrol = granted
        })
        UNUserNotificationCenter.current().delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.kullaniciAdi = "meru"
        print("kullanici: \(kullaniciAdi ?? "kullanici yok")")
        self.sepetiYukle()
        
        viewModel.sepetiYukle(kullaniciAdi: "meru")
    }
    
    @IBAction func buttonSatinAl(_ sender: Any) {
        if izinKontrol {
            let content = UNMutableNotificationContent()
            content.title = "Şeften Eve"
            content.subtitle = "Yemeğiniz hazırlanıyor!"
            content.body = "2 sipariş daha ver, indirim kazan!"
            content.badge = 1
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            
            let request = UNNotificationRequest(identifier: "id", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
    }

    func toplamFiyat(){
        var toplamSepetFiyat = 0
            for cart in sepetYemekler {
            if let fiyatString = cart.yemek_fiyat, let adetString = cart.yemek_siparis_adet,
               let yemekFiyat = Int(fiyatString), let yemekAdet = Int(adetString) {
                toplamSepetFiyat += yemekFiyat * yemekAdet
            }
        }
        
        let endTotal = Double(toplamSepetFiyat)
        
        lblToplam.text = String(endTotal) + " ₺"
        self.sepetTV.reloadData()
    }
    
    func sepetiYukle() {
        _ = viewModel.sepetYemekListesi.subscribe(onNext: { list in
            self.sepetYemekler = list
            DispatchQueue.main.async {
                self.toplamFiyat()
                self.sepetTV.reloadData()
            }
        })
        
        self.viewModel.sepetiYukle(kullaniciAdi: self.kullaniciAdi!)
        self.sepetTV.reloadData()
    }
}

extension Sepet : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sepetYemekler.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hucre = sepetTV.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! SepetHucre
        
        let sepet = sepetYemekler[indexPath.row]
        
        hucre.lblYemekAdi.text = sepet.yemek_adi
        hucre.lblFiyat.text = "\(sepet.yemek_fiyat!) ₺"
        hucre.lblAdet.text = "\(sepet.yemek_siparis_adet!) adet"
        
        if let quantity = Int(sepet.yemek_siparis_adet!), let foodPrice = Int(sepet.yemek_fiyat!) {
            let perPrice = foodPrice * quantity
            hucre.lblToplamFiyat.text = "\(perPrice) ₺"
        }
        
        if let imageUrl = viewModel.yemekResimleriYukle(imageName: sepet.yemek_resim_adi!) {
            hucre.ivSepetYemek.kf.setImage(with: imageUrl)
        }
        
        return hucre
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let silAction = UIContextualAction(style: .destructive, title: "Sil"){ contextualAction,view,bool in
            let sepet = self.sepetYemekler[indexPath.row]
            
            let alert = UIAlertController(title: "Sepetinizden ürün siliyorsunuz!", message: "\(sepet.yemek_adi!) silinsin mi?", preferredStyle: .alert)
            
            let iptalAction = UIAlertAction(title: "İptal", style: .cancel)
            alert.addAction(iptalAction)
            
            let evetAction = UIAlertAction(title: "Evet", style: .destructive){ _ in
                self.viewModel.sepettenSil(sepet_yemek_id: Int(sepet.sepet_yemek_id!)!, kullanici_adi: "meru")
            }
            alert.addAction(evetAction)
            
            self.present(alert, animated: true)
        }
        
        return UISwipeActionsConfiguration(actions: [silAction])
    }
}

extension Sepet : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner,.sound,.badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let app = UIApplication.shared
        
        if app.applicationState == .active{
            print("önplan: bildirim seçildi")
        }
        
        if app.applicationState == .inactive{
            print("arkaplan: bildirim seçildi")
        }
        
        center.setBadgeCount(0)
        completionHandler()
    }
}
