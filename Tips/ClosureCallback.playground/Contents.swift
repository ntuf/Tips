import UIKit

//func a(function: @escaping  (Void) -> Void ) { //(Void)は古い記述 → ()
//func a(function:  ()->Void ) { // @escapingがないと"expression failed to parse, unknown error"

func a(function: ()->Void ) {
    print("a")
    function()
}
 
func b() {
    print("b")
}
 
a(function: b)

print("--------------------------------------")

class Game {
    var score = 0
    func start(completion: (Int) -> Void) {
        completion(score)
    }
}

let game = Game()
game.start(completion: { score in
    print(score)
})

print("--------------------------------------")
//クロージャがスコープから抜けても存在し続けるときに @escaping が必要

class A {
    private let storedClosure: () -> ()

    init(closure: @escaping () -> ()) {
        storedClosure = closure
    }
}

class B {
    private var a: A?
    private var count = 0

    func doSomething() {
        a = A(closure: { [weak self] in // selfを弱参照する
            self?.count += 1
        })
    }

    deinit {
        print("deinit") // 呼ばれる
    }
}

do {
    let b = B()
    b.doSomething()
}

print("--------------------------------------")
//@escaping がいらない場合
//同期実行と考えて良い


class Foo1 {
  func foo(_ closure: () -> Void) {
    closure()
  }
}

class Bar1 {
  func bar() {
    let foo = Foo1()
    foo.foo {
      print("closure called")
    }
    print("Foo.foo() called")
  }
}

let bar1 = Bar1()
bar1.bar()

print("--------------------------------------")
//@escaping が必要な場合
//非同期実行と考えて良い

class Foo2 {
  var storedClosure: (() -> Void)?

  func foo(_ closure: @escaping () -> Void) {
    storedClosure = closure
  }

  func callClosure() {
    storedClosure?()
  }
}

class Bar2 {
  func bar() {
    let foo = Foo2()
    foo.foo {
      print("closure called")
    }
    print("Foo.foo() called")
    foo.callClosure() //
  }
}

let bar2 = Bar2()
bar2.bar()
