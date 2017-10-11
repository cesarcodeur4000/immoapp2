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
    
    
   
    
    //IBOUTLETS
    
    
    
    @IBOutlet weak var nomBI: UILabel!
    @IBOutlet weak var adresseBI: UILabel!
    
    @IBOutlet weak var descriptionBI: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    ////
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       populateScrollView()
       nomBI.text = bienImmo?.nom
       descriptionBI.text = bienImmo?.description_bi
        adresseBI.text = bienImmo?.adresse
        
        
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
    func populateScrollView(){
    
        var  i = 0
        if let bi = bienImmo{
          
            
            for image in bi.listimage{
        let imageView = UIImageView()
        
        let x = self.scrollView.frame.size.width * CGFloat(i)
        imageView.frame = CGRect(x: x, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image.image
        self.scrollView.contentSize.width = self.scrollView.frame.size.width * CGFloat(i + 1)
        self.scrollView.addSubview(imageView)
        self.scrollView.setContentOffset( CGPoint(x: self.scrollView.frame.size.width * CGFloat(i),y:0), animated: true)
        i = i + 1
            }
        //rewind scrollView
            scrollView.scrollToTop()
            
        
        }
     }
}
