//
//  ViewController.swift
//  WalkingPattern
//
//  Created by 영관 on 2017. 10. 24..
//  Copyright © 2017년 영관. All rights reserved.
//

import UIKit
import CoreMotion

class SensorViewController: UIViewController {
    @IBOutlet weak var lbluserZ: UILabel! // 사용자 가속도
    @IBOutlet weak var lbluserY: UILabel!
    @IBOutlet weak var lbluserX: UILabel!
    @IBOutlet weak var lblgravityX: UILabel! // 중력 벡터
    @IBOutlet weak var lblgravityY: UILabel!
    @IBOutlet weak var lblgravityZ: UILabel!
    @IBOutlet weak var lblrotationX: UILabel! // 회전 속도
    @IBOutlet weak var lblrotationY: UILabel!
    @IBOutlet weak var lblrotationZ: UILabel!
    @IBOutlet weak var lblattitudeX: UILabel! // 장치방향
    @IBOutlet weak var lblattitudeY: UILabel!
    @IBOutlet weak var lblattitudeZ: UILabel!
    @IBOutlet weak var lblProximity: UILabel! // 근접 센서
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnEnd: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    
    var checkInfo : Timer?
    let fileManager = FileManager.default
    
    var dataString = "근접센서on/off , 사용자가속도x,y,z , 중력벡터x,y,z , 회전속도x,y,z , 장치방향roll,pitch,yaw\n"
    var startDate = ""
    var endDate = ""
    
    let CMManager : CoreMotionManager = CoreMotionManager.init()
    var sensing : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CMManager.delegate = self
    }
    
    //MARK: - IBActions
    @IBAction func sensingAction(_ sender: UIButton) {
        if !sensing {
            if CMManager.startMotionCheck(){
                CMManager.startProximityCheck()
                setLogDateTime()
            
                sender.setTitle("stop", for: .normal)
                lblStatus.text = "sensing"
            }else{
                return
            }
        }else{
            CMManager.stopMotionCheck()
            CMManager.stopProximityCheck()
            setLogDateTime()
            
            sender.setTitle("start", for: .normal)
            lblStatus.text = "stop"
            lbluserZ.text = "0"
            lbluserY.text = "0"
            lbluserX.text = "0"
            lblgravityX.text = "0"
            lblgravityY.text = "0"
            lblgravityZ.text = "0"
            lblrotationX.text = "0"
            lblrotationY.text = "0"
            lblrotationZ.text = "0"
            lblattitudeX.text = "0"
            lblattitudeY.text = "0"
            lblattitudeZ.text = "0"
            lblProximity.text = "0"
            dataString = "근접센서on/off , 사용자가속도x,y,z , 중력벡터x,y,z , 회전속도x,y,z , 장치방향roll,pitch,yaw\n"
            
            writeTextFile(startDate + "~" + endDate, dataString)
        }
        
        sensing = !sensing
    }
    
    @IBAction func helpViewAction (_ sender : UIButton) {
        let alert = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "확인", style: .cancel, handler: nil)
        alert.addAction(action)
        
        switch sender.tag {
        case 1:
            alert.title = "사용자가 기기에 가하는 가속도입니다."
        case 2:
            alert.title = "중력이 작용하는 방향으로 -g 만큼의 값을 출력합니다."
        case 3:
            alert.title = "장치의 회전 속도입니다."
        case 4:
            alert.title = "기울기 각도 값입니다. x = roll , y = pitch , z = yaw 를 나타냅니다."
        case 5 :
            alert.title = "근접센서의 상태입니다. (근접센서가 반응해서 화면이 꺼진 상태가 true입니다)"
        default:
            return
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Functions
    func writeTextFile(_ date : String, _ info : String){
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let filePath = dirPath.appendingPathComponent(date + ".txt")
        let infoData = info.data(using: String.Encoding.utf8)
        
        if fileManager.createFile(atPath: filePath, contents: infoData, attributes: nil){
            
        }
    }
    
    func setLogDateTime(){
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        if sensing {
            self.startDate = dateFormatter.string(from: nowDate)
        }else{
            self.endDate = dateFormatter.string(from: nowDate)
        }
    }
}


//MARK: - CoreMotionSensorDelegate
extension SensorViewController : CoreMotionSensorDelegate{
    func updatedMotion(motion: CMDeviceMotion) {
        dataString = dataString + "\(lblProximity.text!), \(lbluserX.text!), \(lbluserY.text!), \(lbluserZ.text!), \(lblgravityX.text!), \(lblgravityY.text!), \(lblgravityZ.text!), \(lblrotationX.text!), \(lblrotationY.text!), \(lblrotationZ.text!), \(lblattitudeX.text!), \(lblattitudeY.text!), \(lblattitudeZ.text!)\n"
    }
    
    func updatedUserAcceleration(userMotion: CMAcceleration) {
        lbluserX.text = (String)(userMotion.x)
        lbluserY.text = (String)(userMotion.y)
        lbluserZ.text = (String)(userMotion.z)
    }
    
    func updatedGravity(gravityMotion: CMAcceleration) {
        lblgravityX.text = (String)(gravityMotion.x)
        lblgravityY.text = (String)(gravityMotion.y)
        lblgravityZ.text = (String)(gravityMotion.z)
    }
    
    func updatedRotationRate(rotationMotion: CMRotationRate) {
        lblrotationX.text = (String)(rotationMotion.x)
        lblrotationY.text = (String)(rotationMotion.y)
        lblrotationZ.text = (String)(rotationMotion.z)
    }
    
    func updatedAttitude(attitudeMotion: CMAttitude) {
        lblattitudeX.text = (String)(attitudeMotion.roll)
        lblattitudeY.text = (String)(attitudeMotion.pitch)
        lblattitudeZ.text = (String)(attitudeMotion.yaw)
    }
    
    func updatedProximity(state: Bool) {
        if state{
            lblProximity.text = "1"
        }else{
            lblProximity.text = "0"
        }
    }
}
