class TermsController: UIViewController, TermsView {
  
  var confirmed = false
  
  @IBAction func termsSwitchValueChanged(_ sender: UISwitch) {
    confirmed = sender.isOn
  }
}
