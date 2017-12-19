//
//  ViewController.swift
//  Riego Automatico
//
//  Created by javier  on 1/10/17.
//  Copyright © 2017 UPM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ParametricFunctionDataSource {

    
    @IBOutlet weak var trajectoryView: ParametricFunction!
    @IBOutlet weak var waterHeightTimeView: ParametricFunction!
    @IBOutlet weak var waterSpeedHeightView: ParametricFunction!
    
    @IBOutlet weak var initialWaterSlider: UISlider!
    @IBOutlet weak var radiusTankSlider: UISlider!
    @IBOutlet weak var timeSlider: UISlider!
    
    
    @IBOutlet weak var RadioDisplay: UILabel!
    @IBOutlet weak var AlturaDisplay: UILabel!
    @IBOutlet weak var tiempoDisplay: UILabel!
    
    var tankModel: TankModel!
    var trajectoryModel : TrajectoryModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        let pinchRec1 = UIPinchGestureRecognizer(target: self,
                                                action: #selector(processPinch1(_:)))
        let pinchRec2 = UIPinchGestureRecognizer(target: self,
                                                 action: #selector(processPinch2(_:)))
        let pinchRec3 = UIPinchGestureRecognizer(target: self,
                                                 action: #selector(processPinch3(_:)))
        trajectoryView.addGestureRecognizer(pinchRec1)
        waterHeightTimeView.addGestureRecognizer(pinchRec2)
        waterSpeedHeightView.addGestureRecognizer(pinchRec3)
        
        let lpRec1 = UILongPressGestureRecognizer(target: self,
                                                 action: #selector(processLongPress1(_:)))
        let lpRec2 = UILongPressGestureRecognizer(target: self,
                                                  action: #selector(processLongPress2(_:)))
        let lpRec3 = UILongPressGestureRecognizer(target: self,
                                                  action: #selector(processLongPress3(_:)))
        initialWaterSlider.addGestureRecognizer(lpRec1)
        radiusTankSlider.addGestureRecognizer(lpRec2)
        timeSlider.addGestureRecognizer(lpRec3)
        
        tankModel = TankModel()
        trajectoryModel = TrajectoryModel()
        
        trajectoryView.dataSource = self
        waterHeightTimeView.dataSource = self
        waterSpeedHeightView.dataSource = self
        
        trajectoryView.scaleX = 100
        trajectoryView.scaleY = 50
        waterHeightTimeView.scaleX = 100
        waterHeightTimeView.scaleY = 50
        waterSpeedHeightView.scaleX = 105
        waterSpeedHeightView.scaleY = 15
        
        
        trajectoryModel.originPos = (0,0.5)
        trajectoryModel.targetPos = (0.5,0)
        trajectoryModel.speed = tankModel.waterOutputSpeed(tankModel.initialWaterHeight)
        
        initialWaterSlider.sendActions(for: .valueChanged)
        radiusTankSlider.sendActions(for: .valueChanged)
        timeSlider.sendActions(for: .valueChanged)
    }

    var trajectoryTime : Double = 0.0 {
        didSet {
            waterHeightTimeView.setNeedsDisplay()
        }
    }
    
    @IBAction func initialWaterSliderAction(_ sender: UISlider) {
        tankModel.initialWaterHeight = Double(sender.value)
        AlturaDisplay.text = String(format:"%.4f",tankModel.initialWaterHeight) + " metros"
        trajectoryModel.speed = tankModel.waterOutputSpeed(tankModel.waterHeightLevel(time: trajectoryTime))
        trajectoryModel.update()

        trajectoryView.setNeedsDisplay()
        waterHeightTimeView.setNeedsDisplay()
        waterSpeedHeightView.setNeedsDisplay()
    }
    @IBAction func radiusTankSliderAction(_ sender: UISlider) {
        tankModel.tankRadio = Double(sender.value)
        RadioDisplay.text = String(format:"%.4f",tankModel.tankRadio) + " metros"
        trajectoryModel.speed = tankModel.waterOutputSpeed(tankModel.waterHeightLevel(time: trajectoryTime))
        trajectoryModel.update()
        
        trajectoryView.setNeedsDisplay()
        waterHeightTimeView.setNeedsDisplay()
        waterSpeedHeightView.setNeedsDisplay()
    }
    @IBAction func timeSliderAction(_ sender: UISlider) {
        trajectoryTime = Double (sender.value)
        tiempoDisplay.text = String(format:"%.4f",trajectoryTime) + " segundos"
        trajectoryModel.speed = tankModel.waterOutputSpeed(tankModel.waterHeightLevel(time: trajectoryTime))
        trajectoryModel.update()
        
        trajectoryView.setNeedsDisplay()
        waterHeightTimeView.setNeedsDisplay()
        waterSpeedHeightView.setNeedsDisplay()
    }
    
    
    
    func startFor(_ pfv: ParametricFunction) -> Double {
        switch pfv{
        case trajectoryView:
            return 0
            
        case waterHeightTimeView:
            return 0
            
        case waterSpeedHeightView:
            return tankModel.waterHeightLevel(time: tankModel.timeToEmpty)
            
        default:
            return 200
        }
    }
    func endFor(_ pfv: ParametricFunction) -> Double {
        switch pfv{
        case trajectoryView:
            if trajectoryModel.timeToTarget() != nil {return trajectoryModel.timeToTarget()!}
            else {return 0}
        case waterHeightTimeView:
            return tankModel.timeToEmpty
            
        case waterSpeedHeightView:
            return tankModel.initialWaterHeight

        default:
            return 200
        }
    }

    func parametricPoint(_ pfv: ParametricFunction, pointAt index: Double) -> FunctionPoint {
        
        switch pfv {
        case trajectoryView:
            return FunctionPoint(x : trajectoryModel.positionAt(time: index).x, y : trajectoryModel.positionAt(time: index).y)

        case waterHeightTimeView:
            let x = index
            let y = tankModel.waterHeightLevel(time: index)
            
            return FunctionPoint(x: x, y: y)
        case waterSpeedHeightView:
            let x = index
            let y = tankModel.waterOutputSpeed(index)
            
            return FunctionPoint(x: x, y: y)
        
        default:
            return FunctionPoint(x: 0, y: 0)
        }
        
    }
    
    @objc func processPinch1(_ sender: UIPinchGestureRecognizer) {
        let factor = sender.scale
        
        trajectoryView.transform = trajectoryView.transform.scaledBy(x: factor, y: factor)
        
        sender.scale = 1
    }
    
    @objc func processPinch2(_ sender: UIPinchGestureRecognizer) {
        let factor = sender.scale
        
        waterHeightTimeView.transform = waterHeightTimeView.transform.scaledBy(x: factor, y: factor)
        
        sender.scale = 1
    }
    
    @objc func processPinch3(_ sender: UIPinchGestureRecognizer) {
        let factor = sender.scale
        
        waterSpeedHeightView.transform = waterSpeedHeightView.transform.scaledBy(x: factor, y: factor)
        
        sender.scale = 1
    }
    @objc func processLongPress1(_ sender: UILongPressGestureRecognizer) {
        initialWaterSlider.value = initialWaterSlider.minimumValue
        initialWaterSlider.sendActions(for: .valueChanged)
    }
    
    @objc func processLongPress2(_ sender: UILongPressGestureRecognizer) {
        radiusTankSlider.value = radiusTankSlider.minimumValue
        radiusTankSlider.sendActions(for: .valueChanged)
    }
    
    @objc func processLongPress3(_ sender: UILongPressGestureRecognizer) {
        timeSlider.value = timeSlider.minimumValue
        timeSlider.sendActions(for: .valueChanged)
    }
}

