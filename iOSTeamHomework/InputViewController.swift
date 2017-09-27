//
//  InputViewController.swift
//  iOSTeamHomework
//
//  Created by Mike on 25/09/2017.
//  Copyright © 2017 gogolook. All rights reserved.
//

import UIKit

class InputViewController: UIViewController, UIGestureRecognizerDelegate, StoryboardInstantiable {
    
    static var storyboardName: String { return "Main" }
    static var storyboardIdentifier: String? { return "main_02" }
    
    @IBOutlet var vwBackground: UIView!
    @IBOutlet weak var ttfdCode: UITextField!
    @IBOutlet weak var ttfdNumber: UITextField!
    @IBOutlet weak var lblWarning: UILabel!
    
    private var callback: ((_ phoneNumber: PhoneNumbers) -> Bool)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addTapGestures()
    }
    
    public func setCallback(callback: @escaping (_ phoneNumber: PhoneNumbers) -> Bool) {
        self.callback = callback
    }
    
    private func addTapGestures() {
        let tapAct = UITapGestureRecognizer(target: self, action: #selector(InputViewController.tapAction(sender:)))
        self.vwBackground.addGestureRecognizer(tapAct)
        tapAct.delegate = self
    }
    
    private func showErrorMessage(msg: String) {
        self.lblWarning.isHidden = false
        self.lblWarning.text = msg
    }
    
    //MARK: - button action
    @IBAction func btnAddAct(_ sender: Any) {
        if let code = ttfdCode.text, let number = ttfdNumber.text,
            let iCode = Int(code), let iNumber = Int(number),
            let callback = self.callback {
            
            let phoneNumber = PhoneNumbers(code: iCode, number: iNumber)
            
            if !callback(phoneNumber) {
                self.showErrorMessage(msg: "The phone number is exists")
            } else {
                self.switchToPreviousPage()
            }
        } else {
            self.showErrorMessage(msg: "Input data format error!!")
        }
    }
    
    //MARK: - tap action
    private dynamic func tapAction(sender: UITapGestureRecognizer) {
        self.switchToPreviousPage()
    }
    
    //MARK: - switch page
    func switchToPreviousPage() {
        self.dismiss(animated: true, completion: nil)
    }
}
