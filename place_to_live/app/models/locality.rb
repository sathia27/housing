class Locality
  include MongoMapper::Document

  key :name, String
  key :wiki_link, String
  belongs_to :city
end
=begin

=end
