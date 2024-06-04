//
//  ViewController.swift
//  iosYemekUyg
//
//  Created by Merve Sansarcı on 3.06.2024.
//

import UIKit
import Kingfisher
import RxSwift

class Anasayfa: UIViewController {
    
    @IBOutlet weak var AnasayfaCV: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var navBar: UINavigationItem!
        
    let viewModel = AnasayfaViewModel()
    var yemekListesi = [Yemekler]()
    var kullaniciAdi: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        AnasayfaCV.delegate = self
        AnasayfaCV.dataSource = self
        
        let appearanceTab = UITabBarAppearance()
        appearanceTab.backgroundColor = UIColor(named: "color4")
        
        renkDegistir(itemAppearance: appearanceTab.stackedLayoutAppearance)
        renkDegistir(itemAppearance: appearanceTab.inlineLayoutAppearance)
        renkDegistir(itemAppearance: appearanceTab.compactInlineLayoutAppearance)
        
        tabBarController?.tabBar.standardAppearance = appearanceTab
        tabBarController?.tabBar.scrollEdgeAppearance = appearanceTab
        
        self.navigationItem.title = "Şeften Eve"
            
        view.backgroundColor = UIColor.white
        AnasayfaCV.backgroundColor = UIColor.clear
        searchBar.barTintColor = UIColor(named: "color1")
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
                  textField.backgroundColor = UIColor.white
              }
        let appearanceNav = UINavigationBarAppearance()
        appearanceNav.backgroundColor = UIColor(named: "color1")
        appearanceNav.titleTextAttributes = [.foregroundColor: UIColor(named: "color4")!,.font:UIFont.boldSystemFont(ofSize: 22)]
 
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.standardAppearance = appearanceNav
        navigationController?.navigationBar.compactAppearance = appearanceNav
        navigationController?.navigationBar.scrollEdgeAppearance = appearanceNav
        
        let tasarim = UICollectionViewFlowLayout()
        tasarim.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tasarim.minimumLineSpacing = 10
        tasarim.minimumInteritemSpacing = 10
        let ekran = UIScreen.main.bounds.width
        let itemWidth = (ekran - 30) / 2

        tasarim.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.2)

        AnasayfaCV.collectionViewLayout = tasarim
        
        _ = viewModel.yemekListesi.subscribe(onNext: { list in
            self.yemekListesi = list
            DispatchQueue.main.async {
                self.AnasayfaCV.reloadData()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.yemekleriYukle(searchText: "")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetay" {
            if let food = sender as? Yemekler {
                let destinationVC = segue.destination as! YemekDetay
                destinationVC.yemek = food
                destinationVC.imageUrl = viewModel.yemekResimleriYukle(imageName: food.yemek_resim_adi!)
            }
        }
    }
}

extension Anasayfa: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.yemekleriYukle(searchText: searchText)
    }
}

extension Anasayfa: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return yemekListesi.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hucre = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! YemeklerHucre
        
        let yemek = yemekListesi[indexPath.row]
    
        hucre.lblYemekAdi.text = yemek.yemek_adi
        hucre.lblYemekFiyat.text = String(yemek.yemek_fiyat! + " ₺")
        
        if let imageUrl = viewModel.yemekResimleriYukle(imageName: yemek.yemek_resim_adi!) {
            hucre.ivYemek.kf.setImage(with: imageUrl)
        }
        
        hucre.layer.borderColor = UIColor.lightGray.cgColor
        hucre.layer.borderWidth = 0.3
        hucre.layer.cornerRadius = 10.0
        
        hucre.backgroundColor = UIColor.white
        
        return hucre
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let food = yemekListesi[indexPath.row]
        
        performSegue(withIdentifier: "toDetay", sender: food)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

func renkDegistir(itemAppearance:UITabBarItemAppearance){
    itemAppearance.selected.iconColor = UIColor(named: "color1")
    itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "color1")!]
    
    itemAppearance.normal.iconColor = UIColor(named: "color3")
    itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(named: "color3")!]
}
