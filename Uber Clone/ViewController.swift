//
//  ViewController.swift
//  Uber Clone
//
//  Created by Akhil Waghmare on 1/5/17.
//  Copyright © 2017 AW Labs. All rights reserved.
//

import UIKit
import MapKit
import LBTAComponents

class ViewController: UIViewController, MKMapViewDelegate {
    
    var locationFound: Bool = false
    
    let navButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "menu"), for: .normal)
        button.addTarget(self, action: #selector(launchSideNav), for: .touchUpInside)
        return button
    }()
    
    let sideNavLauncher = SideNavLauncher()
    
    func launchSideNav() {
        sideNavLauncher.showNav()
    }
    
    let mapColor: UIColor = UIColor(r: 249, g: 245, b: 237)
    
    lazy var mainMap: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.showsPointsOfInterest = false
        map.delegate = self
        map.alpha = 0
        return map
    }()
    
    let mapPlaceholder: UIView = {
        let view = UIView()
        return view
    }()
    
    let searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    //views inside searchView
    let blackSquare: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let whereToField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Where to?"
        return tf
    }()
    
    let verticalDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let scheduleImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "car")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = .white
        
        requestLocationAccess()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //searchView shadow
        applyHoverShadow(view: searchView)
    }
    
    func setupViews() {
        view.addSubview(mapPlaceholder)
        view.addSubview(mainMap)
        view.addSubview(navButton)
        view.addSubview(searchView)
        
        mapPlaceholder.backgroundColor = mapColor
        
        mapPlaceholder.anchor(mainMap.topAnchor, left: mainMap.leftAnchor, bottom: mainMap.bottomAnchor, right: mainMap.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        mainMap.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        navButton.anchor(mainMap.topAnchor, left: mainMap.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24)
        
        searchView.anchor(navButton.bottomAnchor, left: mainMap.leftAnchor, bottom: nil, right: mainMap.rightAnchor, topConstant: 48, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 50)
        
        
        //arrange views inside searchView
        searchView.addSubview(blackSquare)
        searchView.addSubview(whereToField)
        searchView.addSubview(verticalDivider)
        searchView.addSubview(scheduleImage)
        
        blackSquare.anchor(nil, left: searchView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 6, heightConstant: 6)
        blackSquare.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        
        scheduleImage.anchor(nil, left: nil, bottom: nil, right: searchView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 16, widthConstant: 24, heightConstant: 24)
        scheduleImage.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        
        verticalDivider.anchor(searchView.topAnchor, left: nil, bottom: searchView.bottomAnchor, right: scheduleImage.leftAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 12, rightConstant: 16, widthConstant: 1, heightConstant: 0)
        
        whereToField.anchor(searchView.topAnchor, left: blackSquare.rightAnchor, bottom: searchView.bottomAnchor, right: verticalDivider.leftAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 8, rightConstant: 16, widthConstant: 0, heightConstant: 0)
    }
    
    func applyHoverShadow(view: UIView) {
        let width = view.bounds.width
        let height = view.bounds.height
        
        let ovalRect = CGRect(x: 0, y: height, width: width, height: 5)
        let path = UIBezierPath(roundedRect: ovalRect, cornerRadius: 10)
        
        let layer = view.layer
        layer.shadowPath = path.cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if(!locationFound) {
            let latDelta: CLLocationDegrees = 0.005
            let longDelta: CLLocationDegrees = 0.005
            let span = MKCoordinateSpanMake(latDelta, longDelta)
            let region = MKCoordinateRegionMake(userLocation.coordinate, span)
            mapView.setRegion(region, animated: false)
            locationFound = true
        }
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        if(locationFound) {
            if(mapView.alpha == 0) {
                UIView.animate(withDuration: 0.5) {
                    mapView.alpha = 1
                }
            }
        }
    }
    
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
        case .denied, .restricted:
            print("Location Access Denied")
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }

}

