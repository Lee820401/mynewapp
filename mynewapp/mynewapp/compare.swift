//
//  ViewController.swift
//  mynewapp
//
//  Created by MISLab on 2018/2/26.
//  Copyright © 2018年 MISLab. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
class compare: UIViewController {
    var videorecord=video()
    var label=[UILabel]()
    var movelayer1 = UIButton()
    
    var time = UILabel()
    let fullSize = UIScreen.main.bounds.size
    let label_w=60
    let label_h=60
    var row = 0,col = 0
    var turnon=0;
    var timer = Timer()
    var count=0
    var total_time=0
    override func viewDidLoad() {
        super.viewDidLoad()
        row = Int(fullSize.height-20)/label_h
        col = Int(fullSize.width-30)/label_w
        
        videorecord.checkAuthorization()
        initUI()
        videorecord.recordVideo()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addcount), userInfo: nil, repeats: true)
        //animate()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        videorecord.recordVideo()
    }
    @objc func addcount(){
        if(turnon>0){
            //self.count+=1
            self.total_time+=1
            self.time.text = "time:" + String(self.total_time)
        }
            /*
        if(count>10){
            videorecord.recordVideo()
        }*/
    }
    @objc func animate(){
        
        var e_image:UIImage
        let emotion = Int(arc4random_uniform(100))
        let index = Int(arc4random_uniform(UInt32(self.row*self.col)))
        let f_h=Int(self.fullSize.height),f_w=Int(self.fullSize.width)
        let lx=self.label[index].center.x,ly=self.label[index].center.y,mx=self.movelayer1.center.x,my=self.movelayer1.center.y
        turnon=1
        if (count > 10){
            videorecord.recordVideo()
            
        }
        count+=1
        
        
        self.movelayer1.isEnabled=false
        
        let dur = 2
        let start = 1.0
        
        if(emotion<30){
            e_image=UIImage.animatedImageNamed("cat_btm", duration: 0.5)!
        }else{
            e_image=UIImage.animatedImageNamed("cat_a", duration: 0.5)!
        }
        if(ly>my){
            if(lx<mx){
                let image=UIImage.animatedImageNamed("cat_l", duration: 0.5)
                self.movelayer1.setImage(image, for:.normal)
            }else if(lx>mx){
                let image=UIImage.animatedImageNamed("cat_r", duration: 0.5)
                self.movelayer1.setImage(image, for:.normal)
            }else if(self.label[index].center.x==self.movelayer1.center.x){
                let image=UIImage.animatedImageNamed("cat_f", duration: 0.5)
                self.movelayer1.setImage(image, for:.normal)
            }
        }else{
            if(lx<mx){
                let image=UIImage.animatedImageNamed("cat_l", duration: 0.5)
                self.movelayer1.setImage(image, for:.normal)
            }else if(lx>mx){
                let image=UIImage.animatedImageNamed("cat_r", duration: 0.5)
                self.movelayer1.setImage(image, for:.normal)
            }else if(self.label[index].center.x==self.movelayer1.center.x){
                let image=UIImage.animatedImageNamed("cat_back", duration: 0.5)
                self.movelayer1.setImage(image, for:.normal)
            }
        }
        
        UIView.animate(withDuration: TimeInterval(dur), delay: start, animations: {
            self.movelayer1.center = self.label[index].center
            
        }, completion:{_ in self.movelayer1.setImage(e_image, for: .normal);self.movelayer1.isEnabled=true} )
        //UIView.animateKeyframes(withDuration:TimeInterval(animate_time) , delay: 0, options: UIViewKeyframeAnimationOptions.calculationModeCubic , animations: {
        //for index in 0..<count{
        
            
            //start += dur
        //}
        
                /*
                UIView.addKeyframe(withRelativeStartTime: start , relativeDuration: dur , animations: {
                    
                    p = self.label[index].center
                    //p.y += dy
                    self.movelayer1.center = p
                    self.movelayer2.center = p
                    self.count=0
                })
                start += dur+jump
            }
        }, completion: {_ in self.timer.invalidate();print(self.total_time)})
        print("I'm done!")*/
        
    }
    fileprivate func initUI() {
        let frame=CGRect(x:0,y:0,width:label_w,height:label_h)
        var b_or_f=1
        for i in 0..<col{
            for j in 0..<row{
                
                //let index=i*row+j
                let f_height=row*label_h
                //let alpha=Float(index)/Float(row*col)
                let tmplabel=UILabel()
                tmplabel.bounds=frame
                if b_or_f>0{
                    tmplabel.center = CGPoint(x: label_w * i+label_w/2+30, y: label_h * j+label_h/2+20)
                }else{
                    tmplabel.center = CGPoint(x: label_w * i+label_w/2+30, y: f_height-label_h * j-label_h/2+20)
                }
                tmplabel.layer.borderWidth=1
                
                tmplabel.layer.borderColor=UIColor(red:0, green:0, blue:0, alpha: 0.1).cgColor
                label.append(tmplabel)
            }
            b_or_f *= -1
        }
        for i in 0..<col{
            for j in 0..<row{
               let index=i*row+j
           self.view.addSubview(label[index])
            }
        }
        movelayer1=UIButton()
        movelayer1.layer.masksToBounds = true
        movelayer1.layer.cornerRadius=5
        movelayer1.bounds = CGRect(x:0,y:0,width:100,height:100)
        movelayer1.center = self.label[0].center
        movelayer1.setImage(UIImage(named:"cat_normal"), for:.normal)
        movelayer1.addTarget(self, action: #selector(animate), for: .touchUpInside)
        movelayer1.adjustsImageWhenHighlighted = false //使触摸模式下按钮也不会变暗（半透明）
        movelayer1.adjustsImageWhenDisabled = false
        self.view.addSubview(movelayer1)
        
        /*
         let tapButton = UIButton(type: .custom)
         tapButton.bounds = CGRect(x: 0, y: 0, width: 80, height: 80)
         tapButton.center = CGPoint(x: UIScreen.main.bounds.size.width * 0.5, y: UIScreen.main.bounds.size.height * 0.85)
         tapButton.setImage(UIImage(named: "cat"), for: .normal)
         tapButton.setImage(UIImage(named: "cat"), for: .selected)
         tapButton.addTarget(self, action: #selector(animate), for: .touchUpInside)
         self.view.addSubview(tapButton)
        */
        time = UILabel()
        time.text="time:0"
        time.bounds = CGRect(x: 0, y: 0, width: 80, height: 80)
        time.center = CGPoint(x:fullSize.width-100 , y:10 )
        self.view.addSubview(time)
    }
   
        
    
    
    struct Position: Codable {
        var x = [CGFloat]()
        var y = [CGFloat]()
        var orientation = [Int]()
    }
}


