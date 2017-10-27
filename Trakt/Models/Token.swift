import Foundation
import ObjectMapper

public final class Token: NSObject, ImmutableMappable, NSCoding {
  public let accessToken: String
  public let expiresIn: Date
  public let refreshToken: String
  public let tokenType: String
  public let scope: String

  public init(accessToken: String, expiresIn: Date, refreshToken: String, tokenType: String, scope: String) {
    self.accessToken = accessToken
    self.expiresIn = expiresIn
    self.refreshToken = refreshToken
    self.tokenType = tokenType
    self.scope = scope
  }

  public required init(map: Map) throws {
    self.accessToken = try map.value("access_token")
    self.expiresIn = Date(timeIntervalSinceNow: try map.value("expires_in"))
    self.refreshToken = try map.value("refresh_token")
    self.tokenType = try map.value("token_type")
    self.scope = try map.value("scope")
  }

  public required convenience init?(coder: NSCoder) {
    guard let accessToken = coder.decodeObject(forKey: "accessToken") as? String,
      let expiresIn = coder.decodeObject(forKey: "expiresIn") as? Date,
      let refreshToken = coder.decodeObject(forKey: "refreshToken") as? String,
      let tokenType = coder.decodeObject(forKey: "tokenType") as? String,
      let scope = coder.decodeObject(forKey: "scope") as? String
      else { return nil }

    self.init(accessToken: accessToken, expiresIn: expiresIn,
              refreshToken: refreshToken, tokenType: tokenType, scope: scope)
  }

  public func encode(with coder: NSCoder) {
    coder.encode(accessToken, forKey: "accessToken")
    coder.encode(expiresIn, forKey: "expiresIn")
    coder.encode(refreshToken, forKey: "refreshToken")
    coder.encode(tokenType, forKey: "tokenType")
    coder.encode(scope, forKey: "scope")
  }

  public func mapping(map: Map) {
    self.accessToken >>> map["access_token"]
    self.expiresIn >>> map["expires_in"]
    self.refreshToken >>> map["refresh_token"]
    self.tokenType >>> map["token_type"]
    self.scope >>> map["scope"]
  }

  public override func isEqual(_ object: Any?) -> Bool {
    guard let anotherToken = object as? Token else { return false }
    return self == anotherToken
  }

  public override var hash: Int {
    return self.hashValue
  }

  public override var hashValue: Int {
    let hash = accessToken.hashValue ^ expiresIn.hashValue ^ refreshToken.hashValue
    return hash ^ tokenType.hashValue ^ scope.hashValue
  }

  public static func == (lhs: Token, rhs: Token) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
