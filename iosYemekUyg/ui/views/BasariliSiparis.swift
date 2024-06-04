//
//  BasariliSiparis.swift
//  iosYemekUyg
//
//  Created by Merve Sansarcı on 4.06.2024.
//

import UIKit
import UserNotifications
import ImageIO

class BasariliSiparis: UIViewController{
    
    @IBOutlet weak var ivBasariliSiparis: UIImageView!
    @IBOutlet weak var lblZaman: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor(named: "color4")
        saat()
    }
    
    func saat() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let currentDate = Date()
        let futureDate1 = Calendar.current.date(byAdding: .minute, value: 20, to: currentDate)!
        let futureDate2 = Calendar.current.date(byAdding: .minute, value: 40, to: currentDate)!
        
        let futureTimeString1 = dateFormatter.string(from: futureDate1)
        let futureTimeString2 = dateFormatter.string(from: futureDate2)
        
        lblZaman.text = "Tahmini teslimat : \(futureTimeString1) - \(futureTimeString2)"
    }
}

