import UIKit

class ApplicationCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    func start() -> UIViewController {
        return setupViewController()
    }
    
    private func setupViewController() -> UIViewController{
        let presenter = HomePresenter()
        return HomeViewController(presenter: presenter)
    }
    
    
}
