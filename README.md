# ApplicationCoordinator
Based on the post about Application Coordinators [khanlou.com](http://khanlou.com/2015/10/coordinators-redux/) and Application Controller pattern description [martinfowler.com](http://martinfowler.com/eaaCatalog/applicationController.html).
My example provides very basic structure with 3 controllers and 3 coordinators.
![](/str.jpg)

I created a protocol for coordinators:
```swift
@objc protocol Coordinatable {
    
    var childCoorditators: [Coordinatable] {get}
    optional var completionHandler:CompletionBlock? {get set}
    init(rootController: UINavigationController)
    func start()
}
```
And a protocol for controllers:
```swift
protocol Controllerable: NSObjectProtocol {
    typealias T
    var completionHandler: (T -> ())? {get set}
}
```
All controllers and coordinators have optional completionHandlers.
```swift
var completionHandler: (T -> ())?
```
The main Application Coordinator stores dependancies of child coordinators
```swift
private(set) lazy var childCoorditators = [Coordinatable]()
```
