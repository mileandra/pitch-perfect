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
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recordedAudio.filePathUrl, error: nil)
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
        playVariableAudio(1.0, rate: 0.5)
    }
    
    @IBAction func playFast(sender: UIButton) {
        playVariableAudio(1.0, rate: 2.0)
    }
    
    @IBAction func playSquirrel(sender: UIButton) {
        playVariableAudio(1000.0, rate: 1.0)
    }
    
    @IBAction func playVader(sender: UIButton) {
        playVariableAudio(-1000.0, rate: 1.0)
    }
    
    @IBAction func stopPlaying(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
    }
    
    /**
        Heart of the player - alter pitch and/or rate
        
        :param: pitch default 1.0
        :param: rate  default 1.0
    */
    func playVariableAudio(pitch: Float, rate: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        changePitchEffect.rate = rate
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
}
