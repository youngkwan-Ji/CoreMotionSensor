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
}

class CoreMotionManager{
    let device = UIDevice.current
    let manager = CMMotionManager.init()
    var delegate : CoreMotionSensorDelegate?
    
    init() {
        device.isProximityMonitoringEnabled = true // 근접센서 온오프
        manager.deviceMotionUpdateInterval = 1/1 // 센서 정밀도
    }
    
    func startMotionCheck(){
        if manager.isDeviceMotionAvailable{
            manager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: {(motion , err) -> Void in
                if let userMotion = motion?.userAcceleration{
                    self.updatedUserAcceleration(userMotion: userMotion)
                }
                if let gravityMotion = motion?.gravity {
                    self.updatedGravity(gravityMotion: gravityMotion)
                }
                if let rotationMotion = motion?.rotationRate{
                    self.updatedRotationRate(rotationMotion: rotationMotion)
                }
                if let attitudeMotion = motion?.attitude{
                    self.updatedAttitude(attitudeMotion: attitudeMotion)
                }
            })
        }else{
            let alert = UIAlertController.init(title: nil, message: "Unavailable DeviceMotion", preferredStyle: .alert)
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func stopMotionCheck(){
        manager.stopDeviceMotionUpdates()
    }
}

extension CoreMotionManager : CoreMotionSensorDelegate {
    func updatedUserAcceleration(userMotion: CMAcceleration) {
        delegate?.updatedUserAcceleration(userMotion: userMotion)
    }
    
    func updatedGravity(gravityMotion: CMAcceleration) {
        delegate?.updatedGravity(gravityMotion: gravityMotion)
    }
    
    func updatedRotationRate(rotationMotion: CMRotationRate) {
        delegate?.updatedRotationRate(rotationMotion: rotationMotion)
    }
    
    func updatedAttitude(attitudeMotion: CMAttitude) {
        delegate?.updatedAttitude(attitudeMotion: attitudeMotion)
    }
}
