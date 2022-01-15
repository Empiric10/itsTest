import Foundation
import UIKit

class MainViewModel : NSObject{
    
    var dataArray = Bindable<[PeopleList]>([])
    
    var networkManager = NetworkManager()
    
    override init(){
        super.init()
        networkManager.networkDelegate = self
    }
    
    func getData(){
        self.networkManager.fetchData()
    }
    
    func filterGenderArray(array: [PeopleList], condition: String) -> [PeopleList]{
        array.filter { man in
            return man.gender == condition
        }
    }
}

extension MainViewModel: NetworkManagerDelegate {
    func didGetPeople(data: [PeopleList]) {
        self.dataArray.value = data.sorted(by: { age1, age2  in
            age1.age < age2.age
        })
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
