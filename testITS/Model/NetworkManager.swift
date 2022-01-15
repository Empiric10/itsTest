import Foundation
import UIKit

protocol NetworkManagerDelegate {
    func didGetPeople(data : [PeopleList])
    func didFailWithError(error : Error)
}
struct NetworkManager {
    var networkDelegate : NetworkManagerDelegate?
}
extension NetworkManager {
    
    func fetchData(){
        let jsonData = readLocalJSONFile(forName: "generated-2")
        if let data = jsonData {
            if let people = parseJson(data){
                DispatchQueue.main.async {
                    networkDelegate?.didGetPeople(data: people)
                }
            }
        }
    }
    
    func parseJson(_ people : Data) -> [PeopleList]?{
        let decoder = JSONDecoder()
        
        do{
            let decodedData =  try decoder.decode([PeopleList].self, from: people)
            let data = decodedData
            return data
        } catch {
            networkDelegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
}
