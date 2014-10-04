//
//  ViewController.swif
//  Japa Progress
//

import UIKit
import AVFoundation


//TODO: implement hardware +/- buttons use!!!

@objc(ViewController) class ViewController: UIViewController
  {
  
  @IBOutlet var japaTargetLabel: UILabel?
  @IBOutlet var japaRoundCountLabel: UILabel?
  @IBOutlet var japaStepCountLabel: UILabel?
  
  var japaStepCount: Int = 0
  var stepsInRound: Int = 1//taken from preferences in initializer
  
  required init(coder aDecoder: NSCoder)
    {
    //custom initialization
      
    super.init(coder: aDecoder)
    }
  
  override func viewDidLoad()
    {
    super.viewDidLoad()
    
    readPrefs()
    updateJapaLabels()
    
    //listen to hardware volume buttons
    AVAudioSession.sharedInstance().setActive(true, error: nil)
    AVAudioSession.sharedInstance().addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.New, context: nil)
    }
  
  func readPrefs()
    {
    let pref = NSUserDefaults.standardUserDefaults()
    stepsInRound = pref.integerForKey(stepsInRoundPrefKey)
    }

  override func didReceiveMemoryWarning()
    {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }

  func updateJapaLabels()
    {
    japaTargetLabel!.text = "\(stepsInRound)"
    japaRoundCountLabel!.text = "\(japaStepCount/stepsInRound)"
    japaStepCountLabel!.text = "\(japaStepCount%stepsInRound)"
    }
  
  func vibrateIfNeeded()
    {
    if japaStepCount != 0 && japaStepCount%stepsInRound == 0
      {
      vibrate()
      }
    }
  
  func vibrate()
    {
    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
  
  @IBAction func addJapaStep(sender: AnyObject)
    {
    addJapaStep()
    }
    
  func addJapaStep()
    {
    ++japaStepCount
    updateJapaLabels()
    vibrateIfNeeded()
    }
    
  override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<Void>)
    {
    addJapaStep()
    }

  @IBAction func unwindToMainViewController(segue: UIStoryboardSegue)
    {
    readPrefs()
    updateJapaLabels()
    }

}

