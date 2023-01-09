import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var presenter: HomePresenter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    init(presenter: HomePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HomeViewController: CodableViews {
    func setupHiearchy() {
        view.addSubview(imageView)
    }
    
    func setupContraints() {
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(300)
            make.width.equalTo(200)
        }
    }
    
    func additional() {
        self.view.backgroundColor = .systemBackground
        self.presenter.view = self
        presenter.fetchData(endpoint: .characters)
    }
    
    
}
