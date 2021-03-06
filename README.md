# ApplicationCoordinator
A lot of developers need to change navigation flow frequently, because it depends on business tasks. And they spend a huge amount of time for re-writing code. In this approach, I demonstrate our implementation of Coordinators, the creation of a protocol-oriented, testable architecture written on pure Swift without the downcast and, also to avoid the violation of the S.O.L.I.D. principles.

Based on the post about Application Coordinators [khanlou.com](http://khanlou.com/2015/10/coordinators-redux/) and Application Controller pattern description [martinfowler.com](http://martinfowler.com/eaaCatalog/applicationController.html).

My presentation and problem’s explanation: [speakerdeck.com](https://speakerdeck.com/andreypanov/introducing-application-coordinators)

Example provides very basic structure with 6 controllers and 5 coordinators with mock data and logic.
![](/str.jpg)

I used a protocol for coordinators in this example:
```swift
protocol Coordinatable: class {
    func start()
}
```
All flow controllers have a protocols (we need to configure blocks and handle callbacks in coordinators):
```swift
protocol ItemsListView: BaseView {
    var authNeed: (() -> ())? { get set }
    var onItemSelect: (ItemList -> ())? { get set }
    var onCreateButtonTap: (() -> ())? { get set }
}
```
In this example I use factories for creating  coordinators and controllers (we can mock them in tests).
```swift
protocol CoordinatorFactory {
    func makeItemCoordinator(navController navController: UINavigationController?) -> Coordinator
    func makeItemCoordinator() -> Coordinator
    
    func makeItemCreationCoordinatorBox(navController: UINavigationController?) ->
        (configurator: Coordinator & ItemCreateCoordinatorOutput,
        toPresent: Presentable?)
}
```
The base coordinator stores dependencies of child coordinators
```swift
class BaseCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []

    func start() {
        assertionFailure("must be overriden")
    }
    
    // add only unique object
    func addDependency(_ coordinator: Coordinator) {
        
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: Coordinator?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
            else { return }
        
        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
```
AppDelegate store lazy reference for the Application Coordinator
```swift
fileprivate lazy var applicationCoordinator: Coordinator = self.makeCoordinator()()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        applicationCoordinator.start()
        return true
    }
    
    fileprivate func makeCoordinator() -> (() -> Coordinator) {
        return {
            return ApplicationCoordinator(tabbarView: self.window!.rootViewController as! TabbarView,
                                          coordinatorFactory: CoordinatorFactoryImp())
        }
    }
```
