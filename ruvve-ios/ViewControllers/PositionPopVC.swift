//
//  PositionPopVC.swift
//  TMapSDKSample
//
//  Created by MINJU on 2021/08/12.
//  Copyright © 2021 TMap. All rights reserved.
//

import UIKit

class PositionPopVC: UIViewController {
    
    // 받을 값
    var positionData = ""
    
    @IBOutlet weak var positionSearch: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        positionSearch.text = positionData
        // Do any additional setup after loading the view.
    }
    
    //키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

          self.view.endEditing(true)

    }
//팝업닫기
    @IBAction func close(_ sender: Any) {
        
        if positionSearch.text != "" {
            
            //delegate.passdata(data: positionSearch.text)
            
        }

        
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
