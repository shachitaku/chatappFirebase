//
//  DrawingViewController.swift
//  chat-app
//
//  Created by Takumi Kimura on 2018/11/14.
//  Copyright © 2018年 com.takumi0kimura. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseCore
import FirebaseStorage
import Sketch
import ACEDrawingView
import SDWebImage

class DrawingViewController: UIViewController{
    

    @IBOutlet var sketchView: SketchView!
    var drawTool : SketchToolType!

    var storageRef: StorageReference!
    
    @IBOutlet weak var imageView: UIImageView! //接続したUIImageView
    @IBOutlet var testImage: UIImageView!
    var data: Data!
    
    @IBAction func signUpBtn_click(_ sender: UIButton) {
        
        // 画像のupload
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        UIGraphicsBeginImageContextWithOptions(sketchView.frame.size, false, 1)
        
        sketchView.layer.render(in: UIGraphicsGetCurrentContext()!)
        var image = imageView.image
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        //ココでようやくできた・・・。
        testImage.image = image
        
        data = imageView.image!.pngData()
        // UIImagePNGRepresentationでUIImageをNSDataに変換
        if let data = imageView.image!.pngData() {
            let reference = storageRef.child("images/" + "1" + ".png")
            reference.putData(data, metadata: nil, completion: { metaData, error in
                print(metaData as Any)
                print(error as Any)
            })
            dismiss(animated: true, completion: nil)
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sketchView = SketchView(frame: CGRect(x: 0, y: 88, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 88 - 128 - 44))
        view.addSubview(sketchView)

        
        let gsReference = Storage.storage().reference(forURL: "gs://chat-app-c0540.appspot.com/images/1.png")
        let httpsReference = URL(string: "https://firebasestorage.googleapis.com/v0/b/chat-app-c0540.appspot.com/o/images%2F1.png?alt=media&token=15c86c64-9972-4b63-aefd-6a37ebea3e20")

        let storageRef = Storage.storage().reference().child("images/")
        let imageRef = storageRef.child("1" + ".png")
        
        
        //このやり方だと出来ない・・・。
        /*
        // UIImageView in your ViewController
        let imageView: UIImageView = self.imageView
        
        // Placeholder image
        let placeholderImage = UIImage(named: "2624235i")
        
        // Load the image using SDWebImage
        imageView.sd_setImage(with: httpsReference, placeholderImage: placeholderImage)
        
        */
        
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("nope")
            } else {
                // Data for "images/1.png" is returned
                print("ok")
                self.imageView.image = UIImage(data: data!)
                let image: UIImage = UIImage(data: data!)!
                self.testImage.image = image
                
            }
        }
        
        
    }
    
    @IBAction func pickPen(_ sender :  Any){

        sketchView.drawTool = .pen
    }
    
    @IBAction func pickEraser(_ sender :  Any){
        
        sketchView.drawTool = SketchToolType.eraser
    }
    
    @IBAction func pickStamp(_ sender :  Any){
        sketchView.drawTool = SketchToolType.stamp
    }
    
    @IBAction func pickLine(_ sender :  Any){

        sketchView.drawTool = SketchToolType.line
    }
    
    @IBAction func pickArrow(_ sender :  Any){

        sketchView.drawTool = SketchToolType.arrow
    }
    
    @IBAction func pickRectangleStroke(_ sender :  Any){

        sketchView.drawTool = SketchToolType.rectangleStroke
    }
    
    @IBAction func pickRectangeFill(_ sender :  Any){

        sketchView.drawTool = SketchToolType.rectangleFill
    }
    
    @IBAction func pickEllipseStroke(_ sender :  Any){

        sketchView.drawTool = SketchToolType.ellipseStroke
    }
    
    @IBAction func pickEllipseFill(_ sender :  Any){

        sketchView.drawTool = SketchToolType.ellipseFill
    }
    
    @IBAction func redo(_ sender :  Any){

        sketchView.redo()
    }
    
    @IBAction func undo(_ sender :  Any){

        sketchView.undo()
    }
    
    @IBAction func clear(_ sender :  Any){


        sketchView.clear()
    }
    
    @IBAction func pickBlur(_ sender :  Any){

        sketchView.drawingPenType = PenType.blur
    }
    
    @IBAction func pickNeon(_ sender :  Any){

        sketchView.drawingPenType = PenType.neon
    }
}
