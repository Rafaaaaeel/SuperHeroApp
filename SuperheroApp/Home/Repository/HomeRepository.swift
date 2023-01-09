protocol HomeRepositoryOutputProtocol {
    func fetchData(endpoint: Endpoint, completion: @escaping (Result<ResponseModel, APIError>) -> ())
}

class HomeRepository {
    let apiService: APIClient
    
    init(service: APIClient = APIClient.shared) {
        self.apiService = service
    }
}

extension HomeRepository: HomeRepositoryOutputProtocol {
    func fetchData(endpoint: Endpoint, completion: @escaping (Result<ResponseModel, APIError>) -> ()) {
        apiService.requestDataFrom(endpoint: endpoint, completion: completion)
    }
}
