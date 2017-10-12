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
    @IBOutlet weak var formScrollView: UIScrollView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var firstnameTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    //MARK:-LOCAL VARS
    var bienImmoId = ""  //cle étrangere pointant vers le BI attaché au dossier
    var bienImmo : BienImmobilierDetailsImages?
    var images : [UIImage]?{
        
       didSet{
        self.viewDidLayoutSubviews()
        //self.scrollView.populateScrollView(images: self.images!)
        print("TAB",self.images?.count ?? 0)
        }
    }
    var currentScanImage: UIImage?{
        willSet{
           // self.imageView.image = self.currentScanImage
            
            //add image to local array
            if let newuim = newValue {self.images?.append(newuim)}
            
            //add image to scrollView
            
      //      self.scrollView.contentSize.width = self.scrollView.frame.size.width * CGFloat(i + 1)
       //     self.scrollView.addSubview(imageView)
            // self.scrollView.addSubview(UIView())
            //position scrollview to last added image
            // scrollView.scrollToBottom(animation: true)
            //reinitialize current image
            
            //  self.scrollView.scrollsToTop = true
     //       self.scrollView.setContentOffset( CGPoint(x: self.scrollView.frame.size.width * CGFloat(i),y:0), animated: true)
            //appendUIIMageToScrollView()
            //self.scrollView.populateScrollView(images: [self.currentScanImage!], append: true)
           // self.scrollView.populateScrollView(images: self.images!)
          //  self.viewDidLayoutSubviews()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bienImmoId = (bienImmo?.id)!
        images = []
        scrollView.setNeedsDisplay()
        
        // Do any additional setup after loading the view.
        //TEST
        // loadImageStringFromRealm()
        
        //scrollview auto -adjust
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
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
   
    @IBAction func addScan(_ sender: Any) {
    
       var  i = 0
        if let count = images?.count,count > 0 {
             i = count
        }
        let imageView = UIImageView()
        
        let x = self.scrollView.frame.size.width * CGFloat(i)
        imageView.frame = CGRect(x: x, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
        imageView.contentMode = .scaleAspectFit
      //imageView.image = SCAN to last place images[i]
        prepareScan()
        
        
//        DispatchQueue.main.async {
            
//        if let currentimage = self.currentScanImage{
            
            //add image to local array
 //          self.images?.append(currentimage)
 //            print("TAB",self.images?.count ?? 0)
            //add image to scrollView
            
 //           imageView.image = currentimage
       
            
            //**     self.scrollView.contentSize.width = self.scrollView.frame.size.width * CGFloat(i + 1)
        //**    self.scrollView.addSubview(imageView)
           // self.scrollView.addSubview(UIView())
            //position scrollview to last added image
           // scrollView.scrollToBottom(animation: true)
            //reinitialize current image
       
          //  self.scrollView.scrollsToTop = true
         //**   self.scrollView.setContentOffset( CGPoint(x: self.scrollView.frame.size.width * CGFloat(i),y:0), animated: true)
           // self.currentScanImage = nil
            
            
            
//            self.viewDidLayoutSubviews()
            
            
            //self.scrollView.populateScrollView(images: [self.currentScanImage!], append: true)
   //     }
        
   //     }
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
    
    
    
    @IBAction func addClient(_ sender: Any) {
        
        
        let realm = try! Realm()
        
        try! realm.write() {
        
            let newdossiercli = DossierClientDetail()
            
           newdossiercli.nom = nameTextField.text!
           newdossiercli.prenom = firstnameTextField.text!
           newdossiercli.bienimmobilier = self.bienImmo
           newdossiercli.fk_BienImmo = bienImmo?.id
           newdossiercli.email = emailTextField.text!
           newdossiercli.telephone = phoneTextField.text!
            
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
        //envoyer message ok
        
        self.showMessage(title: "DOSSIER CLIENT", message: "Dossier créé avec succès")
        
        
    }
 
    
    @IBAction func addImmo(_ sender: Any) {
        
        let realm = try! Realm()
        
        try! realm.write() {
            
            let newbim = BienImmobilierWithPics()
            
            newbim.name = nameTextField.text!
           // newdossiercli.firstname = firstnameTextField.text!
            
            let bimid = newbim.id
            
            for uim in self.images! {
                
                // newdossiercli.imageData.append(uim.data())
                let imageImmo = ImageImmo()
                imageImmo.fkey_idDossierClient = bimid
                imageImmo.image = uim
                newbim.listimage.append(imageImmo)
                
            }
            //newdossiercli.imageData = map(images)
            
            //    ({ (value: UIImage) -> Data? in
            //     return value.data()
            // })
            
            //   newdossiercli.imageData = images.map{ NSData(data: UIImageJPEGRepresentation($0[0],0.9))}
            realm.add(newbim)
            //reset list of pics
            self.images = []
            self.scrollView.removeSubviews()
        }
        
 
        
        
    }
    
    
    @IBAction func loadimmodetails2(_ sender: Any) {
        
        
        let realm = try! Realm()
        
        let bims: Results<BienImmobilierWithPics> = { realm.objects(BienImmobilierWithPics.self) }()
        
        try! realm.write() {

            for bimpc in bims{
                
                var newbid = BienImmobilierDetailsImages()
                newbid.nom = bimpc.name
                newbid.longitude = bimpc.longitude
                newbid.latitude = bimpc.latitude
                newbid.listimage = bimpc.listimage
                realm.add(newbid)
                
                
                
            }
        
        
        }
        
        
    }
    
    
    //TESTload first image from realm
    func loadImageStringFromRealm(){
        
     
        //retrienve image from REalm
        let realm = try! Realm()
        
        let bims: Results<ImageImmo> = { realm.objects(ImageImmo.self) }()
        
        currentScanImage = bims.first?.image

        
    
    }
  
    //AUTO SCROLL
    func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.formScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.formScrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.formScrollView.contentInset = contentInset
    }
    //VIEWDIDLOAD
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //scrollView.setNeedsDisplay()
        self.scrollView.populateScrollView(images: images!,mode: UIViewContentMode.scaleAspectFit)
       //go to last scan
        scrollView.scrollToRight(animation: true)
    }
}
