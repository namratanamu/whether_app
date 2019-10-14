//
//  ViewController.swift
//  whether_map
//
//  Created by Felix 05 on 12/10/19.
//  Copyright © 2019 felix. All rights reserved.
//

import UIKit
import  MapKit
class ViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate   {

    
    
    var lat = Double()
    var long = Double()
    
let locationmanager = CLLocationManager()
    
   //https://api.openweathermap.org/data/2.5/weather?lat=19.076090&lon=72.877426&appid=d1f8d629f7379fee7a22af945d4eadff
    var newarray = [String]()
    enum JsonErrors:Error
    {
        case dataError
        case conversionError
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseJson()
        print(newarray)
        //self.tableview1.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    @IBOutlet weak var tableview1: UITableView!
    
    func parseJson()
    {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=19.076090&lon=72.877426&appid=d1f8d629f7379fee7a22af945d4eadff"
        let url:URL = URL(string: urlString)!
        let sessionconfiguration =  URLSessionConfiguration.default
        let session = URLSession(configuration: sessionconfiguration)
        
        let dataTask = session.dataTask(with:url){(data,response,error) in
            do{
                guard let data = data
                    else{
                        throw JsonErrors.dataError
                        
                }
                guard let Coord = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
                    
                    else{
                        throw JsonErrors.conversionError
                }
                
                let WArray = Coord["weather"] as! [[String:Any]]
                let WDisc = WArray.last!
                let Disc = WDisc["description"] as! String
                print(Disc)
                DispatchQueue.main.async {
                    self.descr.text = Disc
                }
                
                
                let main = Coord["main"] as! [String:Any]
                let tempn = main["temp"] as!  NSNumber
                let tem = Double(trunc(Double(tempn)))
                print(tempn)
                DispatchQueue.main.async {
                     self.temp.text = String(tem)
                }
              
                let humid = main["humidity"] as! NSNumber
                let hm = Double(trunc(Double(humid)))
                print(hm)
                DispatchQueue.main.async {
                     self.hum.text = String(hm)
                }
               
                let name1 = Coord["name"] as! String
                print(name1)
                DispatchQueue.main.async {
                      self.name.text = name1
                }
             
                
                    
                
               
            }
                
            catch JsonErrors.dataError
            {
                print("dataerror \(error?.localizedDescription)")
            }
            catch JsonErrors.conversionError{
                print("conversionerror \(error?.localizedDescription)")
            }
            catch let error
            {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
        
        
    }
    
    
    
    @IBOutlet weak var mapview: MKMapView!
    
    @IBAction func show(_ sender: UIButton) {
    
    
    
    
        func detectlocation()
        {
            locationmanager.desiredAccuracy = kCLLocationAccuracyBest
            locationmanager.delegate = self
            locationmanager.requestWhenInUseAuthorization()
            locationmanager.startUpdatingLocation()
        }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let currentlocation = locations.last!
            let latitude = currentlocation.coordinate.latitude
            let longitude = currentlocation.coordinate.longitude
            ("latitude = \(latitude) and longitude = \(longitude)")
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegionMake(currentlocation.coordinate, span)
            mapview.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = currentlocation.coordinate
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(currentlocation){(placemarks,error)in
                let placemark:CLPlacemark = (placemarks?.first)!
                let country = placemark.country
                annotation.title = country
                self.mapview.addAnnotation(annotation)
            }  }
    
    
    
    }
    
    
    
    
    @IBOutlet weak var des: UILabel!
    
    
    @IBOutlet weak var descr: UILabel!
    @IBOutlet weak var hum: UILabel!
    
    
    @IBOutlet weak var temp: UILabel!
    
    @IBOutlet weak var name: UILabel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

