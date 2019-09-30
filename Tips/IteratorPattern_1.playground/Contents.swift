import UIKit

protocol Aggregate {
    func iterator() -> Iterator
}

protocol Iterator {
    func next() -> AnyObject
    func hasNext() -> Bool
}

class ConcreteAggregate: Aggregate { //ex.BookShelf
    private var items = [Item]()
    func iterator() -> Iterator {
        return ConcreteIterator(aggregate: self)//自分自信を渡す
    }
    func addItem(_ item: Item) {
        items.append(item)
    }
    func countOfItems() -> Int {
        return items.count
    }
    func itemAtIndex(_ index: Int) -> Item {
        return items[index]
    }
}

class ConcreteIterator: Iterator { //ex.BookShelfIterator
    private var aggregate: ConcreteAggregate
    private var index = 0
    init(aggregate: ConcreteAggregate) {
        self.aggregate = aggregate
    }
    func next() -> AnyObject {
        defer{ index += 1 }
        return aggregate.itemAtIndex(index)
    }
    func hasNext() -> Bool {
        return aggregate.countOfItems() > index
    }
}

class Item { //ex.Book
    private var _name: String
    var name: String {
        get { return _name }
    }
    init(_ name: String) {
        _name = name
    }
}

var ca = ConcreteAggregate() //ex.BookShelf
ca.addItem(Item("name 1"))
ca.addItem(Item("name 2"))
ca.addItem(Item("name 3"))
 
let it = ca.iterator()
 
while it.hasNext() {
    let item = it.next() as! Item
    print(item.name)
}




















