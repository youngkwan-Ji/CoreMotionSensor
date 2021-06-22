//
//  FileListViewController.swift
//  WalkingPattern
//
//  Created by youngkwanji on 2021/05/07.
//  Copyright © 2021 영관. All rights reserved.
//

import UIKit

class FileListViewController: UIViewController {

    @IBOutlet weak var tbvFile: UITableView!
    let fileManager = FileManager.default
    
    var fileList : [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "수집데이터 목록"
        tbvFile.dataSource = self
        tbvFile.delegate = self
        
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            fileList = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            tbvFile.reloadData()
            
        } catch {
            print("\(documentsURL.path): \(error.localizedDescription)")
        }
        
        tbvFile.reloadData()
    }

}

extension FileListViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseString = "Cell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseString)
        if cell == nil {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseString)
            cell = tableView.dequeueReusableCell(withIdentifier: reuseString)
        }
        
        cell!.textLabel?.text = fileList[indexPath.row].lastPathComponent
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var filesToShare = [Any]()
        filesToShare.append(fileList[indexPath.row])
        
        let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
}
