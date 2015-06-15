//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Julia Will on 13.06.15.
//  Copyright (c) 2015 Julia Will. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view.
    }

    
    func recordedAudio(newAudio: RecordedAudio) {
        recordedAudio = newAudio
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl, error: &error)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlow(sender: UIButton) {
        audioPlayer.enableRate = true
        audioPlayer.rate = 0.5
        _playAudio()
    }
    
    @IBAction func playFast(sender: UIButton) {
        audioPlayer.enableRate = true
        audioPlayer.rate = 2.0
        _playAudio()
    }
    
    @IBAction func stopPlaying(sender: UIButton) {
        audioPlayer.stop()
        
    }
    
    func _playAudio() {
        audioPlayer.stop()
        audioPlayer.prepareToPlay()
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
