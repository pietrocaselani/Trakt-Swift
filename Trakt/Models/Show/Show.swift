import Foundation

public final class Show: StandardMediaEntity {
  public let year: Int
  public let ids: ShowIds
  public let firstAired: Date?
  public let airs: Airs?
  public let runtime: Int?
  public let certification: String?
  public let network: String?
  public let country: String?
  public let trailer: String?
  public let homepage: String?
  public let status: Status?
  public let language: String?
  public let genres: [String]?

	private enum CodingKeys: String, CodingKey {
		case year, ids, airs, runtime, certification, network, country, trailer, homepage, status, language, genres
		case firstAired = "first_aired"
	}

	public required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.year = try container.decode(Int.self, forKey: .year)
		self.ids = try container.decode(ShowIds.self, forKey: .ids)
		self.airs = try container.decodeIfPresent(Airs.self, forKey: .airs)
		self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
		self.certification = try container.decodeIfPresent(String.self, forKey: .certification)
		self.network = try container.decodeIfPresent(String.self, forKey: .network)
		self.country = try container.decodeIfPresent(String.self, forKey: .country)
		self.trailer = try container.decodeIfPresent(String.self, forKey: .trailer)
		self.homepage = try container.decodeIfPresent(String.self, forKey: .homepage)
		self.status = try container.decodeIfPresent(Status.self, forKey: .status)
		self.language = try container.decodeIfPresent(String.self, forKey: .language)
		self.genres = try container.decodeIfPresent([String].self, forKey: .genres)

		let firstAired = try container.decodeIfPresent(String.self, forKey: .firstAired)
		self.firstAired = TraktDateTransformer.dateTimeTransformer.transformFromJSON(firstAired)

		try super.init(from: decoder)
	}
  
  public override var hashValue: Int {
    var hash = super.hashValue ^ year.hashValue ^ ids.hashValue
    
    if let firstAiredHash = firstAired?.hashValue {
      hash = hash ^ firstAiredHash
    }
    
    if let airsHash = airs?.hashValue {
      hash = hash ^ airsHash
    }
    
    if let runtimeHash = runtime?.hashValue {
      hash = hash ^ runtimeHash
    }
    
    if let certificationHash = certification?.hashValue {
      hash = hash ^ certificationHash
    }
    
    if let networkHash = network?.hashValue {
      hash = hash ^ networkHash
    }
    
    if let countryHash = country?.hashValue {
      hash = hash ^ countryHash
    }
    
    if let trailerHash = trailer?.hashValue {
      hash = hash ^ trailerHash
    }
    
    if let homepageHash = homepage?.hashValue {
      hash = hash ^ homepageHash
    }
    
    if let statusHash = status?.hashValue {
      hash = hash ^ statusHash
    }
    
    if let languageHash = language?.hashValue {
      hash = hash ^ languageHash
    }
    
    genres?.forEach { hash = hash ^ $0.hashValue }
    
    return hash
  }
}
