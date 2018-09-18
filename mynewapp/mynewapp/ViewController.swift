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

class ViewController: UIViewController {

    
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var check: UIButton!
    
    @IBOutlet weak var spot: UILabel!
    @IBOutlet weak var back:UIImageView!
    @IBOutlet weak var signlabel:UILabel!
    
    @IBOutlet weak var name: UITextField!
    var timer = Timer()
    
    var videorecord=video()
    var count:Float=0.0
    let keyFrameAnimation = CAKeyframeAnimation(keyPath:"position")
    let fullSize = UIScreen.main.bounds.size
    var fullwidth:CGFloat = 0.0
    var fullheight:CGFloat = 0.0
    var json = writejson()
    var jsonposition=Position(x:[],y:[],orientation:[])
    let encoder = JSONEncoder()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.spotda.layer.removeAllAnimations()
        fullwidth = fullSize.width
        fullheight = fullSize.height
        //var jsonposition = json.Poisition(x:[],y:[],orientation:[])
        
        
        videorecord.checkAuthorization()
        initUI()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    @IBAction func UnWind(for segue :UIStoryboardSegue)
    {
        
        self.start.isHidden = false
        self.name.isHidden = false
        self.signlabel.isHidden = false
        self.check.isHidden=true
        self.spot.layer.removeAllAnimations()
        print("unwind...")
    }
    @objc func addcount(){
        
        //print(count)
        
        if let presentation = self.spot.layer.presentation(){
            
                //print( presentation.position)
                jsonposition.x.append(presentation.position.x)
                jsonposition.y.append(presentation.position.y)
                //jsonposition.orientation.append(presentation.orien)
                let data = try! encoder.encode(jsonposition)
                print(String(data: data, encoding: .utf8)!)
        }
        
        //print(spot.layer.position)
    }
    @IBAction func signin(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addcount), userInfo: nil, repeats: true)
        UIView.animate(withDuration: 1,delay:0,usingSpringWithDamping: 0.8,initialSpringVelocity: 2,animations:{self.start.isHidden = true ;self.name.isHidden = true ;self.signlabel.isHidden=true;self.back.isHidden=true})
        
        spotmove(spot:spot)
        UIView.animate(withDuration: 1,delay:0,animations:{self.check.isHidden = false;self.check.alpha=1})
        videorecord.recordVideo()
    }
    
    @IBAction func check(_ sender: Any) {
        videorecord.recordVideo()
        timer.invalidate()
        self.performSegue(withIdentifier: "gotophoto", sender: self)
        
    }
    
    func spotmove(spot:UILabel){
        let spotx = spot.center.x
        let spoty = spot.center.y
        //弧线位置移动
        let keyFrameAnimation = CAKeyframeAnimation(keyPath:"position")
        let mutablePath = CGMutablePath()
        
        mutablePath.move(to:CGPoint(x:spotx,y:spoty))
        mutablePath.addQuadCurve(to: CGPoint(x:30,y:30), control: CGPoint(x:0,y:fullheight*2/3))
        //mutablePath.addQuadCurve(to: CGPoint(x:spotx,y:spoty), control: CGPoint(x:fullwidth,y:10))
        
        keyFrameAnimation.path = mutablePath
        keyFrameAnimation.beginTime = CACurrentMediaTime()+1
        keyFrameAnimation.repeatCount = 30
        keyFrameAnimation.duration = 10.0
        keyFrameAnimation.fillMode = kCAFillModeForwards
        keyFrameAnimation.isRemovedOnCompletion = false
        spot.layer.add(keyFrameAnimation, forKey: "animation")
       
        
        
    }

   
    
    // 初始化自定义相机UI
    fileprivate func initUI() {
        
        
        check?.isHidden = true
        check?.alpha=0
    spot?.frame=CGRect(x:fullwidth*0.6,y:fullheight*0.65,width:fullwidth/10,height:fullwidth/10)
        
        back?.frame=CGRect(x:0,y:fullheight*3/4,width:fullwidth*9/10,height:fullheight/4)
       
        /*
        let tapButton = UIButton(type: .custom)
        tapButton.bounds = CGRect(x: 0, y: 0, width: 80, height: 80)
        tapButton.center = CGPoint(x: UIScreen.main.bounds.size.width * 0.5, y: UIScreen.main.bounds.size.height * 0.85)
        tapButton.setImage(UIImage(named: "cat"), for: .normal)
        tapButton.setImage(UIImage(named: "cat"), for: .selected)
        tapButton.addTarget(self, action: #selector(recordVideo), for: .touchUpInside)
        self.view.addSubview(tapButton)*/
        
    }
    
    struct Position: Codable {
        var x = [CGFloat]()
        var y = [CGFloat]()
        var orientation = [Int]()
    }
}

