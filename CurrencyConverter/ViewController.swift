//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Ram Kumar on 17/09/21.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    @IBOutlet weak var currencyValueTF: UITextField!
    @IBOutlet weak var convertedValueLabel: UILabel!
    @IBOutlet weak var currencyNamePV: UIPickerView!
    @IBOutlet weak var selectedCurrencyLabel: UILabel!
    @IBOutlet weak var backGroundIV: UIImageView!
    @IBOutlet weak var convertBTN: UIButton!
    
    var currencyCode : [String] = []
    var currencyValue : [Double] = []
    var activeCurrency = 0.0
    var sortedCurrencyCode : [String] = []
    
    struct exchangeRates : Codable {
        var rates : [String:Double]
    }
    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchJSON()
        currencyNamePV.delegate = self
        currencyNamePV.dataSource = self
        backGroundIV.layer.cornerRadius = 10
        currencyNamePV.setValue(UIColor.white, forKey: "textColor")
        }
        
// MARK: - pickerView

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        currencyCode.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        currencyCode[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeCurrency = currencyValue[row]
        selectedCurrencyLabel.text = String(currencyCode[row])
    }
    
    // MARK: - convertBTN
    @IBAction func convertBTN(_ sender: Any) {
        //Convert Currency
        guard let enteredAmount = currencyValueTF.text, let receivedAmount = Double(enteredAmount) else { return}
        if currencyValueTF.text != nil {
        let total = receivedAmount * activeCurrency
        convertedValueLabel.text = String(format: "%.2f", total)
        }
    }

    // MARK: - fetchJSON
    func fetchJSON() {
        //URL
        guard let url = URL(string: "https://open.er-api.com/v6/latest/USD") else {return}
        //Create the data Task
        URLSession.shared.dataTask(with: url) { data, response, error in
            //Check for Errors
            if error != nil{
                print(error!)
                return
            }
            //Try to Parse out the data
            guard let currencyData = data else {return}
            do{
                let savedData = try JSONDecoder().decode(exchangeRates.self, from: currencyData)
                self.currencyCode.append(contentsOf: savedData.rates.keys)
                self.currencyValue.append(contentsOf: savedData.rates.values)
                DispatchQueue.main.async {
                    self.currencyNamePV.reloadAllComponents()
                }
            }catch{
                print(error)
            }
            //Fire off the data task
        }.resume()
    }
}

