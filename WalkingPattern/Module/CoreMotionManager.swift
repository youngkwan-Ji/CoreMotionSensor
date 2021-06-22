//
//  CoreMotionManager.swift
//  WalkingPattern
//
//  Created by youngkwanji on 2021/05/07.
//  Copyright © 2021 영관. All rights reserved.
//

import UIKit
import Foundation
import CoreMotion

protocol CoreMotionSensorDelegate {
    func updatedUserAcceleration(userMotion : CMAcceleration)
    func updatedGravity(gravityMotion : CMAcceleration)
    func updatedRotationRate(rotationMotion : CMRotationRate)
    func updatedAttitude(attitudeMotion : CMAttitude)
    func updatedProximity(state : Bool)
}

class CoreMotionManager{
    let device = UIDevice.current
    let manager = CMMotionManager.init()
    var proximityCheckTimer : Timer?
    var proximityCheckInterval : Int?
    var delegate : CoreMotionSensorDelegate?
    
    init() {
        device.isProximityMonitoringEnabled = true // 근접센서 OnOff
        manager.deviceMotionUpdateInterval = 1/1 // 센서 정밀도
    }
    
    func startMotionCheck() -> Bool{
        if manager.isDeviceMotionAvailable{
            manager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: {(motion , err) -> Void in
                if let userMotion = motion?.userAcceleration{
                    self.delegate?.updatedUserAcceleration(userMotion: userMotion)
                }
                if let gravityMotion = motion?.gravity {
                    self.delegate?.updatedGravity(gravityMotion: gravityMotion)
                }
                if let rotationMotion = motion?.rotationRate{
                    self.delegate?.updatedRotationRate(rotationMotion: rotationMotion)
                }
                if let attitudeMotion = motion?.attitude{
                    self.delegate?.updatedAttitude(attitudeMotion: attitudeMotion)
                }
            })
            return true
        }else{
            let alert = UIAlertController.init(title: nil, message: "Unavailable DeviceMotion", preferredStyle: .alert)
            alert.addAction(.init(title: "확인", style: .cancel, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            return false
        }
    }
    
    func stopMotionCheck(){
        manager.stopDeviceMotionUpdates()
    }
    
    func startProximityCheck(){
        proximityCheckTimer = Timer.scheduledTimer(timeInterval: TimeInterval(proximityCheckInterval ?? 1), target: self, selector: #selector(proximityCheck), userInfo: nil, repeats: true)
        proximityCheckTimer?.fire()
    }
    
    func stopProximityCheck(){
        proximityCheckTimer?.invalidate()
    }
    
    @objc func proximityCheck() {
        delegate?.updatedProximity(state: device.proximityState)
    }
}
