//
//  PlacesFinderViewController.swift
//  wantEat
//
//  Created by Marcio Henrique Nunes Abrantes on 21/08/22.
//

import UIKit
import MapKit

class PlacesFinderViewController: UIViewController {

    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
    @IBOutlet weak var viLoading: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            self.load(show: false)
            self.handlerPlacemark(placeMarks: placeMarks)
        }
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
