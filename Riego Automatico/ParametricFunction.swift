//
//  ParametricFunction.swift
//  Riego Automatico
//
//  Created by javier  on 1/10/17.
//  Copyright © 2017 UPM. All rights reserved.
//

import UIKit

struct FunctionPoint {
    var x = 0.0
    var y = 0.0
}

protocol ParametricFunctionDataSource: class {
    
    func startFor(_ pfv: ParametricFunction) -> Double
    func endFor(_ pfv : ParametricFunction) -> Double
    func parametricPoint (_ pfv: ParametricFunction, pointAt index: Double) -> FunctionPoint
}

@IBDesignable
class ParametricFunction: UIView {
    
    @IBInspectable
    var lineWidth : Double = 3.0
    
    @IBInspectable
    var trajectoryColor : UIColor = UIColor.red
    
    var scaleX: Double = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var scaleY: Double = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var resolution: Double = 500 {
        didSet {
            setNeedsDisplay()
        }
    }
    
#if TARGET_INTERFACE_BUILDER
    var dataSource: ParametricFunctionDataSource!
#else
    weak var dataSource: ParametricFunctionDataSource!
#endif
    
    override func prepareForInterfaceBuilder() {
        class FakeDataSource: ParametricFunctionDataSource{
            func startFor(_ pfv: ParametricFunction ) -> Double {return 0.0}
            func endFor(_ pfv: ParametricFunction) -> Double {return 1.0}
            func parametricPoint(_ pfv : ParametricFunction, pointAt index:Double) -> FunctionPoint {return FunctionPoint(x: index, y:index)}
        }
        dataSource = FakeDataSource()
    }
    
    override func draw(_ rect: CGRect) {
        drawAxis()
        drawTrajectory()
    }
    
    private func drawAxis() {
        
        let width = bounds.size.width
        let height = bounds.size.height
        
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: width/2, y: 0))
        path1.addLine(to: CGPoint(x: width/2, y: height))
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 0, y: height/2))
        path2.addLine(to: CGPoint(x: width, y: height/2))
        
        UIColor.black.setStroke()
        
        path1.lineWidth = 1
        path1.stroke()
        path2.lineWidth = 1
        path2.stroke()
    }
    
    private func drawTrajectory() {
        
        let start = dataSource.startFor(self)
        let end = dataSource.endFor(self)
        let dp = max((end - start) / resolution , 0.01)
        
        let path = UIBezierPath()
        
        var posicion = dataSource.parametricPoint(self, pointAt: start)
        
        var x = pointForX(posicion.x)
        var y = pointForY(posicion.y)
        path.move(to: CGPoint(x: x, y: y))
        
        
        for t in stride(from: start, to: end, by: dp) {
            posicion = dataSource.parametricPoint(self, pointAt: t)
            x = pointForX(posicion.x)
            y = pointForY(posicion.y)
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.lineWidth = CGFloat(lineWidth)
        
        trajectoryColor.set()
        
        path.stroke()
    }
    
    private func pointForX(_ x: Double) -> CGFloat {
        let width = bounds.size.width
        return width/2 + CGFloat(x*scaleX)
    }
    
    private func pointForY(_ y: Double) -> CGFloat {
        let height = bounds.size.height
        return height/2 - CGFloat(y*scaleY)
    }
}
