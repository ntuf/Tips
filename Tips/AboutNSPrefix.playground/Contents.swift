import UIKit

//Appleは次期 OSを他社から買い取ろうとしていた歴史がある。
//ジョブズの作ったNeXTという会社のNeXTSTEPという OSが
//からNSの頭文字が存在する。NeXTSTEPこそ、現在の Mac OS Xのベースらしい

//Ovjective-cでは接頭辞で名前空間を示した。他にもある。
//だがSwiftではModuleで名前空間を示せる。NSPrefixもその一つ。
//中には残っちゃっているものもある。
//→とりあえず、NSMutableURLRequestとURLRequestの違いはおいておくNSを使うときはとりあえず置き換えられないか検討。


//下はurlとかないから動かない。


//let request = NSMutableURLRequest(url: URL(string: urlString)!)
let request = URLRequest(url: URL(string: urlString)!)
request.httpMethod = "POST"
request.addValue("application/json", forHTTPHeaderField: "Content-Type")

let params:[String:Any] = [
    "app_id": app_id,
    "sentence": sentence,
    "output_type": "hiragana"
]

do{
    request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)

    let task:URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data,response,error) -> Void in
                    
         let decoder: JSONDecoder = JSONDecoder()
         do {
             let data: JsonData = try decoder.decode(JsonData.self, from: data!)
             completion(data.converted)
         } catch {
             print("error:", error)
             completion("")
         }
    })
    task.resume()
 }catch{
     print("error:\(error)")
     completion("")
 }
