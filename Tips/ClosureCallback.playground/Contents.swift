import UIKit

//func a(function: @escaping  (Void) -> Void ) {
//(Void) -> Voidは古い記述で、()->Voidで良い

//func a(function:  ()->Void ) {
//この場合@escapingをつけていない。
//@escapingがないと"expression failed to parse, unknown error"

func a(function: ()->Void ) {
    print("a")
    function()
}
 
func b() {
    print("b")
}
 
a(function: b)

//a
//b

print("--------------------------------------")
//クロージャコールバックで書くと
//機能分掌ができる。計算部分(Model)と表示部分(View)
class Game {
    var score = 0
    func start(completion: (Int) -> Void) {
        score = Int(arc4random() % 10) // 0から9までの値をランダムで代入
        completion(score) //　ここでバックする（呼び出し元に引数scoreを渡して処理を実行してもらう）
    }
    deinit {
        print("deinit") // 呼ばれる
    }
}

var game:Game! = Game()
game.start(completion: { score in
    print(score)//取り出された乱数の結果を出力する
})
game = nil

//数字

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
        a = A(closure: { [weak self] in // クロージャがself(B)を弱参照する
            self?.count += 1
            print("count")
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

//deinit

print("--------------------------------------")
//@escaping がいらない場合
//同期実行と考えて良い


class Foo1 {
  func foo(_ closure: () -> Void) {
    closure()//クロージャをメンバ変数に持たせるではなくて、参照で実行しているだけ？だから、
  }
  deinit {
    print("Foo1 deinit")
  }

}

class Bar1 {
  func bar() {
    var foo:Foo1! = Foo1()
    foo.foo {
      print("closure called")
    }
    print("Foo.foo() called")
    
    foo = nil
  }
  deinit {
    print("Bar1 deinit")
  }
}

var bar1:Bar1! = Bar1()
bar1.bar()
bar1 = nil

//closure called
//Foo.foo() called
//Foo1 deinit
//Bar1 deinit

print("--------------------------------------")
//@escaping が必要な場合
//非同期実行と考えて良い

//@escapingを外すとコンパイルエラー
//Assigning non-escaping parameter 'closure' to an @escaping closure

class Foo2 {
  var storedClosure: (() -> Void)? //クロージャをメンバ変数に入れるとクラス内に実体を保持することになる

  func foo(_ closure: @escaping () -> Void) {
    storedClosure = closure
  }

  func callClosure() {
    storedClosure?()
  }

  deinit {
    print("Foo1 deinit")
  }
}

class Bar2 {
  func bar() {
    var foo2:Foo2! = Foo2()
    foo2.foo {
      print("closure called")
    }
    print("Foo2.foo() called")
    foo2.callClosure() //Foo2がBar2 から受け取ったクロージャを実行している
    foo2 = nil
  }
    deinit {
      print("Bar2 deinit")
    }

}

var bar2:Bar2! = Bar2()
bar2.bar()
bar2 = nil

//Foo2.foo() called
//closure called
//Foo1 deinit
//Bar2 deinit

print("--------------------------------------")
//循環参照が起きている例
//クロージャのインスタンスとFooのインスタンスが
//これをのちに循環参照が起きないように修正

class Foo3 {
  var storedClosure: (() -> Void)?
  let name = "foo"

  func foo() {
    storedClosure = {
        print(self.name)
    }
  }

  deinit {
    print("foo deinit")//Fooが解放されず、呼ばれない
  }
}

var foo3: Foo3! = Foo3()
foo3.foo()
foo3.storedClosure!()
foo3 = nil

//foo

print("--------------------------------------")
//上を[weak self]で修正する
class Foo4 {
  var storedClosure: (() -> Void)?
  let name = "foo"

  func foo() {
    storedClosure = { [weak self] in    //[weak self]を挿入
      if let weakSelf = self {
        print(weakSelf.name)
      }
    }
  }

  deinit {
    print("foo deinit")  //呼ばれる
  }
}

var foo4: Foo4! = Foo4()
foo4.foo()
foo4.storedClosure!()
foo4 = nil

// --> foo
// --> foo deinit

print("--------------------------------------")
//上を[weak self]で修正する

class Foo5 {
    var storedClosure: (() -> Void)?
    let name = "foo"
    
    func foo() {
        storedClosure = { [unowned self] in
            print(self.name)
        }
    }
    deinit {
        print("foo diinit")
    }
}

var foo5: Foo5! = Foo5()
foo5.foo()
//unownedの場合、unownedはOptionalではないので，弱参照先がメモリ開放されていた場合クラッシュします
//つまりfoo5がnilになった後にstoredClosureを呼ぶとエラー発生する
//foo5 = nil
foo5.storedClosure!()
foo5 = nil

//foo
//foo deinit


print("--------------------------------------")
//weak/unowned の使い所
//
//BarがFooを強参照している
//FooがBarを弱参照している


protocol FooDelegate: class {
  func delegateFunc()
}

class Foo {
  weak var delegate: FooDelegate? //delegateをweakで宣言している
    

  func callDelegate() {
    delegate?.delegateFunc()
  }

  deinit {
    print("foo deinit")
  }
}

class Bar: FooDelegate {
  var foo: Foo?

  func bar() {
    foo = Foo()
    foo?.delegate = self
    foo?.callDelegate()
  }

  func delegateFunc() {
    print("bar delegate func")
  }

  deinit {
    print("bar deinit")
  }
}

var bar: Bar! = Bar()
bar.bar()
bar = nil

// --> bar delegate func
// --> bar deinit
// --> foo deinit


print("--------------------------------------")
//ViewController とクロージャと UIAlertController のオブジェクトが3者で循環参照になってしまうため，
//クロージャから ViewController の参照の部分で unowned を使い弱参照にして循環を断ち切っています

//ViewControllerがUIAlertControllerを強参照（クラス内で保持）
//UIAlertControllerがクロージャを強参照（クラス内で保持）
//クロージャがViewControllerを弱参照(self.label.textということなんだろうと思う)

class ViewController: UIViewController {

  @IBOutlet weak var label: UILabel!

  var dlg: UIAlertController!

  override func viewDidLoad() {
    super.viewDidLoad()
    dlg = UIAlertController(title: "", message: "", preferredStyle: .alert)
    dlg.addAction(UIAlertAction(title: "ok", style: .default) { [unowned self] _ in
      self.label.text = "ok selected"
    })
  }

  override func viewDidAppear(_ animated: Bool) {
    present(dlg, animated: true)
  }

}
