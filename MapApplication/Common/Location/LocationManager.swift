//
//  LocationManager.swift
//  MapApplication
//
//  Created by Nadya Khrol on 15.04.2021.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
// MARK: - variables
    typealias  listenerhandler = (CLLocation) -> Void
    
    static let sh = LocationManager()

    private lazy var  locationManager: CLLocationManager = {
        let nanager = CLLocationManager()
        nanager.delegate = self
        nanager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        return nanager
    }()

    var lastUserLocation: CLLocation? {
        didSet {
            self.sendLocationToListeners()
        }
    }

    private var locationLister: [listenerhandler] = []


    private override init(){
        super.init()

        self.locationManager.requestWhenInUseAuthorization()
    }

    func getUserLocation(locationHandler: @escaping listenerhandler) {
        switch self.locationManager.authorizationStatus {
//        case .notDetermined:
//            self.locationLister.append(listenerhandler)
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.requestLocation()
        default:
            locationHandler(CLLocation())
        }
    }

    private func sendLocationToListeners() {
        for location in self.locationLister {
            location(self.lastUserLocation ?? CLLocation())
        }
        self.locationLister = []
    }

}
extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Swift.debugPrint(manager.authorizationStatus)

        if (manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse),
           !self.locationLister.isEmpty {

            self.locationManager.requestLocation()
        } else if manager.authorizationStatus == .denied{
            self.sendLocationToListeners()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location  = locations.first {
            self.lastUserLocation = location
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Swift.debugPrint(error.localizedDescription)
        self.sendLocationToListeners()
    }
}
