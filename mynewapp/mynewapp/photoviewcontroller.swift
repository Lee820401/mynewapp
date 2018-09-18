//
//  ViewController.swift
//  Detector
//
//  Created by Gregg Mojica on 8/21/16.
//  Copyright © 2016 Gregg Mojica. All rights reserved.
//

import UIKit
import CoreImage
import CoreGraphics

class photoviewcontroller: UIViewController {
    
    
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var clean:UIButton!
    @IBOutlet weak var paint: Paint!
    @IBOutlet weak var backtomain:UIButton!
    
    //@IBOutlet weak var widthSlider: UISlider!
    let filePath = "./position.txt"
    var testString=""
    
    //let pathFromNSHome = NSHomeDirectory() + "/position"
    // URL
    
    /*
    
    func getProjectFileContent(filename:String, fileExtension : String?) -> String? {
        var content="1"
        do{
            var file = Bundle.main.path(forResource: filename, ofType: fileExtension)
            if(file == nil){
                return ""
            }
            
            content = try  NSString(contentsOfFile: file!, encoding: 4) as String
        }catch{
            print(error)
        }
        return content
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fullSize = UIScreen.main.bounds.size
        let fullwidth=fullSize.width
        let fullheight=fullSize.height
        let frame = CGRect(x: 0, y: 10, width: fullwidth, height: fullheight-100)
        
        paint!.frame=frame
        //bg=UIImageView(frame:frame)
        bg.frame=frame
        //bg.image=UIImage(named:"image1")
        
        backtomain.frame=CGRect(x:10,y:fullheight-70,width:50,height:50)
        backtomain.backgroundColor=UIColor.black
        backtomain.isEnabled = true
        //self.view.addSubview(bg)
        //self.view.addSubview(paint)
        self.view.addSubview(backtomain)
        
        
    }
    //改变线宽刷新view
    /*
     @IBAction func configLineWidth(_ sender: Any) {
     paint.lineWidth = CGFloat(self.widthSlider.value) * 10
     
     }
     */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //清除面板
    @IBAction func cleanAll(_ sender: Any) {
        print("clean")
        
        paint.cleanAll()
        paint.setNeedsDisplay()
    }
    
    //保存图片
    
  
    //屏幕切换时刷新
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.paint.setNeedsDisplay()
    }
    
}



