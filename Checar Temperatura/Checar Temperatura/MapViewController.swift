//
//  ViewController.swift
//  Checar Temperatura
//
//  Created by Wanderson Hipolito on 13/10/20.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, TemperatureManagerDelegate {
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cidadeLabel: UILabel!
    @IBOutlet weak var temperaturaLabel: UILabel!
    @IBOutlet weak var viewTemp: UIView!
    
    

    private let locationManager = CLLocationManager()
    private let pinAnnotation = MKPointAnnotation()
    var temperaturaNetwork = TemperaturaNetwork()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        temperaturaNetwork.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // adicionando um gesture
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(mapLongPress(_:)))
        longPress.minimumPressDuration = 1.5
        
        mapView.addGestureRecognizer(longPress)

        
    }
    
    //MARK: - Bar button process
    @IBAction func InfoPressButton(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Como usar", message: "Você pode selecinar qualquer ponto do mapa para receber a temperatura do local, basta tocar e pressionar em algum lugar da tela", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Entendi", style: .cancel, handler: nil)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    //MARK: - MapView methods
    @objc func mapLongPress(_ recognizer: UIGestureRecognizer) {
        
        //print("Detectando pressionada")
        let touch = recognizer.location(in: mapView)
        let touchGetCoordinates : CLLocationCoordinate2D = mapView.convert(touch, toCoordinateFrom: mapView)
        print(touchGetCoordinates)
        pinAnnotation.coordinate = touchGetCoordinates
        temperaturaNetwork.fecthLocationRequest(latitude: pinAnnotation.coordinate.latitude, longitude: pinAnnotation.coordinate.longitude)
        mapView.addAnnotation(pinAnnotation)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.removeAnnotation(pinAnnotation)
        
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            print(location)
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
            temperaturaNetwork.fecthLocationRequest(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            mapView.setRegion(region, animated: true)
            pinAnnotation.coordinate = location.coordinate
            mapView.addAnnotation(pinAnnotation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    //MARK: - Temperature Delegate
    
    func didUpdateTemperature(_ teamperatureManager: TemperaturaNetwork, temperatureModel: TemperaturaModel) {
        DispatchQueue.main.async {
            self.cidadeLabel.text = temperatureModel.city
            self.temperaturaLabel.text = temperatureModel.temperaturaString
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
}


