//
//  BasketViewController.swift
//  Sharelist
//
//  Created by Melina Osterloh on 19.06.23.
//

import UIKit
import Firebase

class BasketViewController: UIViewController {

    @IBOutlet weak var basketDescription: UITextField!
    @IBOutlet weak var basketPrice: UITextField!
    @IBOutlet weak var basketDate: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        basketDescription.layer.borderColor = UIColor.darkGray.cgColor
        basketDescription.layer.borderWidth = 1
        basketDescription.layer.cornerRadius = 5
        
        basketPrice.layer.borderColor = UIColor.darkGray.cgColor
        basketPrice.layer.borderWidth = 1
        basketPrice.layer.cornerRadius = 5
        
        basketDate.layer.borderColor = UIColor.darkGray.cgColor
        basketDate.layer.borderWidth = 1
        basketDate.layer.cornerRadius = 5
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        
        basketDate.inputView = datePicker
        basketDate.text = formatDate(date: Date())
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        basketDate.text = formatDate(date: datePicker.date)
    }
    
    func formatDate(date: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd.MMMM.yyyy"
        return dateFormat.string(from: date)
    }



}
