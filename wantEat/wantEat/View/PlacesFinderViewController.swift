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
        print("")
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
