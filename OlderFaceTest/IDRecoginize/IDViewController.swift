//
//  IDViewController.swift
//  OlderFaceTest
//
//  Created by 公平 on 2019/7/25.
//  Copyright © 2019 ppy. All rights reserved.
//

import UIKit
enum IDShowType {
    case result
    case resolve
}


class IDViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var showType:IDShowType?

    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
   
    @IBOutlet weak var resolveAction: UIButton!
    var pickImage = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resolveAction(_ sender: Any) {
//        performSegue(withIdentifier: "resSegue", sender: self)
        
    }
    
    
    //定义prepare segue destination到下一个界面赋值变量
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resSegue" {
            //key code ！！！
            let contactVC = segue.destination as! ResolveViewController
            contactVC.img = imageView.image!
        }
    }
   
    
    
    @IBAction func photoAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let  cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = .camera
            //在需要的地方present出来
            self.present(cameraPicker, animated: true, completion: nil)
        } else {
            print("不支持拍照")
            
        }
        
    }
    @IBAction func cameraAction(_ sender: Any) {
        let photoPicker =  UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.allowsEditing = true
        photoPicker.sourceType = .photoLibrary
        //在需要的地方present出来
        self.present(photoPicker, animated: true, completion: nil)
        
    
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = pickedImage
           
            dismiss(animated: true) {
                
//                if self.showType == .result{
                    self.startRecognizing(pickedImage)
//                }else{
//             
//                    
//                }
            }
        }
    
    }
    
    
    func startRecognizing(_ image:UIImage) {
        let card = IDCardOCRViewController()
        card.image = image;
        self.navigationController?.pushViewController(card, animated: true);
        return;
        loadingLabel.isHidden = false
        CardRecognizeManager.recognizeCard().recognizeCard(with: image, type: "result") { [weak self](resultStr) in
            if resultStr.isEmpty {
                DispatchQueue.main.async {
                    let alert = UIAlertController.init(title: "照片识别失败", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: "ok", style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                    self?.loadingLabel.isHidden = true
                    
                }
            }else{
                DispatchQueue.main.async {
                    let alert = UIAlertController.init(title: "识别结果如下：", message: resultStr, preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: "ok", style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                    self?.loadingLabel.isHidden = true
                    
                }
            }
        }
    }
   
}
