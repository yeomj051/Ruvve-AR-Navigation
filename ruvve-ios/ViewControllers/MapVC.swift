//
//  MapVC.swift
//  TMapSDKSample
//
//  Created by MINJU on 2021/05/20.
//  Copyright © 2021 TMap. All rights reserved.
//

import UIKit
import TMapSDK
import CoreLocation

class MapVC: UIViewController, TMapViewDelegate, CLLocationManagerDelegate {
   
    
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var MyLocationButton: UIButton!
    @IBOutlet weak var searchText: UITextField!
    
    let locationManager = CLLocationManager()
    
    var mapView:TMapView?
    
    //api key
    let apiKey:String = "l7xxa70e1a4798de43cd969b92da7add4112"
    
    var markers:Array<TMapMarker> = []
    var polylines:Array<TMapPolyline> = []
    var circles:Array<TMapCircle> = []
    
    var center = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        searchText.layer.borderColor = UIColor.purple.cgColor
//        UIColor(named: "ruvve_purple")?.cgColor
        searchButton.layer.cornerRadius = 10
        
        MyLocationButton.layer.cornerRadius = 50
        MyLocationButton.layer.shadowColor = UIColor.darkGray.cgColor
        MyLocationButton.layer.shadowOpacity = 1.5
        MyLocationButton.layer.shadowRadius = 2
        MyLocationButton.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.mapView = TMapView(frame: mapContainerView.frame)
        self.mapView?.delegate = self
        self.mapView?.setApiKey(apiKey)
        
        mapContainerView.addSubview(self.mapView!)

    }
    //키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

          self.view.endEditing(true)

    }
    // 새로운 위치정보 발생시 실행되는 메소드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.mapView?.clear()
        
        let location = locations.last
        // 위치정보 반환
        center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        print("==== 내위치 : ", center)
        print("==== 지도 중심바꾸기 ====")
        self.mapView?.setCenter(center)
       
        self.mapView?.clear()

        let circle = TMapCircle(position: center, radius: 5)
       
        for circle in self.circles {
            print("==== 원 지우기 ====")
            circle.map = nil
        }
        
        circle.fillColor = .blue
        circle.strokeColor = .white
        circle.opacity = 0.8
        circle.strokeWidth = 5

        //print("precirecle : ", circle)
        
        circle.map = self.mapView
        //self.circles.append(circle)
        self.locationManager.stopUpdatingLocation()
        
        
    }

    // 위도경도 받아오기 에러
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("에러남",error)
    }
//    // 중심
//    func setCenter(_ location:CLLocationCoordinate2D){
//
//    }

    //검색 버튼 클릭

    @IBAction func Click_Search(_ sender: Any) {
        print("==== directvc 이동 ====")

        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "DirectVC")as? DirectVC {
            if searchText.text != nil {
                controller.paramData = searchText.text ?? "depart"
                controller.startPoint = center
                            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    func clearMarkers() {
        print("==== clearMarkers ====")
        for marker in self.markers {
            marker.map = nil
        }
        self.markers.removeAll()
    }

//    func clearPolylines() {
//        for polyline in self.polylines {
//            polyline.map = nil
//        }
//        self.polylines.removeAll()
//    }
    

    // 원 제거
//    public func objFunc13() {
//        print("==== 원 제거 ====")
//        for circle in self.circles {
//            circle.map = nil
//            print("circle",circles)
//        }
//        self.circles.removeAll()
//    }
//
    @IBAction func MyLocationFind(_ sender: Any) {
        
        print("==== MyLocation Click ====")
        searchText.text = "현위치"
        // 델리케이트 설정
        locationManager.delegate = self
        // 거리 정확도 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 사용자에게 혀용받기 알림창 띄우기
        locationManager.requestWhenInUseAuthorization()
        
        self.mapView?.clear()
        
        if CLLocationManager.locationServicesEnabled(){
            print("위치서비스 on 상태")
        
            locationManager.startUpdatingLocation()
            
        }else{
            print("위치서비스 off 상태")
        }
        
    }
 
}
