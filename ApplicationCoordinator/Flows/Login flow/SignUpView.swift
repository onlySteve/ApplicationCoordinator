protocol SignUpView: BaseView {
  
  var onSignUpComplete: (() -> ())? { get set }
  var onTermsButtonTap: (() -> ())? { get set }
  
  func conformTermsAgreement(_ agree: Bool)
}
