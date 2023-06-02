//
//  CurrencyHistoryCell.swift
//  Currency
//
//  Created by gamal oraby on 01/06/2023.
//

import UIKit

class CurrencyHistoryCell: UITableViewCell {
    @IBOutlet weak var fromCurrencyCode: UILabel!
    @IBOutlet weak var fromCurrencyValue: UILabel!
    
    @IBOutlet weak var toCurrencyCode: UILabel!
    @IBOutlet weak var toCurrencyValue: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func setCellData(with data: Rate) {
        fromCurrencyValue.text = data.currencyToCode ?? ""
        fromCurrencyCode.text = data.currencyFromCode ?? ""
        toCurrencyValue.text = "\(data.amount)"
        toCurrencyCode.text = "Amount"
    }
}
