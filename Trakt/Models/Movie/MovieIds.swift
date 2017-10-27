import ObjectMapper

public final class MovieIds: BaseIds {
  public let slug: String

  public required init(map: Map) throws {
    self.slug = try map.value("slug")

    try super.init(map: map)
  }

  public override func mapping(map: Map) {
    self.slug >>> map["slug"]
  }

  public override var hashValue: Int {
    return super.hashValue ^ slug.hashValue
  }
}
