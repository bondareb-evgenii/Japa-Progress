//
//  ViewController.swif
//  Japa Progress
//

import UIKit
import AudioToolbox


//TODO: implement hardware +/- buttons use!!!

@objc(ViewController) class ViewController: UIViewController
  {
  
  @IBOutlet var japaTargetLabel: UILabel
  @IBOutlet var japaRoundCountLabel: UILabel
  @IBOutlet var japaStepCountLabel: UILabel
  
  var japaStepCount: Int = 0
  var stepsInRound: Int = 1//taken from preferences in initializer
  
  init(coder aDecoder: NSCoder!)
    {
    //custom initialization
      
    super.init(coder: aDecoder)
    }
  
  override func viewDidLoad()
    {
    super.viewDidLoad()
    
    readPrefs()
    updateJapaLabels()
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
    japaTargetLabel.text = "\(stepsInRound)"
    japaRoundCountLabel.text = "\(japaStepCount/stepsInRound)"
    japaStepCountLabel.text = "\(japaStepCount%stepsInRound)"
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
    ++japaStepCount
    updateJapaLabels()
    vibrateIfNeeded()
    }

  @IBAction func unwindToMainViewController(segue: UIStoryboardSegue)
    {
    readPrefs()
    updateJapaLabels()
    }

}

