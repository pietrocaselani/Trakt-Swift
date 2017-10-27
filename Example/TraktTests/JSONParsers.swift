import Foundation

func toObject(data: Data) -> [String: AnyObject] {
  let options = JSONSerialization.ReadingOptions(rawValue: 0)
  return try! JSONSerialization.jsonObject(with: data, options: options) as! [String: AnyObject]
}

func toArray(data: Data) -> [[String: AnyObject]] {
  let options = JSONSerialization.ReadingOptions(rawValue: 0)
  return try! JSONSerialization.jsonObject(with: data, options: options) as! [[String: AnyObject]]
}
