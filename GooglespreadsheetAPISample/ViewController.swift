//
//  ViewController.swift
//  GooglespreadsheetAPISample
//
//  Created by nagata on 3/6/16.
//  Copyright © 2016 nagata. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var colorTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    let baseUrl = "https://sheetsu.com/apis/1c42f5fd"
    var routeData: JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameTextField.delegate = self
        colorTextField.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.setAPI()
        let tapGesture = UITapGestureRecognizer(target: self, action:"tapGesture")
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func tapGesture() {
        nameTextField.resignFirstResponder()
        colorTextField.resignFirstResponder()
    }
    
    func setAPI() {
        
        Alamofire.request(.GET, baseUrl).responseJSON { response in
            guard let _ = response.result.value else {
                return
            }
            self.routeData = JSON(response.result.value!)
            print(self.routeData!)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func add() {
        if nameTextField.text == "" {
            return
        }
        if colorTextField.text == "" {
            return
        }
        
        let params = ["route":nameTextField.text!, "color":colorTextField.text!]
         Alamofire.request(.POST, baseUrl, parameters: params)
        self.setAPI()
        
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        let nameLabel: UILabel = cell.viewWithTag(1) as! UILabel
        let colorLabel: UILabel = cell.viewWithTag(2) as! UILabel
        nameLabel.text = routeData!["result"][indexPath.row]["route"].string
        colorLabel.text = routeData!["result"][indexPath.row]["color"].string
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeData?["result"].count ?? 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

