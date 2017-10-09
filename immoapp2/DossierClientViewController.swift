//
//  DossierClientViewController.swift
//  immoapp2
//
//  Created by etudiant on 9/10/17.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit

class DossierClientViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    var images = [UIImage]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images = []
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
    
    
        let i = images.count - 1
        let imageView = UIImageView()
        let x = self.view.frame.size.width * CGFloat(i)
        imageView.frame = CGRect(x: x, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        imageView.contentMode = .scaleAspectFit
      //  imageView.image = SCANimages[i]
        
        scrollView.contentSize.width = scrollView.frame.size.width * CGFloat(i + 1)
        scrollView.addSubview(imageView)
    }
    
    
}
