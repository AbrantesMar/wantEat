//
//  PlacesFinderViewController.swift
//  wantEat
//
//  Created by Marcio Henrique Nunes Abrantes on 21/08/22.
//

import UIKit
import MapKit

class PlacesFinderViewController: UIViewController {

    enum PlaceFinderMessageType {
        case error(String)
        case confirmation(String)
    }
    
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
    @IBOutlet weak var viLoading: UIView!
    
    var place: Place!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(getLocation(_:)))
        gesture.minimumPressDuration = 2.0
        mapView.addGestureRecognizer(gesture)

    }
    
    @objc func getLocation(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state != .began else {
            return
        }
        load(show: true)
        let point = gesture.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { [weak self] (placeMarks, error) in
            guard let self = self else {
                return
            }
            self.handlerLocation(placeMarks: placeMarks, error: error)
        })
    }
    
    func handlerLocation(placeMarks: [CLPlacemark]?, error: Error?) {
        self.load(show: false)
        if error != nil {
            self.showMessage(type: .error("Error desconhecido"))
            return
        }
        
        guard self.savePlace(with: placeMarks?.first) else {
            self.showMessage(type: .error("Não foi encontrado nenhum local com esse nome"))
            return
        }
        self.handlerPlacemark(placeMarks: placeMarks)
    }
    
    @IBAction func findCity(_ sender: Any) {
        tfCity.resignFirstResponder()
        let address = tfCity.text!
        load(show: true)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { [weak self] (placeMarks, error) in
            guard let self = self else {
                return
            }
            self.handlerLocation(placeMarks: placeMarks, error: error)
        }
    }
    
    func savePlace(with placemake: CLPlacemark?) -> Bool {
        guard let placemake = placemake, let coordinate = placemake.location?.coordinate else {
            return false
        }
        let name = placemake.name ?? placemake.country ?? "Desconhecido"
        let address = Place.getFormattedAddress(with: placemake)
        place = Place(name: name, latitude: coordinate.latitude, longitude: coordinate.longitude, address: address)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 3500, longitudinalMeters: 3500)
        mapView.setRegion(region, animated: true)
        self.showMessage(type: .confirmation(place.name))
        return true
    }
    
    func showMessage(type: PlaceFinderMessageType) {
        let title: String, message: String
        var hasConfirmation: Bool = false
        
        switch type {
            case .confirmation(let name):
                title = "Local encontrado"
                message = "Deseja adicionar \(name)?"
                hasConfirmation = true
            case .error(let errorMessage):
                title = "Error"
                message = errorMessage
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        if hasConfirmation {
            let confirmationAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                print("Ok")
            })
            alert.addAction(confirmationAction)
        }
        present(alert, animated: true, completion: nil)
    }
    
    func handlerPlacemark(placeMarks: [CLPlacemark]?) {
        guard let placeMark = placeMarks?.first else {
            return
        }
        print(Place.getFormattedAddress(with: placeMark))
    }
    
    func load(show: Bool) {
        viLoading.isHidden = !show
        guard show else {
            aiLoading.stopAnimating()
            return
        }
        
        aiLoading.startAnimating()
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
