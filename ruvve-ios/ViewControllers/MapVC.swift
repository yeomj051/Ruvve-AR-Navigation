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
    
    let locationManager = CLLocationManager()
    
    var mapView:TMapView?
    
    //api key
    let apiKey:String = "l7xxa70e1a4798de43cd969b92da7add4112"
    
    var markers:Array<TMapMarker> = []
    var polylines:Array<TMapPolyline> = []
    var circles:Array<TMapCircle> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchButton.layer.cornerRadius = 10
        
        MyLocationButton.layer.cornerRadius = 50
        MyLocationButton.layer.shadowColor = UIColor.darkGray.cgColor
        MyLocationButton.layer.shadowOpacity = 1.5
        MyLocationButton.layer.shadowRadius = 2
        MyLocationButton.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        
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
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        print("-------------내위치 : ", center)
        print("-------------지도 중심바꾸기-------------")
        self.mapView?.setCenter(center)
        
        print("circle1",circles)
       
        self.mapView?.clear()
        
        //원제거
        //objFunc13()
        
        let circle = TMapCircle(position: center, radius: 5)
//        circle.map = nil // 객체 제거
        print("circle2",circles)
        
        
        
        for circle in self.circles {
            print("원 지욱")
            circle.map = nil
            print("circles : ",circle)
        }
        
        print("-------------circle---------------- : ",circle)
        
        circle.fillColor = .blue
        circle.strokeColor = .white
        circle.opacity = 0.8
        circle.strokeWidth = 5

        print("precirecle : ", circle)
        
        circle.map = self.mapView
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

    //검색 버튼 클릭

    @IBAction func Click_Search(_ sender: Any) {
        print("검색버튼 클릭")

        //objFunc57()
        
        //옵셔널 바인딩
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "DirectVC"){
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
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
        print("-------------원 제거-------------")
        for circle in self.circles {
            circle.map = nil
            print("circle",circles)
        }
        self.circles.removeAll()
    }
    
    @IBAction func MyLocationFind(_ sender: Any) {
        
        print("-------------MyLocation Click-------------")
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
