//
//  FaceViewController.swift
//  MLKit Starter Project
//
//  Created by Sai Kambampati on 5/20/18.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit
//import Firebase
//import GLKit
//import CoreML

class FaceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var agingImageView: UIImageView!
    @IBOutlet weak var resultView: UITextView!
    
    @IBOutlet weak var uploadImage: UIButton!
    /*
    let options = VisionFaceDetectorOptions()
    lazy var vision = Vision.vision()
    var faceFrame = CGRect()
//    var faceLandmarkArr : [String:[VisionPoint]] = [:]
    var faceLandmarkPointsArr : [String:VisionPoint] = [:]

    var glkViewController: FaceGLKViewController? = nil
    let imagePicker = UIImagePickerController()
    
    // 预设皱纹特征点坐标
    let face_df_vertices: [vector_float2] = [
        [1,295], [2,345], [2,396], [10,454], [26,508],//5
        [58,566], [100,621], [139,650], [180,674], [239,682],//5
        [294,676], [340,649], [375,620], [416,568], [444,513],//5
        [463,458], [475,399], [478,350], [475,297],//4
        
        [67,296], [119,269], [171,296], [121,318], [120,293],//5
        [305,296], [354,269], [408,295], [355,316], [353,293],//5
        
//        [213,296], [192,389], [167,441], [206,480], [239,482],//5
//        [275,480], [312,444], [282,389], [266,293], [239,440],//5
        
        [213,296], [239,482],//2
        [282,389], [266,293], [239,440],//3

        
        [138,533], [239,512], [342,529], [239,561]//4
    ]
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GLKView", let glkViewController = segue.destination as? FaceGLKViewController {
            self.glkViewController = glkViewController
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        imagePicker.delegate = self
        
        // 在视图加载后做的额外的事情
        options.performanceMode = .accurate
        options.landmarkMode = .all
        options.classificationMode = .all
        options.contourMode = .all
        options.minFaceSize = CGFloat(0.1)
        
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        self.showBottomAlert()
    }
    
    func showBottomAlert(){
        
        let alertController=UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel=UIAlertAction(title:"取消", style: .cancel, handler: nil)
        let takingPictures=UIAlertAction(title:"拍照", style: .default)
        {
            action in
            self.goCamera()
            
        }
        let localPhoto=UIAlertAction(title:"本地图片", style: .default)
        {
            action in
            self.goImage()
            
        }
        alertController.addAction(cancel)
        alertController.addAction(takingPictures)
        alertController.addAction(localPhoto)
        self.present(alertController, animated:true, completion:nil)
        
    }
    func goCamera(){
        
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
    func goImage(){
        
        let photoPicker =  UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.allowsEditing = true
        photoPicker.sourceType = .photoLibrary
        //在需要的地方present出来
        self.present(photoPicker, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            var resultImage = pickedImage
            
            // 拍照
//            if picker.sourceType == .camera {
//                resultImage = pickedImage.fixOrientation()
//            }
            imageView.image = resultImage

            let vision = Vision.vision()
            
            let faceDetector = vision.faceDetector(options: options)
            let visionImage = VisionImage(image: resultImage)
            
            self.resultView.text = ""
           
            //1
            faceDetector.process(visionImage) { features, error in
                guard error == nil, let features = features, !features.isEmpty else {
                    self.dismiss(animated: true, completion: nil)
                    self.resultView.text = "No Face Detected"
                    return
                }
                //3
                self.resultView.text = self.resultView.text + "I see \(features.count) face(s).\n\n"

                for face in features {
                    let frame = face.frame
                    
                    self.faceFrame = frame
                    self.resultView.text = self.resultView.text + "This person's frame is \(frame).\n\n"

                    if face.hasHeadEulerAngleY {
                        let rotY = face.headEulerAngleY  // Head is rotated to the right rotY degrees
                        self.resultView.text = self.resultView.text + "This person's rotY is \(rotY).\n\n"

                    }
                    if face.hasHeadEulerAngleZ {
                        let rotZ = face.headEulerAngleZ  // Head is rotated upward rotZ degrees
                        self.resultView.text = self.resultView.text + "This person's rotZ is \(rotZ).\n\n"

                    }
                    
                    // If landmark detection was enabled (mouth, ears, eyes, cheeks, and
                    // nose available):
                    if let leftEye = face.landmark(ofType: .leftEye) {
                        let leftEyePosition = leftEye.position
                        self.resultView.text = self.resultView.text + "This person's leftEyePosition is \(leftEyePosition).\n\n"

                    }
                    
                    //整个脸的外轮廓
                    if let faceOval = face.contour(ofType: .face){
                        let faceOvalPoints = faceOval.points
                        
                        self.selectFeaturesPoints([30,28,27,26,25,24,21,20,19,18], "contour_left", faceOvalPoints)

                        self.selectFeaturesPoints([17,16,15,13,11,10,9,8,6], "contour_right", faceOvalPoints)

                        self.resultView.text = self.resultView.text + "This person's FACE_OVAL is \(faceOvalPoints).\n\n"
                    }
                    
                    // If contour detection was enabled:
                    //左眼
                    if let leftEyeContour = face.contour(ofType: .leftEye) {
                        let leftEyePoints = leftEyeContour.points
                        self.selectFeaturesPoints([0,4,8,12,15], "left_eye", leftEyePoints)
                        self.resultView.text = self.resultView.text + "This person's leftEyePoints is \(leftEyePoints).\n\n"

                    }
                    //右眼
                    if let rightEyeContour = face.contour(ofType: .rightEye) {
                        let rightEyePoints = rightEyeContour.points
                        self.selectFeaturesPoints([0,4,8,12,15], "right_eye", rightEyePoints)

                        self.resultView.text = self.resultView.text + "This person's RIGHT_EYE is \(rightEyePoints).\n\n"
                        
                    }
                    //左top眉毛
                    if let leftEyebrowTopContour = face.contour(ofType: .leftEyebrowTop){
                        let leftEyebrowTopPoint = leftEyebrowTopContour.points

                        self.resultView.text = self.resultView.text + "This person's LEFT_EYEBROW_TOP is \(leftEyebrowTopPoint).\n\n"
                    }
                    
                    //右top眉毛
                    if let rightEyebrowTopContour = face.contour(ofType: .rightEyebrowTop){
                        let rightEyebrowTopPoint = rightEyebrowTopContour.points

                        self.resultView.text = self.resultView.text + "This person's RIGHT_EYEBROW_TOP is \(rightEyebrowTopPoint).\n\n"
                    }
                    
                    
                    //鼻梁
                    if let noseBridgeContour = face.contour(ofType: .noseBridge) {
                        let noseBridgePoints = noseBridgeContour.points
                        self.selectFeaturesPoints([0,1], "nose_contour_left", noseBridgePoints)
                        self.resultView.text = self.resultView.text + "This person's NOSE_BRIDGE is \(noseBridgePoints).\n\n"
                    }
                    //俩鼻孔
                    if let noseBottomContour = face.contour(ofType: .noseBottom) {
                        let noseBottomPoints = noseBottomContour.points
                        self.selectFeaturesPoints([0,1,2], "nose_bottom", noseBottomPoints)
                       
                        self.resultView.text = self.resultView.text + "This person's NOSE_BOTTOM is \(noseBottomPoints).\n\n"
                    }
                    
                    //上嘴唇上边
                    if let upperLipTopContour = face.contour(ofType: .upperLipTop) {
                        let upperLipTopPoints = upperLipTopContour.points
                        
                        self.selectFeaturesPoints([0,5,10], "upper_lip_top", upperLipTopPoints)

                        self.resultView.text = self.resultView.text + "This person's UPPER_LIP_TOP is \(upperLipTopPoints).\n\n"
                    }
                    
                    //上嘴唇下边
                    if let upperLipBottomContour = face.contour(ofType: .upperLipBottom) {
                        let upperLipBottomPoints = upperLipBottomContour.points

                        self.resultView.text = self.resultView.text + "This person's upperLipBottomPoints is \(upperLipBottomPoints).\n\n"

                    }
                    
                    //下嘴唇上边                    
                    if let lowerLipTopContour = face.contour(ofType: .lowerLipTop) {
                        let lowerLipTopPoints = lowerLipTopContour.points

                        self.resultView.text = self.resultView.text + "This person's LOWER_LIP_TOP is \(lowerLipTopPoints).\n\n"
                    }
                    
                    //下嘴唇下边
                    if let lowerLipBottomContour = face.contour(ofType: .lowerLipBottom) {
                        let lowerLipBottomPoints = lowerLipBottomContour.points

                         self.selectFeaturesPoints([4], "lower_lip_bottom", lowerLipBottomPoints)
                        
//                        self.faceLandmarkArr.updateValue(lowerLipBottomPoints, forKey: "LOWER_LIP_BOTTOM")

                        self.resultView.text = self.resultView.text + "This person's LOWER_LIP_BOTTOM is \(lowerLipBottomPoints).\n\n"
                        
                    }
                    
                    
                    // If classification was enabled:
                    if face.hasSmilingProbability {
                        let smileProb = face.smilingProbability
                        if smileProb < 0.3 {
                            self.resultView.text = self.resultView.text + "This person is not smiling.\n\n"
                        } else {
                            self.resultView.text = self.resultView.text + "This person is smiling.\n\n"
                        }
                    }
                    if face.hasRightEyeOpenProbability {
                        let rightEyeOpenProb = face.rightEyeOpenProbability
                    }
                    
                    // If face tracking was enabled:
                    if face.hasTrackingID {
                        let trackingId = face.trackingID
                    }
                }
                self.startAging(faceImage: resultImage)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func selectFeaturesPoints(_ valueBeans:[Int],_ keyStr:String,_ featuresArr:[VisionPoint] )  {
    
        for index in valueBeans{
            let resultPonit = featuresArr[index]
            faceLandmarkPointsArr.updateValue(resultPonit, forKey:keyStr + "\(index)" )
        }
        print("faceLandmarkPointsArr-->\(faceLandmarkPointsArr)")
    }
    

}



// MARK: 人脸老化处理相关
extension FaceViewController {
    
    func startAging(faceImage: UIImage) {
        // 人脸变老处理
        //top：矩形框左上角像素点的纵坐标
        //left：矩形框左上角像素点的横坐标
        //width：矩形框的宽度
        //height：矩形框的高度
        let faceRect = self.faceFrame
        print("faceRect----\(faceRect)")
        let left = Int(faceRect.minX)
        let top = Int(faceRect.minY) - Int(faceRect.height) * 1 / 6
        let rect = CGRect(x: CGFloat(left), y: CGFloat(top), width: (faceRect.width), height: (faceRect.height) * 1.5)

        
        var vertexData = [float2]()
        let landmarks = self.faceLandmarkPointsArr //83/106个特征点
        print("landmarks-->\(landmarks )")
        if landmarks.count == 0{
            return
        }
        for vertex in (self.glkViewController?.face_vertices)! {//遍历预设的40多个特征点
            let vPonit:VisionPoint = landmarks[vertex]!
            let floatPoint = vPonit.x.intValue
            //float2: 2个32位单精度值的向量。
            let data: float2 = [Float(floatPoint - left) - Float(rect.size.width / 2), Float(rect.size.height / 2) - Float(floatPoint - top)]
            vertexData.append(data)
        }
        print(">>>>>\(vertexData)")
        
        let squareRect = CGRect(x: left - (Int(rect.height - rect.width)) / 2, y: top, width: Int(rect.height), height: Int(rect.height))
        
        print("<<<<<<<\(squareRect)")
        let wrinkle_orignal = UIImage(named: "Wrinkle")!
      
        self.glkViewController?.setupImage(image: wrinkle_orignal, width: rect.size.width, height: rect.size.height, original_vertices: self.face_df_vertices, target_vertices: vertexData)
        
        let wrinkle = (self.glkViewController?.view as! GLKView).snapshot
        let agingResult = self.faceAging(face: faceImage, wrinkle: wrinkle, faceRect: squareRect)
        
        self.agingImageView.image = agingResult
    }
    
    
    /// 变老
    ///
    /// - Parameters:
    ///   - face: 人脸图片
    ///   - wrinkle: 皱纹纹理图片
    ///   - faceRect: 人脸区域
    /// - Returns: 合成结果
    func faceAging(face: UIImage, wrinkle: UIImage, faceRect: CGRect) -> UIImage? {
        let rendererRect = CGRect(x: 0, y: 0, width: face.size.width, height: face.size.height)
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: rendererRect)
        
            let outputImage = renderer.image { ctx in
                UIColor.white.set()
                ctx.fill(rendererRect)
                face.draw(in: rendererRect, blendMode: .normal, alpha: 1)
                // 柔光融合
                wrinkle.draw(in: faceRect, blendMode: .softLight, alpha: 1)
            }
            return outputImage
        }else{
            return UIImage.init()

        }
    }
 
 */
    
}
