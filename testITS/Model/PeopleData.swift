import Foundation

struct PeopleData: Codable {
    var peopleList: [PeopleList]
}

struct PeopleList: Codable {
    var name: String
    var gender: String
    var age: Int
    var company: String
    var email: String
    var phone: String
    var about: String
    var address: String
    var latitude: Double
    var longitude: Double
}
