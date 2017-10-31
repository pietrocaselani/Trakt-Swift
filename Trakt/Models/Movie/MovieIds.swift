public final class MovieIds: BaseIds {
  public let slug: String

  public override var hashValue: Int {
    return super.hashValue ^ slug.hashValue
  }
}
