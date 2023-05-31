//
//  HomeViewController.swift
//  Currency
//
//  Created by gamal oraby on 30/05/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var currencyFromTextField: UITextField!
    @IBOutlet weak var currencyToTextField: UITextField!
    @IBOutlet weak var currencyFromValue: UITextField!
    @IBOutlet weak var currencyToValue: UITextField!

    private var fromCurrencyPicker = UIPickerView()
    private var toCurrencyPicker =  UIPickerView()
    
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getCurrencyCodes()
        setPickersView()
        iniateTextFields()
        setupIntialInputsValues()
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
    
    @objc func textFieldDidChange(textField: UITextField) {
        guard let text = textField.text else {return}
        viewModel.getConvertedAmount(amount: text) { value in
            self.currencyToValue.text = "\(value)"
        }
    }
    
    @IBAction func exchangeCurrency(_ sender: Any) {
        
        self.viewModel.toCurrencyValue(value: currencyToValue.text ?? "")
        self.viewModel.fromCurrencyValue(value:  currencyFromValue.text ?? "")
        viewModel.exchangeCodes { [weak self] (toIndex, fromIndex) in
            self?.viewModel.selectedToCurrencyIndex(index: toIndex)
            self?.viewModel.selectedFromCurrencyIndex(index: fromIndex)
            self?.currencyFromTextField.text = self?.viewModel.titleForRow(row: fromIndex)
            self?.currencyToTextField.text = self?.viewModel.titleForRow(row: toIndex)
        }
        viewModel.exchangeValues { [weak self] (toValue, fromValue) in
            self?.currencyToValue.text = toValue
            self?.currencyFromValue.text = fromValue
        }
    }
    
    @IBAction func openDetails(_ sender: Any) {
        print("pressed")
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
