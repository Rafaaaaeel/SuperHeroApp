import SDWebImage

class HomePresenter {
    
    private var repository: HomeRepository
    private var data: ResponseModel?
    weak var view: HomeViewController?
    
    init(repository: HomeRepository = HomeRepository()) {
        self.repository = repository
    }
    
    
}

extension HomePresenter {
    func fetchData(endpoint: Endpoint) {
        repository.fetchData(endpoint: endpoint) { [weak self] result in
            switch result {
            case .success(let success):
                self?.data = success
                self?.data?.data.results[0].thumbnail.selectImageSize(size: .portraitFantastic)
                let url = self?.data?.data.results[0].thumbnail.imageURL!
                self?.view?.imageView.sd_setImage(with: url)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
}
