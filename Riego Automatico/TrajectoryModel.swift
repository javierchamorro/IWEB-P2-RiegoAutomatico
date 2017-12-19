//
//  TrajectoryModel.swift
//  Riego Automatico
//
//  Created by javier  on 1/10/17.
//  Copyright © 2017 UPM. All rights reserved.
//

import Foundation

class TrajectoryModel{
    
    //Posiciones inicial y del objetivo
    var originPos = (x:0.0 , y:0.0) {
        didSet{
            update()
        }
    }
    var targetPos = (x:0.0 , y: 0.0) {
        didSet{
            update()
        }
    }
    
    //Velocidad inicial
    var speed : Double = 0.0 {
        didSet {
            update()
        }
    }
    let g : Double = 9.8
    
    //Variables privadas, solo accesibles en esta clase y dependientes de las tres variables anteriores
    var angle : Double
    var speedX : Double
    var speedY : Double
    var maxh : Double
    var xf : Double
    var yf :Double
    //Funcion de actualizacion de las variables
    func update() {
        
        xf = targetPos.x - originPos.x
        yf = targetPos.y - originPos.y
        
        angle = atan (((speed * speed) + sqrt(pow(speed,4) - pow(g * xf,2)-(2 * g * yf * speed * speed))) / (g * xf))

        speedX = speed * cos(angle)
        speedY = speed * sin(angle)
        
        maxh = speedY*speedY/(2*g)
    }
    init() {
        xf = targetPos.x - originPos.x
        yf = targetPos.y - originPos.y
        
        angle = atan (((speed * speed) + sqrt(pow(speed,4) - pow(g * xf,2)-(2 * g * yf * speed * speed))) / (g * xf))
        
        speedX = speed * cos(angle)
        speedY = speed * sin(angle)
        
        maxh = speedY*speedY/(2*g)
        
    }
    //Tiempo que tarda en alcanzar el objetivo
    func timeToTarget() ->  Double?{
        
        let t = (targetPos.x-originPos.x)/speedX
        return t.isNormal ? t : nil
    }
    
    //Posicion en un momento dado
    
    func positionAt (time t: Double) -> (x: Double , y: Double){
        
        let x = originPos.x + speedX*t
        let y = originPos.y + speedY*t - 0.5*g*t*t
        return (x,y)
    }
}
