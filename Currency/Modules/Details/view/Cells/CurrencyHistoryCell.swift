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
    @IBOutlet weak var popularRatesCollection: UICollectionView!
    
    private var popularRates = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
    }
    
    func setCellData(with data: Rate, popularRates: [String]) {
        fromCurrencyValue.text = data.currencyToCode ?? ""
        fromCurrencyCode.text = data.currencyFromCode ?? ""
        toCurrencyValue.text = "\(data.amount)"
        toCurrencyCode.text = "Amount"
        self.popularRates = popularRates
    }
    
    private func setCollectionView() {
        popularRatesCollection.delegate = self
        popularRatesCollection.dataSource = self
        popularRatesCollection.register(UINib(nibName: "\(PopularRates.self)", bundle: nil), forCellWithReuseIdentifier: "\(PopularRates.self)")
    }
}

extension CurrencyHistoryCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularRates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PopularRates.self)", for: indexPath) as?  PopularRates else {return UICollectionViewCell()}
        cell.setCellData(with: popularRates[indexPath.row])
        return cell
    }
}
extension CurrencyHistoryCell: UICollectionViewDelegateFlowLayout {

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = (collectionView.bounds.width - 16) / 2.0
        return CGSize(width: yourWidth, height: 40)
    }
}
