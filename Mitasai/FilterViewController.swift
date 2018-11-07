//
//  FilterViewController.swift
//  Mitasai
//
//  Created by 勝良祥吾 on 2018/09/30.
//  Copyright © 2018年 shougo.katsura. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    weak var delegate: FilterViewControllerDelegate?
    
    static func fromStoryboard(delegate: FilterViewControllerDelegate? = nil) -> (navigationController: UINavigationController, filterController: FilterViewController) {
        let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterViewController") as! UINavigationController
        let controller = navigationController.viewControllers[0] as! FilterViewController
        controller.delegate = delegate
        return (navigationController: navigationController, filterController: controller)
        
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var categoryTextField: UITextField! {
        didSet {
            categoryTextField.inputView = categoryPickerView
        }
    }
    
    private lazy var categoryPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    @IBOutlet weak var placeTextField: UITextField! {
        didSet {
            placeTextField.inputView = placePickerView
        }
    }
    
    
    
    private lazy var placePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CancelButton(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func DoneButton(_ sender: Any) {
        delegate?.controller(self, category: categoryTextField.text, place: placeTextField.text, name: nameTextField.text)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func clearFilters() {
        categoryTextField.text = ""
        placeTextField.text = ""
        nameTextField.text = ""
    }
    
    private let placeOptions = ["中庭","南校舎","第一校舎","西校舎","ステージ","ミニステージ","演舞場","リング"]
    private let categoryOptions = ["食事","喫茶","講演会","演奏","パフォーマンス","展示","体験","ゼミ発表"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case placePickerView:
            return placeOptions.count
        case categoryPickerView:
            return categoryOptions.count
        case _:
            fatalError("Unhandled picker view: \(pickerView)")
        }
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent: Int) -> String? {
        switch pickerView {
        case placePickerView:
            return placeOptions[row]
        case categoryPickerView:
            return categoryOptions[row]
        case _:
            fatalError("Unhandled picker view: \(pickerView)")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case placePickerView:
            placeTextField.text = placeOptions[row]
        case categoryPickerView:
            categoryTextField.text = categoryOptions[row]
        case _:
            fatalError("Unhandled picker view: \(pickerView)")
        }
    }
    
}


protocol FilterViewControllerDelegate: NSObjectProtocol {
    
    func controller(_ controller: FilterViewController,
                    category: String?, place: String?,
                    name: String?)
}
