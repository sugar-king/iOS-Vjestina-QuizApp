class DataService: DataServiceProtocol {

    func login(email: String, password: String) -> LoginStatus {
        let succesLogin = email == "ios-vjestina@five.agency" && password == "password"

        return succesLogin ? .success : .error(400, "Bad Request")
    }

    func fetchQuizes() -> [Quiz] {
        [
            Quiz(
                id: 1,
                title: "Basic sports knowledges",
                description: "This is a quiz for beginners in sport.",
                category: .sport,
                level: 1,
                imageUrl: "https://www.publicdomainpictures.net/pictures/300000/velka/football-strategy.jpg",
                questions: [
                    Question(
                        id: 31,
                        question: "Which team won the NBA title in 2011?",
                        answers: [
                            "Dallas Mavericks",
                            "Miami Heat",
                            "Houston Rockets",
                            "Boston Celtics"
                        ],
                        correctAnswer: 0),
                    Question(
                        id: 32,
                        question: "What is the perimeter of the football ball (in cm)?",
                        answers: [
                            "56-58",
                            "60-62",
                            "68-70",
                            "74-76"
                        ],
                        correctAnswer: 2),
                    Question(
                        id: 33,
                        question: "Who was the most famous Croatian basketball player in the NBA?",
                        answers: [
                            "Dario Saric",
                            "Drazen Petrovic",
                            "Bojan Bogdanovic",
                            "Dino Radja"
                        ],
                        correctAnswer: 1),
                    Question(
                        id: 34,
                        question: "The first season of the Formula 1 race was in...",
                        answers: [
                            "1948",
                            "1950",
                            "1952",
                            "1954"
                        ],
                        correctAnswer: 1),
                    Question(
                        id: 35,
                        question: "What year did the Mediterranean Games take place in Split?",
                        answers: [
                            "1977.",
                            "1978.",
                            "1979.",
                            "1980."
                        ],
                        correctAnswer: 2)
                ]),
            Quiz(
                id: 3,
                title: "Intermediate sports knowledge",
                description: "Quiz for serious sport experts.",
                category: .sport,
                level: 2,
                imageUrl: "https://www.publicdomainpictures.net/pictures/10000/velka/yacht-at-the-sea-871287485176pSjW.jpg",
                questions: [
                    Question(
                        id: 41,
                        question: "Italian Football Club A.S. Bari plays their matches at?",
                        answers: [
                            "Stadio Enzo Ricci",
                            "Stadio San Paolo",
                            "Stadio San Nicola",
                            "Stadio Delle Alpi"
                        ],
                        correctAnswer: 2),
                    Question(
                        id: 42,
                        question: "The best scorer in the English Football League is?",
                        answers: [
                            "Thierry Henry",
                            "Andrew Cole",
                            "Alan Shearer",
                            "Gary Lineker"
                        ],
                        correctAnswer: 2),
                    Question(
                        id: 43,
                        question: "Bjorn Borg won Wimbledon _ times in a row.",
                        answers: [
                            "3",
                            "7",
                            "9",
                            "5"
                        ],
                        correctAnswer: 3),
                    Question(
                        id: 44,
                        question: "In what year did the Croatian men's basketball team win silver at the OG?",
                        answers: [
                            "1992.",
                            "1996.",
                            "2000.",
                            "2004."
                        ],
                        correctAnswer: 0),
                    Question(
                        id: 45,
                        question: "The height of the tennis net at the edges is?",
                        answers: [
                            "92 cm",
                            "107 cm",
                            "124 cm",
                            "147 cm"
                        ],
                        correctAnswer: 1)
                ]),
            Quiz(
                id: 7,
                title: "Basic science knowledge",
                description: "Basic science knowledge",
                category: .science,
                level: 1,
                imageUrl: "https://www.publicdomainpictures.net/pictures/240000/velka/striding-edge-and-helvellyn-1508577364c7J.jpg",
                questions: [
                    Question(
                        id: 51,
                        question: "What is the normal temperature of the human body(in C)?",
                        answers: [
                            "35",
                            "36",
                            "37",
                            "38"
                        ],
                        correctAnswer: 2),
                    Question(
                        id: 52,
                        question: "In chemistry silver is denoted by _",
                        answers: [
                            "S",
                            "Ag",
                            "Sr",
                            "Se"
                        ],
                        correctAnswer: 1),
                    Question(
                        id: 53,
                        question: "Which is not magnetic storage media?",
                        answers: [
                            "hard disc",
                            "floopy disc",
                            "zip disc",
                            "compact disc"
                        ],
                        correctAnswer: 3),
                    Question(
                        id: 54,
                        question: "Color recognition disorder is called?",
                        answers: [
                            "astigmatism",
                            "myopia",
                            "amblyopia",
                            "daltonism"
                        ],
                        correctAnswer: 3),
                    Question(
                        id: 55,
                        question: "Extension \"xslx\" points to?",
                        answers: [
                            "sound",
                            "text",
                            "spreadsheet",
                            "presentation"
                        ],
                        correctAnswer: 2)
                ])
        ]
    }
}
