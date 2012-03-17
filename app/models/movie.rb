class Movie < ActiveRecord::Base
  def self.all_ratings
    all(:select => "distinct(rating)").collect { |m| m.rating }
  end
end
