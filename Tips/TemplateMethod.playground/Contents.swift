import UIKit

//スーパークラスで処理の枠組み(テンプレート)を決め、
//サブクラスで具体的内容を決める

// javaだと、public abstract classで実装するけど

class AbstractClass {
    final func operation() {
        subOperation1()
        subOperation2()
    }
    
    func subOperation1() {}
    func subOperation2() {}
}

class ConcreteClass: AbstractClass {
    override func subOperation1() {
        print("sub op 1")
    }
    
    override func subOperation2() {
        print("sub op 2")
    }
}

let a = ConcreteClass()
a.operation()

print("--------------------------------------")
//Protocol Extensionで実装


protocol OperationProtocol {
    func subOperation1()
    func subOperation2()
}

extension OperationProtocol {
    func operation() {
        subOperation1()
        subOperation2()
    }
}

struct ConcreteStruct: OperationProtocol {
    func subOperation1() {
        print("sub op 1")
    }
    
    func subOperation2() {
        print("sub op 2")
    }
}

let a = ConcreteStruct()
a.operation()

