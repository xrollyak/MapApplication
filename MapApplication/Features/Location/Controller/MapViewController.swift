//
//  MapViewController.swift
//  MapApplication
//
//  Created by Анастасия Корнеева on 15.04.21.
//

import MapKit
import  SnapKit

class MapViewController: ViewController {

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self


return mapView
    }()

    override func initController() {
        super.initController()

        self.controllerTitle = "Map"

        self.view.addSubview(mapView)
        self.mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.createAnnotsation()

        LocationManager.sh.getUserLocation(locationHandler: { [weak self] location in
            let annotation = MapAnnotation(title: "1",
                                           subtitle: "first",
                                           coordinate: location.coordinate)
            self?.mapView.addAnnotation(annotation)
            self?.mapView.setCenter(location.coordinate, animated: true)
        })
    }

    private func createAnnotsation() {
        let coordinste = CLLocationCoordinate2DMake(54.22222, 56.33333)

        let annotation = MapAnnotation(title: "Test",
                                       subtitle: "best place",
                                       coordinate: coordinste)
        self.mapView.addAnnotation(annotation)
        self.mapView.setCenter(coordinste, animated: false)
    }
}
extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        Swift.debugPrint(view.annotation?.coordinate)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MapAnnotation else { return nil }

//        var annotationView: MKPinAnnotationView

        var annotationView: MKMarkerAnnotationView

        if let dequeutView = mapView.dequeueReusableAnnotationView(withIdentifier: MapAnnotation.identifier) as? MKMarkerAnnotationView {
            annotationView = dequeutView
        } else {
            annotationView = MKMarkerAnnotationView(annotation: annotation,
                                                 reuseIdentifier: MapAnnotation.identifier)

            annotationView.glyphText = "Hi!"

            annotationView.glyphImage = UIImage(systemName: "heart")
            annotationView.glyphTintColor = UIColor.yellow

            annotationView.markerTintColor = UIColor.purple
            annotationView.selectedGlyphImage = UIImage(systemName: "heart.fill")
            annotationView.animatesWhenAdded = true

            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .infoLight)

            annotationView.calloutOffset = CGPoint(x: -5, y: -50)

            annotationView.subtitleVisibility = .visible

            
//            annotationView.pinTintColor = UIColor.blue
//            annotationView.animatesDrop = true
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
       let controller = WebController(stringUrl: "https://google.com",
                                      title: "web view")
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
