//
//  MainVC.swift
//  ruvve-ios
//
//  Created by 박경선 on 2021/09/30.
//

import UIKit
import TMapSDK
//import CoreLocation

class MainVC: UIViewController, TMapViewDelegate {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    
//    @IBOutlet weak var searchButton: UIButton!
    //@IBOutlet var mapContainerView:UIView!
    //@IBOutlet var logLabel:UILabel!
    //@IBOutlet var menuConstraints:NSLayoutConstraint?
    //@IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var pt2View:UIView!

    var mapView:TMapView?

    //var leftArray:Array<LeftMenuData>?
    
    let mPosition: CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 37.570841, longitude: 126.985302)

    //var texts:Array<TMapText> = []
    //var markers:Array<TMapMarker> = []
    //var circles:Array<TMapCircle> = []
    //var rectangles:Array<TMapRectangle> = []
    //var polylines:Array<TMapPolyline> = []
    //var polygons:Array<TMapPolygon> = []
    
    //var isPublicTrasit = false
    //var isPublicTrasit2 = false
    //var ptMarkers:Array<TMapMarker> = []
    //var ptCircle:TMapCircle?
    
    let apiKey:String = "l7xxa70e1a4798de43cd969b92da7add4112"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        idTextField.layer.cornerRadius = 22
        passwordField.layer.cornerRadius = 22
        loginButton.layer.cornerRadius = 10
        
//        searchButton.layer.cornerRadius = 10
//
        //setting leftmenu
//        self.initTableViewData()
    }
    //키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

          self.view.endEditing(true)

    }
    
    //로그인 버튼 클릭
    @IBAction func Click_login(_ sender: Any) {
        print("로그인버튼 클릭")
        //로그인 정보 확인
        //idTextField.text = "ruvve"
        //passwordField.text = "1111"
        
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
