class SecretManager{
    private var clientID : String  = ""
    private var clientSecret : String = ""
    
    init(){
        clientID = "24"
        clientSecret = "r-1_mpNL4frluWzn1X29uSoF4-azWnLP"
    }
    
    func getClientID() -> String {
        return clientID
    }
    
    func getClientSecret() -> String {
        return clientSecret
    }
}
