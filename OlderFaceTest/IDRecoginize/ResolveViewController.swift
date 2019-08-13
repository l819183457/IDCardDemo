//
//  ResolveViewController.swift
//  OlderFaceTest
//
//  Created by 公平 on 2019/8/4.
//  Copyright © 2019 ppy. All rights reserved.
//

import UIKit

class ResolveViewController: UIViewController {

    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    
    var img = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        img1.image =  CardRecognizeManager.recognizeCard().resolveHuidu(with: img)
        img2.image = CardRecognizeManager.recognizeCard().resolveErzhihua(with: img1.image!)
        img3.image = CardRecognizeManager.recognizeCard().resolveFushi(with: img2.image!)

        
    }
    
}
