import UIKit

protocol Iterator {
    associatedtype Item
    var hasNext: Bool { get }
    func next()->Item
}

protocol Aggregate {
    associatedtype IteratorImpl: Iterator
    var iterator: IteratorImpl { get }
}

class Book {
    let name: String
    init(name: String) {
        self.name = name
    }
}

class BookShelf: Aggregate {
    typealias IteratorImpl = BookShelfIterator
    var len: Int {
        return books.count
    }
    private(set) var books: [Book] = []
    var iterator: BookShelfIterator {
        return BookShelfIterator(self)
    }

    func appendBook(book: Book) {
        self.books.append(book)
    }
}

class BookShelfIterator: Iterator {
    typealias Item = Book

    private let shelf: BookShelf
    private var index: Int

    var hasNext: Bool {
        if index < shelf.len {
            return true
        } else {
            return false
        }
    }

    init(_ shelf: BookShelf) {
        self.shelf = shelf
        self.index = 0
    }

    func next() -> Book {
        defer {
            self.index += 1
        }
        return self.shelf.books[self.index]
    }
}

var shelf = BookShelf()
shelf.appendBook(book: Book(name: "Code Complete"))
shelf.appendBook(book: Book(name: "Design Pattern"))
shelf.appendBook(book: Book(name: "Clean Architecture"))
var iterator = shelf.iterator
while (iterator.hasNext) {
    print(iterator.next().name)
}
