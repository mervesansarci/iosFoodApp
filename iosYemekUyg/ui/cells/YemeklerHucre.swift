//
//  HomeCollectionViewCell.swift
//  iosYemekUyg
//
//  Created by Merve Sansarcı on 3.06.2024.
//

import UIKit

class YemeklerHucre: UICollectionViewCell {
    
    @IBOutlet weak var ivYemek: UIImageView!
    @IBOutlet weak var lblYemekAdi: UILabel!
    @IBOutlet weak var lblYemekFiyat: UILabel!
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           setupShadow()
       }
       
       required init?(coder: NSCoder) {
           super.init(coder: coder)
           setupShadow()
       }
       
       private func setupShadow() {
           // Köşe yarıçapı
           contentView.layer.cornerRadius = 10
           contentView.layer.masksToBounds = true
           
           // Gölge
           layer.shadowColor = UIColor.black.cgColor
           layer.shadowOpacity = 0.3
           layer.shadowOffset = CGSize(width: 0, height: 2)
           layer.shadowRadius = 2
           layer.masksToBounds = false
           
           // ShadowPath ayarlama
           let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius)
           layer.shadowPath = shadowPath.cgPath
       }
       
       override func layoutSubviews() {
           super.layoutSubviews()
           // ShadowPath her seferinde güncellenmelidir
           let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius)
           layer.shadowPath = shadowPath.cgPath
       }
}
