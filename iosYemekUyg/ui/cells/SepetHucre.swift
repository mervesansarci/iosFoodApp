//
//  FoodCartTableViewCell.swift
//  iosYemekUyg
//
//  Created by Merve Sansarcı on 3.06.2024.
//

import UIKit

class SepetHucre: UITableViewCell {
    @IBOutlet weak var sepetView: UIView!
    @IBOutlet weak var ivSepetYemek: UIImageView!
    @IBOutlet weak var lblYemekAdi: UILabel!
    @IBOutlet weak var lblFiyat: UILabel!
    @IBOutlet weak var lblAdet: UILabel!
    @IBOutlet weak var lblToplamFiyat: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
