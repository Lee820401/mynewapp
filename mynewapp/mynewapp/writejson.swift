//
//  writejson.swift
//  mynewapp
//
//  Created by MISLab on 2018/3/8.
//  Copyright © 2018年 MISLab. All rights reserved.
//

import Foundation
import UIKit


class writejson:UIViewController{
    //let beer=Device(x:1,y:2.1,orientation:3)
    //var position=Position()
    let encoder = JSONEncoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*
    func printout(){
        
        let data = try! encoder.encode(position)
        print(String(data: data, encoding: .utf8)!)
    }*/
    struct Position: Codable {
        var x = [Float]()
        var y = [Float]()
        var orientation = [Int]()
    }
    
}
