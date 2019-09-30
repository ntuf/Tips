import UIKit

protocol Aggregate {
    associatedtype IteratorImpl: Iterator
    var iterator: IteratorImpl { get }
}

protocol Iterator {
    associatedtype Item
    var hasNext: Bool { get }
    func next()->Item
}

// ジェネリックプロトコル（Generic Protocol）とは、
// ジェネリクスを使ったプロトコル
//associatedtype :
//typealias : 型の別名

class ConcreteAggregate: Aggregate { //ex.BookShelf
    typealias IteratorImpl = ConcreteIterator
    var len: Int {
        return items.count
    }
    private(set) var items: [ItemObj] = []
    var iterator: ConcreteIterator {
        return ConcreteIterator(self)
    }

    func appendItem(itemObj: ItemObj) {
        self.items.append(itemObj)
    }
}

class ConcreteIterator: Iterator { //ex.BookShelfIterator
    typealias Item = ItemObj

    private let aggregate: ConcreteAggregate
    private var index: Int

    var hasNext: Bool {
        if index < aggregate.len {
            return true
        } else {
            return false
        }
    }

    init(_ aggregate: ConcreteAggregate) {
        self.aggregate = aggregate
        self.index = 0
    }

    func next() -> Item {
        defer {
            self.index += 1
        }
        return self.aggregate.items[self.index]
    }
}

class ItemObj { //ex.Book
    let name: String
    init(name: String) {
        self.name = name
    }
}


var shelf = ConcreteAggregate() //ex.BookShelf
shelf.appendItem(itemObj: ItemObj(name: "Code Complete"))
shelf.appendItem(itemObj: ItemObj(name: "Design Pattern"))
shelf.appendItem(itemObj: ItemObj(name: "Clean Architecture"))
var iterator = shelf.iterator
while (iterator.hasNext) {
    print(iterator.next().name)
}







