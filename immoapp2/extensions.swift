
//
//  extensions.swift
//  immoapp2
//
//  Created by etudiant on 9/10/17.
//  Copyright © 2017 etudiant. All rights reserved.
//

import Foundation
import UIKit
import MapKit


extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: characters.count)) != nil
    }
}
extension UIScrollView {
    func scrollToBottom(animation animated: Bool) {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
    func scrollToRight(animation animated: Bool) {
        if self.contentSize.width < self.bounds.size.width { return }
        let rightOffset = CGPoint(x: self.contentSize.width - self.bounds.size.width, y: 0)
        self.setContentOffset(rightOffset, animated: animated)
    }
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
    
    func populateScrollView(images: [UIImage], append append_bool :Bool = false,mode viewcontentmode:UIViewContentMode = .scaleAspectFill){
        
        var  i = 0
        var x = CGFloat(0)
        let count = self.subviews.count
        
        self.layoutIfNeeded()
        //si ce nest pas un simple append , on efface tout avant de remplir la ScrollView
        if append_bool == false { self.removeSubviews()}
        for image in images{
            
            let imageView = UIImageView()
            
            if append_bool == false { x = self.bounds.size.width * CGFloat(i)}
            
            else{ x = self.bounds.size.width * CGFloat(count) }
            
            imageView.frame = CGRect(x: x, y: 0, width: self.bounds.width, height: self.bounds.height)
            //imageView.contentMode = .scaleAspectFill
            imageView.contentMode = viewcontentmode
            imageView.clipsToBounds = true
            imageView.image = image
            
            self.addSubview(imageView)
            if append_bool == false {
                self.contentSize.width = self.bounds.size.width * CGFloat(i + 1)
            }
            else{
                
               // self.contentSize.width = self.contentSize.width + self.bounds.size.width
                self.contentSize.width = self.bounds.size.width * CGFloat(count + 1)
            }
            //self.contentSize.width = self.contentSize.width + self.bounds.size.width
            
            i = i + 1
        }
        
    }
    
}



extension UIImage {
    func resizeImage(_ image: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func data() -> Data {
        var imageData = UIImagePNGRepresentation(self)
        
        // Resize the image if it exceeds the 2MB API limit
        if (imageData?.count)! > 2097152 {
            let oldSize = self.size
            let newSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            let newImage = self.resizeImage(self, size: newSize)
            imageData = UIImageJPEGRepresentation(newImage, 0.7)
        }
        
        return imageData!
    }
    
    func base64EncodedString() -> String {
        let imageData = self.data()
        let stringData = imageData.base64EncodedString(options: .endLineWithCarriageReturn)
        return stringData
    }
}
extension UIViewController{
    
    func presentAlertDialog(withError error: Error){
        
        self.showMessage(title: "ERROR OCCURED", message: error.localizedDescription)
        
    }
    
     func showMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
 
}

extension UIView {
    
    // Recursive remove subviews and constraints
    func removeSubviews() {
        self.subviews.forEach({
            if !($0 is UILayoutSupport) {
                $0.removeSubviews()
                $0.removeFromSuperview()
            }
        })
        
    }
    
    // Recursive remove subviews and constraints
    func removeSubviewsAndConstraints() {
        self.subviews.forEach({
            $0.removeSubviewsAndConstraints()
            $0.removeConstraints($0.constraints)
            $0.removeFromSuperview()
        })
    }
    
}

class MKBienImmoPointAnnotation : MKPointAnnotation {
    var immoData:BienImmobilierDetailsImages?
    var imageName: String!
}
class MKBienImmoAnnotationView: MKAnnotationView {
    
    // Required for MKAnnotationView
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        guard let attractionAnnotation = self.annotation as? MKBienImmoPointAnnotation else { return }
        
        image = UIImage(named: "icons8-MapPin-64")
    }
    
}
extension MKMapView{
    func fitMapViewToAnnotationList() -> Void {
        let mapEdgePadding = UIEdgeInsets(top: 40, left: 20, bottom: 20, right: 20)
        var zoomRect:MKMapRect = MKMapRectNull
        
        for index in 0..<self.annotations.count {
            let annotation = self.annotations[index]
            let aPoint:MKMapPoint = MKMapPointForCoordinate(annotation.coordinate)
            let rect:MKMapRect = MKMapRectMake(aPoint.x, aPoint.y, 0.1, 0.1)
            
            if MKMapRectIsNull(zoomRect) {
                zoomRect = rect
            } else {
                zoomRect = MKMapRectUnion(zoomRect, rect)
            }
        }
        self.setVisibleMapRect(zoomRect, edgePadding: mapEdgePadding, animated: true)
    }
    func zoomMapaFitAnnotations() {
        
        var zoomRect = MKMapRectNull
        
        //usrloc
        
        
        let annotationPoint = MKMapPointForCoordinate(self.userLocation.coordinate);
        zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        
        //
        
        
        for annotation in self.annotations {
            
            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
            
            let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0)
            
            if (MKMapRectIsNull(zoomRect)) {
                zoomRect = pointRect
            } else {
                zoomRect = MKMapRectUnion(zoomRect, pointRect)
            }
        }
        self.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsetsMake(20, 20, 20, 20), animated: true)
        
    }
    func zoomToFitMapAnnotations() {
        guard self.annotations.count > 0 else {
            return
        }
        var topLeftCoord: CLLocationCoordinate2D = CLLocationCoordinate2D()
        topLeftCoord.latitude = -90
        topLeftCoord.longitude = 180
        var bottomRightCoord: CLLocationCoordinate2D = CLLocationCoordinate2D()
        bottomRightCoord.latitude = 90
        bottomRightCoord.longitude = -180
        for annotation: MKAnnotation in self.annotations as! [MKAnnotation]{
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude)
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude)
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude)
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude)
        }
        
        var region: MKCoordinateRegion = MKCoordinateRegion()
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.8
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1
        region = self.regionThatFits(region)
        self.setRegion(region, animated: true)
    }
        
        
    }

class TextField: UITextField {
    override var placeholder: String? {
        didSet {
            let placeholderString = NSAttributedString(string: placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.orange])
            self.attributedPlaceholder = placeholderString
        }
    }
}
