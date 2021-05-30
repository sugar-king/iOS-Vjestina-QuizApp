//
//  CDQuiz+CoreDataProperties.swift
//  QuizApp
//
//  Created by five on 30.05.2021..
//
//

import Foundation
import CoreData


extension CDQuiz {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDQuiz> {
        return NSFetchRequest<CDQuiz>(entityName: "CDQuiz")
    }

    @NSManaged public var category: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var level: Int16
    @NSManaged public var quizDescription: String?
    @NSManaged public var quizId: Int32
    @NSManaged public var title: String?
    @NSManaged public var questions: NSOrderedSet?

}

// MARK: Generated accessors for questions
extension CDQuiz {

    @objc(insertObject:inQuestionsAtIndex:)
    @NSManaged public func insertIntoQuestions(_ value: CDQuestion, at idx: Int)

    @objc(removeObjectFromQuestionsAtIndex:)
    @NSManaged public func removeFromQuestions(at idx: Int)

    @objc(insertQuestions:atIndexes:)
    @NSManaged public func insertIntoQuestions(_ values: [CDQuestion], at indexes: NSIndexSet)

    @objc(removeQuestionsAtIndexes:)
    @NSManaged public func removeFromQuestions(at indexes: NSIndexSet)

    @objc(replaceObjectInQuestionsAtIndex:withObject:)
    @NSManaged public func replaceQuestions(at idx: Int, with value: CDQuestion)

    @objc(replaceQuestionsAtIndexes:withQuestions:)
    @NSManaged public func replaceQuestions(at indexes: NSIndexSet, with values: [CDQuestion])

    @objc(addQuestionsObject:)
    @NSManaged public func addToQuestions(_ value: CDQuestion)

    @objc(removeQuestionsObject:)
    @NSManaged public func removeFromQuestions(_ value: CDQuestion)

    @objc(addQuestions:)
    @NSManaged public func addToQuestions(_ values: NSOrderedSet)

    @objc(removeQuestions:)
    @NSManaged public func removeFromQuestions(_ values: NSOrderedSet)

}

extension CDQuiz : Identifiable {

}
