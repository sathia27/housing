class PageController < ApplicationController
  
  def index
    @weightage = nil
    current_locality = Locality.where(:name => params[:cl]).last
    relocating_city = City.where(:name => params[:rl]).last
    @suggestion = current_locality.to_similar_in relocating_city if current_locality.present?
    @weightage = current_locality.weightage.collect{ |k,v| k.humanize.sub(" count", "") + ": #{v}" }.join("<br/>") rescue nil
    @new_weightage = @suggestion.weightage.collect{ |k,v| k.humanize.sub(" count", "") + ": #{v}" }.join("<br/>") rescue nil
    @near_by_places = @suggestion.near_by_places.join("<br/>") if @suggestion.present?
  end

end
