//
//  ViewController.swift
//  Audio Player
//
//  Created by Guilherme Henrique Crozariol on 2016-12-27.
//  Copyright © 2016 Lion. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var timer = Timer()
    var player = AVAudioPlayer()
    let audioPath = Bundle.main.path(forResource: "nao_estou_normal", ofType: "mp3")
    
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var labelRemaining: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var scrubber: UISlider!
    
    @objc func updateScrubber() {
        scrubber.value = Float(player.currentTime)
    }
    
    @objc func updateTimeLabels() {
        
        let currentMinute = Int(player.currentTime / 60)
        let currentSecond = Int(player.currentTime.truncatingRemainder(dividingBy: 60))
        
        if currentSecond >= 10 {
            labelDuration.text = "\(currentMinute):\(currentSecond)"
        } else {
            labelDuration.text = "\(currentMinute):0\(currentSecond)"
        }
        
    }
    
    @IBAction func scrubberMoved(_ sender: Any) {
        player.currentTime = TimeInterval(scrubber.value)
        updateScrubber()
        updateTimeLabels()
    }
    
    @IBAction func sliderMoved(_ sender: Any) {
        player.volume = slider.value
    }
    
    @IBAction func play(_ sender: Any) {
        player.play()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.updateScrubber), userInfo: nil, repeats: true)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateTimeLabels), userInfo: nil, repeats: true)
    }
    
    @IBAction func pause(_ sender: Any) {
        player.pause()
        timer.invalidate()
    }

    @IBAction func stop(_ sender: Any) {
        updateScrubber()
        updateTimeLabels()
        timer.invalidate()
        player.pause()
        player.currentTime = 0
    }
    
    @IBAction func forward(_ sender: Any) {
        player.currentTime += 5
    }
    
    @IBAction func backward(_ sender: Any) {
        player.currentTime -= 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
            scrubber.maximumValue = Float(player.duration)
            updateTimeLabels()
            
        } catch {
            
            // Process some error that might occur
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
