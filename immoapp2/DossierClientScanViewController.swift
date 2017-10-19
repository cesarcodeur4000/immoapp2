//
//  DossierClientScanViewController.swift
//  immoapp2
//
//  Created by etudiant on 17/10/17.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit


protocol ScannerCustomDelegate: class { //Setting up a Custom delegate for this class. I am using `class` here to make it weak.
    func sendDataBackToViewController(listImages: [UIImage]?) //This function will send the data back to origin viewcontroller.
}
class DossierClientScanViewController: UIViewController ,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIScrollViewDelegate{

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var scanButton: UIButton!
    
    
    var images : [UIImage]?{
        
        didSet{
            self.viewDidLayoutSubviews()
            //self.scrollView.populateScrollView(images: self.images!)
            print("TAB",self.images?.count ?? 0)
        }
    }
    var currentScanImage: UIImage?{
        willSet{
           
            
            //add image to local array
            if let newuim = newValue {
                
            self.images?.append(newuim)
            //envoyer nouvelle liste d'images par delegate
            self.customDelegateForDataReturn?.sendDataBackToViewController(listImages: self.images)
            //appendUIIMageToScrollView()
                     }
            
                   }
    }

    weak var customDelegateForDataReturn: ScannerCustomDelegate?
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

    
    @IBAction func scanAction(_ sender: Any) {
        
           prepareScan()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            
            return
        }
        
        currentScanImage = selectedImage
        self.dismiss(animated: true)
        
        //ADDED
        // currentScanImage = selectedImage
    }
    
    func prepareScan(){
        
        //reinit currentscanimage
        self.currentScanImage = nil
        
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
    func appendUIIMageToScrollView(){
        
        var  i = 0
        if let count = images?.count,count > 0 {
            i = count
        }
        let imageView = UIImageView()
        
        let x = self.scrollView.frame.size.width * CGFloat(i)
        imageView.frame = CGRect(x: x, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
        imageView.contentMode = .scaleAspectFill
        imageView.image = self.currentScanImage
        self.scrollView.contentSize.width = self.scrollView.frame.size.width * CGFloat(i + 1)
        self.scrollView.addSubview(imageView)
        self.scrollView.setContentOffset( CGPoint(x: self.scrollView.frame.size.width * CGFloat(i),y:0), animated: true)
        
        
    }
  
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //scrollView.setNeedsDisplay()
       
        if let listeimage = self.images {
       // appendUIIMageToScrollView()
        self.scrollView.populateScrollView(images: listeimage,mode: UIViewContentMode.scaleAspectFit)
        //scroll to last scan
        scrollView.scrollToRight(animation: true)
        }
    }
}
