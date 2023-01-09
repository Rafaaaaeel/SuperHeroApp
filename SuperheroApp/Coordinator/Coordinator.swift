import UIKit

protocol Coordinator{
    var navigationController: UINavigationController? { get set }
    func start() -> UIViewController
}


protocol Coordinating{
    var coordinator: Coordinator? { get set }
}
