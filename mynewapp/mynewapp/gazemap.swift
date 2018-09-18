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

class gazemap: UIViewController {
    
    
    @IBOutlet weak var user: UIImageView!
    @IBOutlet weak var bgofuser: option!
    @IBOutlet weak var account: option!
    @IBOutlet weak var setup: option!
    @IBOutlet weak var something: option!
    @IBOutlet weak var signout: option!
    var nowview:UIView!
    var timer = Timer()
    var count:Float=0
    let filePath = "./position.txt"
    var testString=""
    
    //let pathFromNSHome = NSHomeDirectory() + "/position"
    // URL
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fullSize = UIScreen.main.bounds.size
        let fullwidth=fullSize.width
        let fullheight=fullSize.height
        bgofuser!.frame = CGRect(x:0,y:10,width:fullwidth+20,height:fullheight/3)
        account!.frame = CGRect(x:10,y:fullheight/3+15,width:fullwidth-20,height:fullheight/6-5)
         setup!.frame = CGRect(x:10,y:fullheight/2+15,width:fullwidth-20,height:fullheight/6-5)
        something!.frame = CGRect(x:10,y:2*fullheight/3+15,width:fullwidth-20,height:fullheight/6-5)
        signout.frame = CGRect(x:10,y:5*fullheight/6+15,width:fullwidth-20,height:fullheight/6-5)
        user!.layer.cornerRadius = user.frame.size.width/2
        
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
    override func viewDidDisappear(_ animated: Bool) {
        // 將timer的執行緒停止
        if self.timer != nil {
            self.timer.invalidate()
        }
    }
    //清除面板
    @objc func addcount(){
        self.count+=0.1
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let t:UITouch = touch as! UITouch
            //当在屏幕上连续拍动两下时，背景恢复为白色
            
            //nowview.backgroundColor=UIColor(red: 0.5, green: 0, blue: 0, alpha: 0.6)
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(addcount), userInfo: nil, repeats: true)
            if( self.count >= 3)
            {
                
                self.view.backgroundColor = UIColor.white
            }
            
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let t:UITouch = touch as! UITouch
            
            if( self.count >= 3)
            {
                
                self.view.backgroundColor = UIColor.white
            }
            //print(t.location(in: self.view))
            print(self.count)
        }
    }
    
    //触摸结束 存线 存线宽 清空当前线
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.backgroundColor=UIColor.black
        timer.invalidate()
        self.count=0
        /*
        if touches.count == 2{
            //获取触摸点
            let first = (touches as NSSet).allObjects[0] as! UITouch
            let second = (touches as NSSet).allObjects[1] as! UITouch
            //获取触摸点坐标
            let firstPoint = first.location(in: self.view)
            let secondPoint = second.location(in: self.view)
            //计算两点间的距离
            let deltaX = secondPoint.x - firstPoint.x
            let deltaY = secondPoint.y - firstPoint.y
            let initialDistance = sqrt(deltaX*deltaX + deltaY*deltaY)
            print("两点间距离：\(initialDistance)")
            //计算两点间的角度
            let height = secondPoint.y - firstPoint.y
            let width = firstPoint.x - secondPoint.x
            let rads = atan(height/width);
            let degrees = 180.0 * Double(rads) / .pi
            print("两点间角度：\(degrees)")
        }*/
        print("event end!",count,self.count)
        
    }
    
}




