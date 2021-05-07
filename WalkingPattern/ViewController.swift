//
//  ViewController.swift
//  WalkingPattern
//
//  Created by 영관 on 2017. 10. 24..
//  Copyright © 2017년 영관. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

	@IBOutlet weak var lbluserZ: UILabel! // 사용자 가속도
	@IBOutlet weak var lbluserY: UILabel!
	@IBOutlet weak var lbluserX: UILabel!
	@IBOutlet weak var lblgravityX: UILabel! // 중력 벡터
	@IBOutlet weak var lblgravityY: UILabel!
	@IBOutlet weak var lblgravityZ: UILabel!
	@IBOutlet weak var lblrotationX: UILabel! // 회전 속도
	@IBOutlet weak var lblrotationY: UILabel!
	@IBOutlet weak var lblrotationZ: UILabel!
	@IBOutlet weak var lblattitudeX: UILabel! // 장치방향 (몸의 방향
	@IBOutlet weak var lblattitudeY: UILabel!
	@IBOutlet weak var lblattitudeZ: UILabel!
	@IBOutlet weak var lblProximity: UILabel! // 근접 센서
	@IBOutlet weak var lblStatus: UILabel!
	@IBOutlet weak var btnEnd: UIButton!
	@IBOutlet weak var btnStart: UIButton!
	

	let myDevice = UIDevice.current
	var checkInfo : Timer?
	let manager = CMMotionManager.init()
	let fileManager = FileManager.default
	
	var dataString = "근접센서on/off , 사용자가속도x,y,z , 중력벡터x,y,z , 회전속도x,y,z , 장치방향roll,pitch,yaw\n"
	var startDate = ""
	var endDate = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		myDevice.isProximityMonitoringEnabled = true // 근접센서 온오프
		manager.deviceMotionUpdateInterval = 1/1 // 센서 정밀도
	}
	
	@IBAction func startAction(_ sender: UIButton) {
		if self.lblStatus.text == "기록중....."{
			let alert = UIAlertController.init(title: "데이터를 기록중입니다.", message: "", preferredStyle: .alert)
			let action = UIAlertAction.init(title: "확인", style: .cancel, handler: nil)
			alert.addAction(action)
			self.present(alert, animated: true, completion: nil)
		}else{
			self.motionCheck()
			checkInfo = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(proximityCheck), userInfo: nil, repeats: true)
			checkInfo?.fire()
			self.nowDateSet("시작")
		}
		self.lblStatus.text = "기록중....."
	}
	
	@IBAction func endAction(_ sender: UIButton) {
		if self.lblStatus.text! == "기록중....."{
			checkInfo!.invalidate()
			self.manager.stopDeviceMotionUpdates()
			self.nowDateSet("종료")
			self.writeTextFile(self.startDate + " ~ " + self.endDate, self.dataString)
			self.lblStatus.text = "대기중"
			self.lbluserZ.text = "0"
			self.lbluserY.text = "0"
			self.lbluserX.text = "0"
			self.lblgravityX.text = "0"
			self.lblgravityY.text = "0"
			self.lblgravityZ.text = "0"
			self.lblrotationX.text = "0"
			self.lblrotationY.text = "0"
			self.lblrotationZ.text = "0"
			self.lblattitudeX.text = "0"
			self.lblattitudeY.text = "0"
			self.lblattitudeZ.text = "0"
			self.lblProximity.text = "0"
			self.dataString = "근접센서on/off , 사용자가속도x,y,z , 중력벡터x,y,z , 회전속도x,y,z , 장치방향roll,pitch,yaw\n"
			
		}else{
			let alert = UIAlertController.init(title: "시작을 먼저 눌러주세요.", message: "", preferredStyle: .alert)
			let action = UIAlertAction.init(title: "확인", style: .cancel, handler: nil)
			alert.addAction(action)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func motionCheck() {
		if manager.isDeviceMotionAvailable{
			manager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: {(motion , err) -> Void in
				if let userMotion = motion?.userAcceleration{
					self.lbluserX.text = (String)(userMotion.x)
					self.lbluserY.text = (String)(userMotion.y)
					self.lbluserZ.text = (String)(userMotion.z)
				}
				if let gravityMotion = motion?.gravity {
					self.lblgravityX.text = (String)(gravityMotion.x)
					self.lblgravityY.text = (String)(gravityMotion.y)
					self.lblgravityZ.text = (String)(gravityMotion.z)
				}
				if let rotationMotion = motion?.rotationRate{
					self.lblrotationX.text = (String)(rotationMotion.x)
					self.lblrotationY.text = (String)(rotationMotion.y)
					self.lblrotationZ.text = (String)(rotationMotion.z)
				}
				if let attitudeMotion = motion?.attitude{
					self.lblattitudeX.text = (String)(attitudeMotion.roll)
					self.lblattitudeY.text = (String)(attitudeMotion.pitch)
					self.lblattitudeZ.text = (String)(attitudeMotion.yaw)
				}
				self.dataString = self.dataString + "\(self.lblProximity.text!), \(self.lbluserX.text!), \(self.lbluserY.text!), \(self.lbluserZ.text!), \(self.lblgravityX.text!), \(self.lblgravityY.text!), \(self.lblgravityZ.text!), \(self.lblrotationX.text!), \(self.lblrotationY.text!), \(self.lblrotationZ.text!), \(self.lblattitudeX.text!), \(self.lblattitudeY.text!), \(self.lblattitudeZ.text!)\n"
			})
		}
	}
	
	func writeTextFile(_ date : String, _ info : String){
		let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
		let filePath = dirPath.appendingPathComponent(date + ".txt")
		let infoData = info.data(using: String.Encoding.utf8)
		
		if fileManager.createFile(atPath: filePath, contents: infoData, attributes: nil){
			
		}
	
		print(dirPath)
		print(filePath)
	}
	
	@IBAction func helpViewAction (_ sender : UIButton) {
		let alert = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
		let action = UIAlertAction.init(title: "확인", style: .cancel, handler: nil)
		alert.addAction(action)
		
		switch sender.tag {
			
			case 1:
				alert.title = "사용자가 기기에 제공하는 가속도입니다."
			case 2:
				alert.title = "중력이 작용하는 방향으로 -g 만큼의 값을 출력합니다."
			case 3:
				alert.title = "장치의 회전 속도입니다."
			case 4:
				alert.title = "기울기 각도 값입니다. x = roll , y = pitch , z = yaw 를 나타냅니다."
			case 5 :
				alert.title = "근접센서의 상태입니다. 1 = true , 0 = false 입니다 (근접센서가 반응해서 화면이 꺼진 상태가 true입니다)"
			
			default:
				print("디폴트")
		}
	
		self.present(alert, animated: true, completion: nil)
		
	}
	
	func nowDateSet(_ str : String){
		let nowDate = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		dateFormatter.locale = Locale(identifier: "ko_KR")
		
		if str == "시작"{
			self.startDate = dateFormatter.string(from: nowDate)
		}else{
			self.endDate = dateFormatter.string(from: nowDate)
		}
	}
	
	@objc func proximityCheck() {
		if myDevice.proximityState{
			self.lblProximity.text = "1"
		}else{
			self.lblProximity.text = "0"
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

