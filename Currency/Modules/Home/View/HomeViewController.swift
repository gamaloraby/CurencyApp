//
//  HomeViewController.swift
//  Currency
//
//  Created by gamal oraby on 30/05/2023.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var currencyFromTextField: UITextField!
    @IBOutlet weak var currencyToTextField: UITextField!
    @IBOutlet weak var currencyFromValue: UITextField!
    @IBOutlet weak var currencyToValue: UITextField!

    private var fromCurrencyPicker = UIPickerView()
    private var toCurrencyPicker =  UIPickerView()
    private let detailsViewName = "DetailsViewController"
    private let viewModel = HomeViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getCurrencyCodes()
        setRXChanales()
    }
    
    private func setRXChanales() {
        viewModel.currencyCodesList.subscribe(onNext: { [weak self] currencyCodesList in
            if currencyCodesList.count > 0 {
                self?.setPickersView()
                self?.iniateTextFields()
                self?.setupIntialInputsValues()
            }
        }).disposed(by: disposeBag)
        
        viewModel.fromCurencyText.subscribe(onNext: { [weak self] response in
            self?.currencyFromTextField.text = response
            let index = self?.viewModel.currencyCodesList.value.firstIndex { code in
                code == response
            }
            self?.setFromCurrencyPickerIndex(with: index ?? 0)
        }).disposed(by: disposeBag)
        
        viewModel.toCurencyValueText.subscribe(onNext: { [weak self] value in
            self?.currencyToTextField.text = value
            let index = self?.viewModel.currencyCodesList.value.firstIndex { code in
                code == value
            }
            self?.setToCurrencyPickerIndex(with: index ?? 0)
        }).disposed(by: disposeBag)
        
        viewModel.fromCurencyValue.subscribe(onNext: { [weak self] value in
            self?.currencyFromValue.text = value
        }).disposed(by: disposeBag)
        
        viewModel.toCurencyValue.subscribe(onNext: { [weak self] value in
            self?.currencyToValue.text = value
        }).disposed(by: disposeBag)
        
        viewModel.ratesList.subscribe(onNext: { [weak self] value in
            if value.count > 0 {
                self?.setPickersView()
                self?.iniateTextFields()
                self?.setupIntialInputsValues()
            }
        }).disposed(by: disposeBag)
        
    }
    
    private func setPickersView() {
        fromCurrencyPicker.delegate = self
        fromCurrencyPicker.dataSource = self
        currencyFromTextField.inputView = fromCurrencyPicker

        toCurrencyPicker.delegate = self
        toCurrencyPicker.dataSource = self
        currencyToTextField.inputView = toCurrencyPicker
    }
    
    private func setupIntialInputsValues() {
        currencyFromValue.text = "\(1)"
        currencyToValue.text = "\(1)"
        self.viewModel.toCurrencyValue(value: currencyToValue.text ?? "")
        self.viewModel.fromCurrencyValue(value:  currencyFromValue.text ?? "")
    }
    
    private func iniateTextFields() {
        currencyFromTextField.text = viewModel.titleForRow(row: 0)
        currencyFromTextField.delegate = self
        currencyToTextField.text = viewModel.titleForRow(row: 0)
        currencyToTextField.delegate = self
        currencyToValue.delegate = self
        currencyFromValue.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)

    }
    
    func setFromCurrencyPickerIndex(with row: Int) {
        fromCurrencyPicker.selectRow(row, inComponent: 0, animated: true)
    }
    
    func setToCurrencyPickerIndex(with row: Int) {
        toCurrencyPicker.selectRow(row, inComponent: 0, animated: true)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        guard let text = textField.text else {return}
        viewModel.getConvertedAmount(amount: text) { value in
            self.currencyToValue.text = "\(value)"
        }
    }
    
    @IBAction func exchangeCurrency(_ sender: Any) {
        self.viewModel.switchCurancy(from: currencyFromValue.text ?? "", to: currencyToValue.text ?? "")
    }
    
    @IBAction func openDetails(_ sender: Any) {
        let vc = DetailsViewController(nibName: detailsViewName, bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.numberOfComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfRowsInComponent()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.titleForRow(row: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == toCurrencyPicker {
            viewModel.selectedToCurrencyIndex(index: row)
            self.currencyToTextField.text = self.viewModel.titleForRow(row: row)
            viewModel.getConvertedAmount(amount: nil) { value in
                self.currencyToValue.text = "\(value)"
            }
        } else {
            viewModel.selectedFromCurrencyIndex(index: row)
            self.currencyFromTextField.text = self.viewModel.titleForRow(row: row)
            viewModel.getConvertedAmount(amount: nil) { value in
                self.currencyToValue.text = "\(value)"
            }
        }
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
