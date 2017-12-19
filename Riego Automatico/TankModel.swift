//
//  TankModel.swift
//  Riego Automatico
//
//  Created by javier  on 1/10/17.
//  Copyright © 2017 UPM. All rights reserved.
//

import Foundation

class TankModel {
    
    
    //Declaramos las variables de las ecuaciones
    
    var tankRadio = 0.8 {
        didSet {
            updateCts()
        }
    }
    
    var pipeRadio = 0.56 {
        didSet {
            updateCts()
        }
    }
    
    var initialWaterHeight = 1.0 {
        didSet {
            updateCts()
        }
    }
    
    let g : Double = 9.8
    
    private var areaTank : Double
    
    private var areaPipe : Double
    
    private var at2ap2m1 : Double
    
    private var ap2at2m1 : Double
    
    var timeToEmpty : Double
    
    
    init(){
        areaTank = Double.pi*pow(tankRadio, 2)
        areaPipe = Double.pi*pow(pipeRadio, 2)
        at2ap2m1 = pow(areaTank/areaPipe, 2)-1
        ap2at2m1 = 1-pow(areaPipe/areaTank, 2)
        
        timeToEmpty = sqrt (2*initialWaterHeight*at2ap2m1/g)
    }
    
    
    private func updateCts()  {
        areaTank = Double.pi*pow(tankRadio, 2)
        areaPipe = Double.pi*pow(pipeRadio, 2)
        at2ap2m1 = pow(areaTank/areaPipe, 2)-1
        ap2at2m1 = 1-pow(areaPipe/areaTank, 2)
        
        timeToEmpty = sqrt (2*initialWaterHeight*at2ap2m1/g)
    }
    
//    func timeToStop (_ h: Double) -> Double {
//        let c0 = initialWaterHeight
//        let c1 = sqrt(2*g*initialWaterHeight/at2ap2m1)
//        let c2 = 0.5*g/at2ap2m1
//        
//        return (c1-sqrt(c1*c1-4*c2*(c0-h)))/(2*c2)
//    }
    
    // Velocidad de salida del agua en funcion de la altura
    
    func waterOutputSpeed (_ h: Double) -> Double {
        let v = sqrt(2*g*h/at2ap2m1)
        return max(0, v)
    }
    
    //Velocidad de descenso del nivel del agua en funcion de la altura
    func waterDecreaseSpeed (_ h : Double) -> Double {
        let v = sqrt(2*g*h/(ap2at2m1))
        return max(0,v)
    }
    
    //Altura del agua en funcion del tiempo
    func waterHeightLevel (time t : Double) -> Double {
        if t > timeToEmpty {return 0}
    
        let c0 = initialWaterHeight
        let c1 = sqrt(2*g*initialWaterHeight/at2ap2m1)
        let c2 = 0.5*g/at2ap2m1
        
        return c0-c1*t+c2*t*t
        
    }
    
    
    
    
}
