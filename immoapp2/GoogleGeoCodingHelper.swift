//
//  GoogleGeoCodingHelper.swift
//  immoapp2
//
//  Created by etudiant on 18/10/17.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI
import Foundation

class GoogleGeoCodingHelper: NSObject {
    
    static let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    static  let apikey = "AIzaSyBMzTPTot6PZ-3NAymKIaWVO33M71uqCro"
    
    static func getLatLngForZip(zipCode: String) {
        let url = NSURL(string: "\(baseUrl)address=\(zipCode)&key=\(apikey)")
        let data = NSData(contentsOf: url! as URL)
        let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        if let result = json["results"] as? [[String: Any]] {
            if let geometry = result[0]["geometry"] as? NSDictionary {
                if let location = geometry["location"] as? NSDictionary {
                    let latitude = location["lat"] as! Float
                    let longitude = location["lng"] as! Float
                    print("\n\(latitude), \(longitude)")
                }
            }
        }
    }
   static  func getAddressForLatLng(latitude: String, longitude: String) {
        let url = NSURL(string: "\(baseUrl)latlng=\(latitude),\(longitude)&key=\(apikey)")
        let data = NSData(contentsOf: url! as URL)
        let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        if let result = json["results"] as? [[String: Any]] {
            if let address = result[0]["address_components"] as? [[String: Any]] {
                let number = address[0]["short_name"] as! String
                let street = address[1]["short_name"] as! String
                let city = address[2]["short_name"] as! String
                let state = address[4]["short_name"] as! String
                let zip = address[6]["short_name"] as! String
                print("\nGOOGLE\(number) \(street), \(city), \(state) \(zip)")
            }
        }
    }
    static func reverseGeocodingAppleMap(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print(error!)
                return
            }
            else if (placemarks?.count)! > 0 {
                let pm = placemarks![0]
                let address = ABCreateStringWithAddressDictionary(pm.addressDictionary!, false)
                print("\n\(address)")
                if (pm.areasOfInterest?.count)! > 0 {
                    let areaOfInterest = pm.areasOfInterest?[0]
                    print(areaOfInterest!)
                } else {
                    print("No area of interest found.")
                }
            }
        })
    }

    
  static  func performGoogleSearch(latitude: String,longitude: String,completionHandler: @escaping (_ adresse: String) -> ()) {
        //var strings: [String] = []
        
        print("GOOGLE1")
        var components = URLComponents(string: baseUrl)!
        let key = URLQueryItem(name: "key", value: apikey) // use your key
        //let address = URLQueryItem(name: "address", value: string)
        let latlng = URLQueryItem(name: "latlng", value: "\(latitude),\(longitude)")
        components.queryItems = [latlng,key]
        print("GOOGLE",components.url?.absoluteString ?? "GOOGLE NOT GOOD")
        let task = URLSession.shared.dataTask(with: components.url!) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, error == nil else {
                print(String(describing: response))
                print(String(describing: error))
                return
            }
            
            guard let json = try! JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("not JSON format expected")
                print(String(data: data, encoding: .utf8) ?? "Not string?!?")
                return
            }
            
            guard let results = json["results"] as? [[String: Any]],
                let status = json["status"] as? String,
                status == "OK" else {
                    print("no results")
                    print(String(describing: json))
                    return
            }
            
            DispatchQueue.main.async {
                // now do something with the results, e.g. grab `formatted_address`:
                let strings = results.flatMap { $0["formatted_address"] as? String }
                print("GOOGLE",strings)
                completionHandler(strings[0])
            }
        }
        
        task.resume()
    }
}
