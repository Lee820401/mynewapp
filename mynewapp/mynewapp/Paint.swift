import UIKit

class Paint: UIView {
    
    public var lineWidth:CGFloat = 10
    fileprivate var allLineArray = [[CGPoint]]()   //所有的线    记录每一条线
    fileprivate var currentPointArray = [CGPoint]() //当前画线的点  画完置空 增加到 线数组中
    fileprivate var allPointWidth = [CGFloat]()    //所有的线宽
    override init(frame: CGRect) {
        super.init(frame: frame)
        //设置背景色为透明，否则是黑色背景
        self.backgroundColor = UIColor.clear
        //self.image=UIImage(named:"image1")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    /*
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        
        //绘制之前的线
        if allLineArray.count > 0 {
            //遍历之前的线
            for i in 0..<allLineArray.count {
                let tmpArr = allLineArray[i]
                if tmpArr.count > 0 {
                    
                    //画线
                    context?.beginPath()
                    //取出起始点
                    let sPoint:CGPoint = tmpArr[0]
                    context?.move(to: sPoint)
                    //取出所有当前线的点
                    for j in 0..<tmpArr.count {
                        var colornow:CGFloat
                        var a:Float
                        let rem=4
                        if i+rem>allLineArray.count{
                            a=Float(i+rem-allLineArray.count)*0.25
                        }else{
                            a=0
                        }
                        colornow = CGFloat(a)
                        print("a",a,"color",colornow)
                        context?.setStrokeColor(red: 1-colornow, green: 0, blue: 0, alpha: colornow-0.4 )
                        
                        let endPoint:CGPoint = tmpArr[j]
                        context?.addLine(to: endPoint)
                    }
                    context?.setLineWidth(allPointWidth[i])
                    context?.strokePath()
                    
                }
            }
        }
        
        
        if currentPointArray.count > 0 {
            //绘制当前线
            context?.beginPath()
            context?.setLineWidth(self.lineWidth)
            context?.move(to: currentPointArray[0])
            //lineWidth=15
            print("0",currentPointArray[0])
            
            for i in 0..<currentPointArray.count {
                var ix,iy:CGFloat
                var colornow:CGFloat
                var a:Float
                ix=currentPointArray[i].x
                iy=currentPointArray[i].y
                a=Float(i)/Float(currentPointArray.count)
                colornow = CGFloat(a)
                //print("a",a,"color",colornow)
                context?.setLineWidth(10)
                context?.setStrokeColor(red: colornow, green: 0, blue: 0, alpha: 0.03 )
                //context?.addLine(to: currentPointArray[i])
                context?.addArc(center:CGPoint(x:ix,y:iy) , radius: CGFloat(20), startAngle: CGFloat(0), endAngle: CGFloat(2*Double.pi), clockwise: true)
                context?.setLineWidth(30)
                context?.strokePath()
                
                context?.addArc(center:CGPoint(x:ix,y:iy) , radius: CGFloat(10), startAngle: CGFloat(0), endAngle: CGFloat(2*Double.pi), clockwise: true)
                context?.setFillColor(red: colornow, green: 0, blue: 0, alpha: 0.1 )
               
                context?.fillPath()
                
            }
            
            //context2?.strokePath()
            //context?.strokePath()
            
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let point:CGPoint = (event?.allTouches?.first?.location(in: self))!
        //路径起点
        currentPointArray.append(point)
        self.setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let point:CGPoint = (event?.allTouches?.first?.location(in: self))!
        //路径
        currentPointArray.append(point)
        
        //刷新视图
        self.setNeedsDisplay()
        
        
    }
    
    //触摸结束 存线 存线宽 清空当前线
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        allPointWidth.append(self.lineWidth)
        allLineArray.append(currentPointArray)
        currentPointArray.removeAll()
        self.setNeedsDisplay()
        
    }
    
    func cleanAll(){
        print(currentPointArray,allLineArray)
        allLineArray.removeAll()
        currentPointArray.removeAll()
        allPointWidth.removeAll()
        print(currentPointArray,allLineArray)
        self.setNeedsDisplay()
        
    }
    
    
    
}

