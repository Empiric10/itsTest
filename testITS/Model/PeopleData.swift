import Foundation

struct PeopleData: Codable {
    var peopleList: [PeopleList]
}

struct PeopleList: Codable {
    var name: String
    var gender: String
    var age: Int
}
