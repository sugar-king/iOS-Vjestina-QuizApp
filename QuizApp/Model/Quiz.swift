struct Quiz : Codable {

    let id: Int
    let title: String
    let description: String
    let category: QuizCategory
    let level: Int
    let imageUrl: String
    let questions: [Question]
    
    enum CodingKeys : String, CodingKey {
        case id
        case title
        case description
        case category
        case level
        case imageUrl = "image"
        case questions
    }

}
