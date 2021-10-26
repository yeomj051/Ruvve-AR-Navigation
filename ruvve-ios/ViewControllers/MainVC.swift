//
//  MainVC.swift
//  ruvve-ios
//
//  Created by 박경선 on 2021/09/30.
//

import UIKit
//import CoreLocation

class MainVC: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet var loginButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        idTextField.layer.cornerRadius = 22
        passwordField.layer.cornerRadius = 22
        idTextField.layer.borderColor = UIColor(named: "ruvve_purple")?.cgColor
        passwordField.layer.borderColor = UIColor(named: "ruvve_purple")?.cgColor
//        loginButton.layer.cornerRadius = 14
    }
    //키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

          self.view.endEditing(true)

    }
    
    //로그인 버튼 클릭
    @IBAction func Click_login(_ sender: Any) {
        print("로그인버튼 클릭")
        
        //로그인 정보 확인
//        idTextField.text = "ruvve"
//        passwordField.text = "1111"
        
        if(idTextField.text != "ruvve" || passwordField.text != "1111"){
            let alert = UIAlertController(title: nil, message: "아이디/비밀번호를 확인해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        //옵셔널 바인딩
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "MapVC"){
            print("------옵셔널바인딩")
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
