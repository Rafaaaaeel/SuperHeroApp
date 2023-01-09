
public protocol CodableViews {
    func setup()
    func setupHiearchy()
    func setupContraints()
    func additional()
}

extension CodableViews{
    func setup(){
        setupHiearchy()
        setupContraints()
        additional()
    }
    
    func additional() { }
}
