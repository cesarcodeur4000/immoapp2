//
//  DossierCleintFormulaireViewController.swift
//  immoapp2
//
//  Created by etudiant on 17/10/17.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit
import RealmSwift

class DossierClientFormulaireViewController: UIViewController {
    
    @IBOutlet weak var formScrollView: UIScrollView!
    
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var addclientButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var firstnameTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    var bienImmoId = ""  //cle étrangere pointant vers le BI attaché au dossier
    var bienImmo : BienImmobilierDetailsImages?
    var images : [UIImage]?
    weak var customDelegateForDataReturn: ScannerCustomDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nameTextField.placeholder = "Nom"
        firstnameTextField.placeholder = "Prénom"
        phoneTextField.placeholder = "Numéro de téléphone"
        emailTextField.placeholder = "Email"
        
        bienImmoId = (bienImmo?.id)!
        // Do any additional setup after loading the view.
        //TEST
        // loadImageStringFromRealm()
        
        //scrollview auto -adjust
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        //self.formScrollView.scrollToTop()
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        formScrollView.layoutIfNeeded()
        formScrollView.contentSize = stackView.bounds.size
    }
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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

    
    
    @IBAction func addclientAction(_ sender: Any) {
        
        
        //verifier les champs du formulaire avant écriture
        
        let formulaire_correct = verification_formulaire()
        if formulaire_correct == true{
            
            ajouter_dossier()
        }
    }
        //ajouter enregistrement
        
    func  ajouter_dossier(){
        
        
        
    
        
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
            
            
            if let listeimages = self.images {
            for image in listeimages {
                
                // newdossiercli.imageData.append(uim.data())
                let imageImmo = ImageImmo()
                imageImmo.fkey_idDossierClient = dossierid
                imageImmo.image = image
                newdossiercli.listimage.append(imageImmo)
                
            }
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
        
        //effacer les champs du formulaire
        
        clearFormulaire()
        
    }
    
    
    func verification_formulaire()->Bool
    {
        //si le champ nom est non vide
        
        guard self.nameTextField.text != ""
            else{
                self.showMessage(title: "Erreur Formulaire", message: "Un nom doit être fourni")
                return false}
        //si l'email est valide
        
        guard self.emailTextField.text?.isValidEmail() == true
            else{
                 self.showMessage(title: "Erreur Formulaire", message: "Email Non Valide")
                return false}
        return true
    }
    
    
    //effacement des champs du formulaire apres enregistrement
    func clearFormulaire(){
        
        nameTextField.text = ""
        firstnameTextField.text = ""
        phoneTextField.text = ""
        emailTextField.text = ""
        //clear listeimages
        self.customDelegateForDataReturn?.sendDataBackToViewController(listImages: [])
        
    }
    
}
