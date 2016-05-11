//
//  PreferencesViewController.swift
//  Japa Progress
//

import UIKit



//TODO: save current steps count into preferences too and add a button to reset them...



let stepsInRoundPrefKey = "stepsInRoundPrefKey"
let stepsInRoundDefault = 108

class PreferencesViewController: UIViewController
  {
  @IBOutlet var japaTargetLabel: UILabel?
  @IBOutlet var japaTargetStepper: UIStepper?
  
  var stepsInRound: Int = 1//taken from preferences in initializer
  
  required init?(coder aDecoder: NSCoder)
    {
    //custom initialization
    
    super.init(coder: aDecoder)
    }
  
  override func viewDidLoad()
    {
    super.viewDidLoad()
    
    readPrefs()
    updateUIControls()
    }
  
  func readPrefs()
    {
    let pref = NSUserDefaults.standardUserDefaults()
    stepsInRound = pref.integerForKey(stepsInRoundPrefKey)
    }
  
  @IBAction func saveChanges(sender: AnyObject)
    {
    saveChangesToPrefs()
    performSegueWithIdentifier("unwindToMainViewController", sender: self);
    }
  
  func saveChangesToPrefs()
    {
    let pref = NSUserDefaults.standardUserDefaults()
    pref.setValue(stepsInRound, forKey: stepsInRoundPrefKey)
    }
  
  @IBAction func japaTargerChanged(stepper: UIStepper)
    {
    stepsInRound = Int(stepper.value)
    updateUIControls()
    }
  
  func updateUIControls()
    {
    japaTargetStepper!.value = Double(stepsInRound)
    japaTargetLabel!.text = "\(stepsInRound)"
    }
  }
