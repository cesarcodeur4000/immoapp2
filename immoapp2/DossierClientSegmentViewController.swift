//
//  DossierClientSegmentViewController.swift
//  immoapp2
//
//  Created by etudiant on 17/10/17.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit

class DossierClientSegmentViewController: UIViewController, ScannerCustomDelegate {
    
    
    var bienImmoId = ""  //cle étrangere pointant vers le BI attaché au dossier
    var bienImmo : BienImmobilierDetailsImages?
    var images : [UIImage]?{
        
        didSet{
            dossierclientscanViewController.images = self.images
            dossierclientformulaireViewController.images = self.images
            
        }
        
    }
    var segmentedController: UISegmentedControl!
    private lazy var dossierclientscanViewController: DossierClientScanViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "scanClientVC") as! DossierClientScanViewController
        viewController.customDelegateForDataReturn = self
        viewController.images = self.images
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var dossierclientformulaireViewController: DossierClientFormulaireViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "formulaireClientVC") as! DossierClientFormulaireViewController
        viewController.images = self.images
        viewController.bienImmo = self.bienImmo
        viewController.customDelegateForDataReturn = self    
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        
        
        
        
    }
    func setupView() {
        setupSegmentedControl()
        
        updateView()
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupSegmentedControl() {
        // Configure Segmented Control
        segmentedController = UISegmentedControl()
        segmentedController.removeAllSegments()
       // let items = ["Label A", "Label B"]
        
        segmentedController.insertSegment(withTitle: "Formulaire", at: 0, animated: false)
        segmentedController.insertSegment(withTitle: "Scan", at: 1, animated: false)
        segmentedController.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
       // segmentedController = UISegmentedControl(items: items)
        navigationItem.titleView = segmentedController
        // Select First Segment
        segmentedController.sizeToFit()
        segmentedController.selectedSegmentIndex = 0
        segmentedController.backgroundColor = UIColor.black
        
    }

    func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    private func updateView() {
        if segmentedController.selectedSegmentIndex == 0 {
            remove(asChildViewController: dossierclientscanViewController)
            add(asChildViewController: dossierclientformulaireViewController)
        } else {
            remove(asChildViewController: dossierclientformulaireViewController)
            add(asChildViewController: dossierclientscanViewController)
        }
    }

    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func sendDataBackToViewController(listImages: [UIImage]?){
        
        self.images = listImages
    }
}
