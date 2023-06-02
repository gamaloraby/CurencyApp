//
//  DetailsViewController.swift
//  Currency
//
//  Created by gamal oraby on 01/06/2023.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {

    @IBOutlet weak var historyDataTable: UITableView!
    @IBOutlet weak var otherCurenciesRate: UITableView!
    
    private let viewModel = DetailsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setHistoryDataTable()
        self.setOtherCurenciesRate()
        viewModel.getLastThreeDayesData { [weak self] _ in
            self?.historyDataTable.reloadData()
           // self?.viewModel.getPopularCurencies()
            
        }
    }

    private func setHistoryDataTable(){
        historyDataTable.delegate = self
        historyDataTable.dataSource = self
        historyDataTable.register(UINib(nibName: "\(CurrencyHistoryCell.self)", bundle: nil), forCellReuseIdentifier: "\(CurrencyHistoryCell.self)")
       
    }
    
    private func setOtherCurenciesRate() {
        //otherCurenciesRate.delegate = self
        //otherCurenciesRate.dataSource = self
        //platesList.register(UINib(nibName: "\(OnlineCheckoutPlatesCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(OnlineCheckoutPlatesCell.self)")
    }
    
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.historicalNumberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.historicalNumberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CurrencyHistoryCell.self)", for: indexPath) as?  CurrencyHistoryCell else {return UITableViewCell()}
        cell.setCellData(with: viewModel.cellDataInRow(in: indexPath.section, row: indexPath.row))
        cell.selectionStyle = .none
        viewModel.getPopularCurencies(in: indexPath.section, at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
           view.backgroundColor =  .gray
           let lbl = UILabel(frame: CGRect(x: 32, y: 0, width: view.frame.width - 15, height: 40))
           lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.text = viewModel.storedDataDay(section: section)
           view.addSubview(lbl)
           return view
         }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 40
    }
}
