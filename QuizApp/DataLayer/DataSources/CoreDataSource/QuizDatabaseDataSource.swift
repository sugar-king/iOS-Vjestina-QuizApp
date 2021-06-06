import CoreData
class QuizDatabaseDataSource {
    private let coreDataContext: NSManagedObjectContext
    
    init(coreDataContext: NSManagedObjectContext) {
        self.coreDataContext = coreDataContext
    }
    
    func fetchQuizzesFromCoreData(filter: FilterSettings?) -> [Quiz] {
        let request: NSFetchRequest<CDQuiz> = CDQuiz.fetchRequest()
        var namePredicate = NSPredicate(value: true)
        
        if let text = filter?.searchText, !text.isEmpty {
            namePredicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(CDQuiz.title), text)
        }
        
        request.predicate = namePredicate
        do {
            return try coreDataContext.fetch(request).map { Quiz(with: $0) }
        } catch {
            print("Error when fetching quizzes from core data: \(error)")
            return []
        }
    }
    
    func saveNewQuizzes(_ quizzes: [Quiz]) {
        quizzes.forEach { quiz in
            do {
                let cdQuiz = try fetchQuiz(withId: quiz.id) ?? CDQuiz(context: coreDataContext)
                quiz.populate(cdQuiz, context: coreDataContext)
            } catch {
                print("Error when fetching/creating a quiz: \(error)")
            }
            
            do {
                try coreDataContext.save()
            } catch {
                print("Error when saving updated quiz: \(error)")
            }
        }
    }
    
    func deleteQuiz(withId id: Int) {
        guard let restaurant = try? fetchQuiz(withId: id) else { return }
        
        coreDataContext.delete(restaurant)
        
        do {
            try coreDataContext.save()
        } catch {
            print("Error when saving after deletion of restaurant: \(error)")
        }
        
    }
    
    private func fetchQuiz(withId id: Int) throws -> CDQuiz? {
        let request: NSFetchRequest<CDQuiz> = CDQuiz.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %u", #keyPath(CDQuiz.quizId), id)
        
        let cdResponse = try coreDataContext.fetch(request)
        return cdResponse.first
    }
    
    
    
}


