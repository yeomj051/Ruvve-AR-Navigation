//
//  PositionListVC.swift
//  TMapSDKSample
//
//  Created by MINJU on 2021/06/21.
//  Copyright © 2021 TMap. All rights reserved.
//

import UIKit

class PositionListVC: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var AddressList: UITableView!
    @IBOutlet weak var SearchText: UITextField!
    
    let address = ["수유역 (강북구청) 4호선",
                    "덕성여자대학교",
                    "강북구 삼양로 111길 11 하이빌 101"]
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        SearchText.delegate = self
        AddressList.delegate = self
        AddressList.dataSource = self
        
    }
    
    //return 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SearchText.resignFirstResponder()
        return true
    }
    @IBAction func BackButton(_ sender: Any) {
        //옵셔널 바인딩
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "DirectVC"){
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }
}

extension PositionListVC : UITableViewDelegate{
    func AddressList(_ AddressList: UITableView, didSelectRowAt indexPath : IndexPath){
        print("tap")
    }
}

extension PositionListVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return address.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AddressList.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = address[indexPath.row]
        
        return cell
    }
    
}
