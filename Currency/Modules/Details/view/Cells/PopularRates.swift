//
//  popularRates.swift
//  Currency
//
//  Created by gamal oraby on 03/06/2023.
//

import UIKit

class PopularRates: UICollectionViewCell {

    @IBOutlet weak var currencyText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCellData(with text: String) {
        currencyText.text = text
    }
}
