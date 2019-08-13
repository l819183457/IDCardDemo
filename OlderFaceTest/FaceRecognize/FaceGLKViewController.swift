//
//  FaceWrinkle.swift
//  FaceDemo
//
//  Created by wuzhiqiang on 2019/3/14.
//  Copyright © 2019 wuzhiqiang. All rights reserved.
//

import UIKit
import GLKit

class FaceGLKViewController: GLKViewController {

    var context: EAGLContext?
    var effect: GLKBaseEffect?
    var mainImage: ImageMesh?
    var ratio_width: Float = 0.0, ratio_height: Float = 0.0
    var width: Float = 0.0, height: Float = 0.0
    /*
    let face_vertices = [
        "contour_left30", "contour_left28", "contour_left27", "contour_left26", "contour_left25",
        "contour_left24", "contour_left21", "contour_left20", "contour_left19", "contour_left18",
        "contour_right17", "contour_right16", "contour_right15", "contour_right13", "contour_right11",
        "contour_right10", "contour_right9", "contour_right8", "contour_right6",

        "left_eye0", "left_eye4", "left_eye8", "left_eye12", "left_eye15",
        "right_eye0", "right_eye4", "right_eye8", "right_eye12", "right_eye15",

//        "nose_contour_left1", "nose_contour_left2", "nose_left", "nose_contour_left3", "nose_contour_lower_middle",
//        "nose_contour_right3", "nose_right", "nose_contour_right2", "nose_contour_right1", "nose_tip",

        "nose_contour_left0", "nose_contour_left1",
        "nose_bottom0", "nose_bottom1", "nose_bottom2",

        
        "upper_lip_top0", "upper_lip_top5", "upper_lip_top10", "lower_lip_bottom4"
    ]

//    let face_vertices = [
//    "FACE_OVAL","LEFT_EYEBROW_TOP","LEFT_EYEBROW_BOTTOM","RIGHT_EYEBROW_TOP","RIGHT_EYEBROW_BOTTOM","LEFT_EYE","RIGHT_EYE","UPPER_LIP_TOP","UPPER_LIP_BOTTOM","LOWER_LIP_TOP","LOWER_LIP_BOTTOM","NOSE_BRIDGE","NOSE_BOTTOM"
//    ]

    private func setupGL() {
        context = EAGLContext(api: .openGLES3)
        EAGLContext.setCurrent(context)
        effect = GLKBaseEffect()
        if let view = self.view as? GLKView, let context = context {
            view.context = context
        }

    }

    func setupViewSize() {
        width = (mainImage?.image_width)!
        height = (mainImage?.image_height)!
        let rectRadius = (width >= height ? width : height) / 2
        effect?.transform.projectionMatrix = GLKMatrix4MakeOrtho(-rectRadius, rectRadius, -rectRadius, rectRadius, -1, 1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isOpaque = false
        mainImage = ImageMesh(vd: 15, hd: 22)
        setupGL()
    }

    var isSetup = false

    func setupImage(image: UIImage, width: CGFloat, height: CGFloat, original_vertices: [float2], target_vertices: [float2]) {
        let _ = mainImage?.loadImage(image: image, width: width, height: height)
        setupViewSize()
        let count = target_vertices.count
        var p = original_vertices
        // 转换坐标系
        for i in 0..<count {
            p[i] = [p[i].x - Float(image.size.width / 2), Float(image.size.height / 2) - p[i].y]
            p[i] = [p[i].x * Float(width) / Float(image.size.width), p[i].y * Float(height) / Float(image.size.height)]
        }

//        let q = target_vertices
        let q = p;
        var w = [Float](repeating: 0.0, count: count)
        
        // 计算变形权重
        for i in 0..<(self.mainImage?.numVertices)! {
            var ignore = false
            for j in 0..<count {
                let distanceSquare = ((self.mainImage?.ixy![i])! - p[j]).squaredNorm()
                if distanceSquare < 10e-6 {
                    self.mainImage?.xy![i] = p[j]
                    ignore = true
                }

                w[j] = 1 / distanceSquare
            }

            if ignore {
                continue
            }

            var pcenter = vector_float2()
            var qcenter = vector_float2()
            var wsum: Float = 0.0
            for j in 0..<count {
                wsum += w[j]
                pcenter += w[j] * p[j]
                qcenter += w[j] * q[j]
            }

            pcenter /= wsum
            qcenter /= wsum

            var ph = [vector_float2](repeating: [0.0, 0.0], count: count)
            var qh = [vector_float2](repeating: [0.0, 0.0], count: count)
            for j in 0..<count {
                ph[j] = p[j] - pcenter
                qh[j] = q[j] - qcenter
            }
            
            // 开始矩阵变换
            var M = matrix_float2x2()
            var P: matrix_float2x2? = nil
            var Q: matrix_float2x2? = nil
            var mu: Float = 0.0
            for j in 0..<count {
                P = matrix_float2x2([ph[j][0], ph[j][1]], [ph[j][1], -ph[j][0]])
                Q = matrix_float2x2([qh[j][0], qh[j][1]], [qh[j][1], -qh[j][0]])
                M += w[j] * Q! * P!
                mu += w[j] * ph[j].squaredNorm()
            }

            self.mainImage?.xy![i] = M * ((self.mainImage?.ixy![i])! - pcenter) / mu;
            self.mainImage?.xy![i] = ((self.mainImage?.ixy![i])! - pcenter).norm() * ((self.mainImage?.xy![i])!).normalized() + qcenter;
        }

        self.mainImage?.deform()

        isSetup = true
    }


    @IBAction func deform(_ sender: Any) {
        mainImage?.initialize()
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        // 透明背景
        glClearColor(0.0, 0.0, 0.0, 0.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))

        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA));
        glEnable(GLenum(GL_BLEND));

        if (isSetup) {
            renderImage()
        }
    }

    func renderImage() {
        self.effect?.texture2d0.name = (mainImage?.texture?.name)!
        self.effect?.texture2d0.enabled = GLboolean(truncating: true)
        self.effect?.prepareToDraw()

        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue))
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.texCoord0.rawValue))

        glVertexAttribPointer(GLuint(GLKVertexAttrib.position.rawValue), 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 8, mainImage?.verticesArr)
        glVertexAttribPointer(GLuint(GLKVertexAttrib.texCoord0.rawValue), 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 8, mainImage?.textureCoordsArr)

        for i in 0..<(mainImage?.verticalDivisions)! {
            glDrawArrays(GLenum(GL_TRIANGLE_STRIP), GLint(i * (self.mainImage!.horizontalDivisions * 2 + 2)), GLsizei(self.mainImage!.horizontalDivisions * 2 + 2))
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        if self.isViewLoaded && self.view.window != nil {
            self.view = nil

            self.tearDownGL()

            if EAGLContext.current() === self.context {
                EAGLContext.setCurrent(nil)
            }
            self.context = nil
        }
    }

    func tearDownGL() {
        EAGLContext.setCurrent(self.context)
        self.effect = nil
    }
 */
}
