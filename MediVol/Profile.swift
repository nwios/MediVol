//
//  Profile.swift
//  MediVol
//
//  Created by Nawaf Aldosari on 02/08/2018.
//  Copyright © 2018 Nawaf Aldosari. All rights reserved.
//

import UIKit
import FirebaseDatabase

enum GradientDirectione {
    case leftToRight
    case rightToLeft
    case topToBottom
    case bottomToTop
}

class Profile: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var loginBTN: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientBackground(from: UIColor(named: "Blue")!, to: UIColor(named: "Sky")!, direction: .rightToLeft)
        self.image.layer.cornerRadius = self.image.frame.width / 2
        self.image.layer.masksToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        UIApplication.shared.isStatusBarHidden = false
        createGradientLayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func gradientBackground(from color1: UIColor, to color2: UIColor, direction: GradientDirectione) {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [color1.cgColor,color2.cgColor]
        
        switch direction {
        case .topToBottom:
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        case .leftToRight:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightToLeft:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .bottomToTop:
            gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        }
        
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func createGradientLayer() {
        
        let color1 = UIColor(named: "Blue")!
        
        let color2 = UIColor(named: "Sky")!
        
        let gradient = CAGradientLayer()
        
        gradient.colors = [ color1.cgColor, color2.cgColor]
        
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        
        gradient.frame = CGRect(x:0, y:-50, width:view.frame.width, height:95)
        
        self.navigationController?.navigationBar.layer.sublayers?.insert(gradient, at: Int(1))
    }


}
