//
//  DetailBienImmoWithPicsViewController.swift
//  immoapp2
//
//  Created by etudiant on 10/10/17.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit
import RealmSwift

class DetailBienImmoWithPicsViewController: UIViewController {

    
    var bienImmo : BienImmobilierDetailsImages?
    var idBienImmo = ""
    
   
    
    //IBOUTLETS
    
    
    
    @IBOutlet weak var nomBI: UILabel!
    @IBOutlet weak var adresseBI: UILabel!
    
    @IBOutlet weak var descriptionBI: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    ////
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        
        //recuperer id BI
        self.idBienImmo = (bienImmo?.id)!
        //recuperer data BI
       nomBI.text = bienImmo?.nom
       descriptionBI.text = bienImmo?.description_bi
        adresseBI.text = bienImmo?.adresse
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let images = bienImmo?.listimage.map({ (imageImo) -> UIImage in
            return imageImo.image
        }) ?? []
        self.scrollView.populateScrollView(images: images)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

//MARK:- IBACTION
    
    
    @IBAction func btnDossierClient(_ sender: Any) {
        
        performSegue(withIdentifier: "SegueToDossierClient", sender: self)
        
    }

    //preapre segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueToDossierClient" {
            let destinationViewController = segue.destination as! DossierClientSegmentViewController //DossierClientViewController
            destinationViewController.bienImmo = self.bienImmo
            
        }
        
    }

}
