//
//  DossierClientViewController.swift
//  immoapp2
//
//  Created by etudiant on 9/10/17.
//  Copyright © 2017 etudiant. All rights reserved.
//
import Foundation
import UIKit
import RealmSwift

class DossierClientViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    
    //MARK:- IBOUTLETS
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var firstnameTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    //MARK:-LOCAL VARS
    var images : [UIImage]?
    var currentScanImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images = []
        scrollView.setNeedsDisplay()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
   
    @IBAction func addScan(_ sender: Any) {
    
       var  i = 0
        if let count = images?.count,count > 0 {
             i = count
        }
        let imageView = UIImageView()
        
        let x = self.scrollView.frame.size.width * CGFloat(i)
        imageView.frame = CGRect(x: x, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
        imageView.contentMode = .scaleAspectFit
      //  imageView.image = SCAN to last place images[i]
        prepareScan()
        
        
        DispatchQueue.main.async {
            
        if let currentimage = self.currentScanImage{
            
            //add image to local array
           self.images?.append(currentimage)
            //add image to scrollView
            imageView.image = self.currentScanImage
            self.scrollView.contentSize.width = self.scrollView.frame.size.width * CGFloat(i + 1)
            self.scrollView.addSubview(imageView)
           // self.scrollView.addSubview(UIView())
            //position scrollview to last added image
           // scrollView.scrollToBottom(animation: true)
            //reinitialize current image
           
          //  self.scrollView.scrollsToTop = true
            self.scrollView.setContentOffset( CGPoint(x: self.scrollView.frame.size.width * CGFloat(i),y:0), animated: true)
            self.currentScanImage = nil
            
        }
        
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            
            return
        }
        
        currentScanImage = selectedImage
        self.dismiss(animated: true)
    }
    
    func prepareScan(){
    
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        //pop-up
        let alertControl = UIAlertController()
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel){ (alertAction) in }
        
        alertControl.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            
            let cameraAction = UIAlertAction(title: "camera", style: .default, handler: { (_) in  imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)})
            alertControl.addAction(cameraAction)
            
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            
            let photoLibraryAction = UIAlertAction(title: "photo library", style: .default, handler: { (_) in  imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)})
            alertControl.addAction(photoLibraryAction)
            
        }
        present(alertControl, animated: true)
        //refresh(sender: self.refreshControl)
        
        

    }
    
    
    
    @IBAction func addClient(_ sender: Any) {
        
        
        let realm = try! Realm()
        
        try! realm.write() {
        
            let newdossiercli = DossierClient()
            
           newdossiercli.name = nameTextField.text!
            newdossiercli.firstname = firstnameTextField.text!
            
            let dossierid = newdossiercli.id
            
            for uim in self.images! {
                
               // newdossiercli.imageData.append(uim.data())
                let imageImmo = ImageImmo()
                imageImmo.fkey_idDossierClient = dossierid
                imageImmo.image = uim
               newdossiercli.listimage.append(imageImmo)
                
            }
            //newdossiercli.imageData = map(images)
            
        //    ({ (value: UIImage) -> Data? in
           //     return value.data()
           // })
            
         //   newdossiercli.imageData = images.map{ NSData(data: UIImageJPEGRepresentation($0[0],0.9))}
            realm.add(newdossiercli)
            
            
        }
        
        
    }
    
}
