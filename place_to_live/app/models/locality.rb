class Locality
  include Mongoid::Document
  include Mongoid::Geospatial

  field :name, type: String
  field :wiki_link, type: String
  field :location, type: Point
  field :pubs_count, type: Integer, default: 0
  field :parks_count, type: Integer, default: 0
  field :restaraunts_count, type: Integer, default: 0
  field :temples_count, type: Integer, default: 0
  field :companys_count, type: Integer, default: 0
  field :bus_frequency_per_day, type: Integer, default: 0
  field :housing_uid, type: String
  field :sqft_cost, type: Float

  spatial_index :location
  belongs_to :city


  def address
    "#{name}, #{city.name}"
  end

  def weightage
    w = {"pubs_count" => pubs_count, "parks_count" => parks_count, "restaraunts_count" => restaraunts_count, "temples_count" => temples_count, "companys_count" => companys_count, "bus_frequency_per_day" => bus_frequency_per_day}
    w = w.sort_by {|k,v| v}.reverse
  end

  def order_by_string
    w = weightage
    w.collect { |k,v| k }.join(" DESC,") + " DESC"
  end

  def to_similar_in city
    Locality.where(city_id: city).order_by(order_by_string).first
  end

  def get_location
    url = URI.parse("https://maps.googleapis.com/maps/api/geocode/json?address=#{URI::encode(address)}&key=AIzaSyCjWtAC2QLTn-JZ5FTNm2k8nVR9vJ71pNw")
    res = Net::HTTP.get_response(url)
    loc = JSON.parse(res.body)["results"][0]["geometry"]["location"] rescue {"lat"=> 0, "lng"=> 0}
    self.location = loc
    self.save
  end

  def near_by_places
    Locality.where(:id.ne => id).geo_near(location.to_a).max_distance(0.02).to_a.collect(&:name)[0..10]
  end

end
=begin

Locality.each do |locality|
  address = locality.address
  url = URI("https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=AIzaSyCjWtAC2QLTn-JZ5FTNm2k8nVR9vJ71pNw")
  Net::HTTP.get_response(url)
end
https://maps.googleapis.com/maps/api/geocode/json?address=J.P%20Nagar%203rd%20phase&key=AIzaSyCjWtAC2QLTn-JZ5FTNm2k8nVR9vJ71pNw

=end
