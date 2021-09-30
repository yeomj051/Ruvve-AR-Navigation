//
//  DirectVC.swift
//  TMapSDKSample
//
//  Created by MINJU on 2021/06/17.
//  Copyright © 2021 TMap. All rights reserved.
//

import UIKit
import TMapSDK
import CoreLocation

class DirectVC: UIViewController, TMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var ChgButton: UIButton!
    @IBOutlet weak var DrivingButton: UIButton!
    @IBOutlet weak var MyLocationButton: UIButton!
    
    @IBOutlet weak var DepartureText: UITextField!
    @IBOutlet weak var DestinationText: UITextField!
    
    let locationManager = CLLocationManager()
    
    var mapView:TMapView?
    
    //api key
    let apiKey:String = "l7xxa70e1a4798de43cd969b92da7add4112"
    
    var markers:Array<TMapMarker> = []
    var polylines:Array<TMapPolyline> = []
    var circles:Array<TMapCircle> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //버튼디자인
        DrivingButton.layer.zPosition = 999
        MyLocationButton.layer.zPosition = 999
        MyLocationButton.layer.cornerRadius = 50
        MyLocationButton.layer.shadowColor = UIColor.darkGray.cgColor
        MyLocationButton.layer.shadowOpacity = 1.5
        MyLocationButton.layer.shadowRadius = 2
        MyLocationButton.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        
        DepartureText.delegate = self
        DestinationText.delegate = self
        
        self.mapView = TMapView(frame: mapContainerView.frame)
        self.mapView?.delegate = self
        self.mapView?.setApiKey(apiKey)
        mapContainerView.addSubview(self.mapView!)
        
//        // 델리케이트 설정
//        locationManager.delegate = self
//        // 거리 정확도 설정
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        // 사용자에게 혀용받기 알림창 띄우기
//        locationManager.requestWhenInUseAuthorization()
        
//        if CLLocationManager.locationServicesEnabled(){
//            print("위차서비스 on 상태")
//
//            locationManager.startUpdatingLocation()
//
//        }else{
//            print("위치서비스 off 상태")
//        }
       
    }
    //키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

          self.view.endEditing(true)

    }
    
    // 새로운 위치정보 발생시 실행되는 메소드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        // 위치정보 반환
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        print("내위치", center)
        print("원을 그리자")
        //objFunc11()
//        let circle = TMapCircle(position: center, radius: 50)
//        circle.fillColor = .cyan
//        circle.strokeColor = .black
//        circle.opacity = 0.5
//        circle.map = self.mapView
//        self.circles.append(circle)
        
        print("위치바꾸기")
        self.mapView?.setCenter(center)
       
        print("center",center)
        
        objFunc13()
        
        let circle = TMapCircle(position: center, radius: 5)
        circle.map = nil // 객체 제거
        circle.fillColor = .blue
        circle.strokeColor = .white
        circle.opacity = 0.8
        circle.strokeWidth = 5
        
        circle.map = self.mapView
        print("circle",circles)
        //self.circles.append(circle)
        self.locationManager.stopUpdatingLocation()
        
    }

    // 위도경도 받아오기 에러
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("에러남",error)
    }
    // 중심
    func setCenter(_ location:CLLocationCoordinate2D){
        
    }
    
    func clearMarkers() {
        print("clearMarkers")
        for marker in self.markers {
            marker.map = nil
        }
        self.markers.removeAll()
    }

    func clearPolylines() {
        for polyline in self.polylines {
            polyline.map = nil
        }
        self.polylines.removeAll()
    }
    
    // 경로찾기
    public func objFunc57() {
        print("경로찾기 시작")
        
        self.clearMarkers()
        self.clearPolylines()
        
        let pathData = TMapPathData()
        let startPoint = CLLocationCoordinate2D(latitude: 37.6511988, longitude: 127.0139717)
        let endPoint = CLLocationCoordinate2D(latitude: 37.6265967, longitude: 127.0342254)

        pathData.findPathData(startPoint: startPoint, endPoint: endPoint) { (result, error)->Void in
                    if let polyline = result {
                        DispatchQueue.main.async {
                            let marker1 = TMapMarker(position: startPoint)
                            marker1.map = self.mapView
                            marker1.title = "출발지"
                            self.markers.append(marker1)

                            let marker2 = TMapMarker(position: endPoint)
                            marker2.map = self.mapView
                            marker2.title = "목적지"
                            self.markers.append(marker2)

                            polyline.map = self.mapView
                            self.polylines.append(polyline)
                            self.mapView?.fitMapBoundsWithPolylines(self.polylines)
                        }
                    }
        }
    }
    // 원 제거
    public func objFunc13() {
        print("원 제거")
        for circle in self.circles {
            circle.map = nil
        }
        self.circles.removeAll()
    }
    
    @IBAction func ClickChg(_ sender: Any) {
        print("--------change 버튼 눌림--------------")
        let textDepart = DepartureText.text
        let textDest = DestinationText.text
        
        DepartureText.text = textDest
        DestinationText.text = textDepart
    }
    
    //return 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        DepartureText.resignFirstResponder()
        DestinationText.resignFirstResponder()
        return true
    }
    //내위치찾기
    @IBAction func MyLocationFind(_ sender: Any) {
        
        print("-------------MyLocation Click-------------")
        // 델리케이트 설정
        locationManager.delegate = self
        // 거리 정확도 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 사용자에게 혀용받기 알림창 띄우기
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            print("위치서비스 on 상태")
        
            locationManager.startUpdatingLocation()
            
        }else{
            print("위치서비스 off 상태")
        }
    }
//    @IBAction func SearchDepart(_ sender: Any) {
//        //옵셔널 바인딩
//        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "PositionListVC"){
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
//    }
    
    // 경로찾기 버튼
    @IBAction func SearchClick(_ sender: Any) {
        objFunc57()
    }
    // Driving
    @IBAction func DrivingClick(_ sender: Any) {
        print("----------Driving Click-----------")
//        //옵셔널 바인딩
//        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "PositionListVC"){
//            self.navigationController?.pushViewController(controller, animated: true)
//
//        }
    }
    @IBAction func SearchAddressClick(_ sender: Any) {
        
        //옵셔널 바인딩
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "PositionListVC"){
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }
    
    @available(iOS 13.0, *)
    @IBAction func DestinationClick(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "PositionPop", bundle: nil)
        
        let popup = storyboard.instantiateViewController(identifier: "PositionPop")
        
        // 팝업 크기 설정
        popup.modalPresentationStyle = .overCurrentContext
        
        let temp = popup as? PositionPopVC
        
        temp?.positionData = DestinationText.text ?? ""
        print("positionPopup Open!!!!")
        self.present( popup, animated: true, completion: nil)
    }
    
}

