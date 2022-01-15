import UIKit
import MapKit

class MapViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    //MARK: - Vars
    var addressesArray = [PeopleList]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        // Do any additional setup after loading the view.
    }
    //MARK: - Flow funcs

    private func configure(){
        for address in addressesArray {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: address.latitude, longitude: address.longitude)
            annotation.title = address.name
            mapView.addAnnotation(annotation)
        }
        if mapView.annotations.count > 0{
            let region = MKCoordinateRegion(center: mapView.annotations[0].coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
}
//MARK: - IBActions
extension MapViewController {
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
}
