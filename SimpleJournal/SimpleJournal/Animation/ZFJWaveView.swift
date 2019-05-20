//
//  ZFJWaveView.swift

import UIKit

typealias JSWaveBlock = (CGFloat) ->()

class JSProxy: NSObject {
    var executor: AnyObject!
    
    @objc func callback() {
        //clang diagnostic push
        //clang diagnostic ignored "-Wundeclared-selector"
        executor.perform(#selector(ZFJWaveView.wave))
        //clang diagnostic pop
    }
    
}

class ZFJWaveView: UIView {
    
    var waveBlock: JSWaveBlock?
    var waveCurvature: CGFloat?                    //浪弯曲度
    var waveSpeed: CGFloat?                        //浪速
    var realWaveColor : UIColor! = UIColor.white   //实浪颜色
    var maskWaveColor : UIColor! = UIColor.white   //遮罩浪颜色
    var timer: CADisplayLink?                      //刷屏器
    var offset: CGFloat?
    
    //真实浪
    lazy var realWaveLayer: CAShapeLayer = {
        let realWaveLayer = CAShapeLayer()
        var frame1: CGRect = self.bounds
        frame1.origin.y = frame1.size.height - self.waveHeight!
        frame1.size.height = self.waveHeight!
        realWaveLayer.frame = frame1
        realWaveLayer.fillColor = self.realWaveColor.cgColor
        return realWaveLayer
    }()
    
    //遮罩浪
    lazy var maskWaveLayer: CAShapeLayer = {
        let maskWaveLayer = CAShapeLayer()
        var frame2: CGRect = self.bounds
        frame2.origin.x = frame2.origin.x + 50;
        frame2.origin.y = frame2.size.height - self.waveHeight!
        frame2.size.height = self.waveHeight!
        maskWaveLayer.frame = frame2
        maskWaveLayer.fillColor = self.maskWaveColor.cgColor
        return maskWaveLayer;
    }()
    
    convenience init() {
        self.init(frame: CGRect.zero)
        initData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData(){
        waveSpeed = 1.8
        waveCurvature = 1.5
        waveHeight = 6
        offset = 0
        realWaveColor = UIColor.white
        maskWaveColor = UIColor.white.withAlphaComponent(0.5)
        
        //添加两条线
        self.layer.addSublayer(self.realWaveLayer)
        self.layer.addSublayer(self.maskWaveLayer)
    }
    
    //浪高
    var waveHeight: CGFloat?{
        didSet{
            var frame: CGRect = self.bounds
            frame.origin.y = frame.size.height - waveHeight!
            frame.size.height = waveHeight!
            self.realWaveLayer.frame = frame
            
            var frame1: CGRect = self.bounds
            frame1.origin.y = frame1.size.height - waveHeight!
            frame1.size.height = waveHeight!
            self.maskWaveLayer.frame = frame1
        }
    }
    
    func startWaveAnimation(){
        let proxy = JSProxy()
        proxy.executor = self;
        timer = CADisplayLink(target: proxy, selector: #selector(JSProxy.callback))
        timer?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
    func stopWaveAnimation(){
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc public func wave(){
        self.offset = self.waveSpeed! + self.offset!
        let width: CGFloat = self.frame.width
        let height = self.waveHeight
   
        //真实浪
        let path = CGMutablePath()
        path.move(to: CGPoint(x: CGFloat(0), y: height!), transform: .identity)
        var y: CGFloat = 0.0
        
        //遮罩浪
        let maskpath = CGMutablePath()
        maskpath.move(to: CGPoint(x: CGFloat(0), y: height!), transform: .identity)
        var maskY: CGFloat = 0.0
        
        let forWidth = Int(width)
        for x in 0...forWidth {
            let sinfValue = Float(0.01 * self.waveCurvature! * CGFloat(x) + self.offset! * 0.045)
            y = height! * CGFloat(sinf(sinfValue))
            path.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y)), transform: .identity)
            maskY = -y
            maskpath.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(maskY)), transform: .identity)
        }
        
        //变化的中间Y值
        let centX: CGFloat = self.bounds.size.width / 2
        let sinfValue = Float(0.01 * self.waveCurvature! * centX + self.offset! * 0.045)
        let CentY: CGFloat = height! * CGFloat(sinf(sinfValue))
        if (self.waveBlock != nil) {
            self.waveBlock!(CentY)
        }
        
        path.addLine(to: CGPoint(x: CGFloat(width), y: CGFloat(height!)), transform: .identity)
        path.addLine(to: CGPoint(x: CGFloat(0), y: CGFloat(height!)), transform: .identity)
        path.closeSubpath()
        self.realWaveLayer.fillColor = self.realWaveColor.cgColor
        self.realWaveLayer.path = path
        
        maskpath.addLine(to: CGPoint(x: CGFloat(width), y: CGFloat(height!)), transform: .identity)
        maskpath.addLine(to: CGPoint(x: CGFloat(0), y: CGFloat(height!)), transform: .identity)
        maskpath.closeSubpath()
        self.maskWaveLayer.fillColor = self.maskWaveColor.cgColor
        self.maskWaveLayer.path = maskpath
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
