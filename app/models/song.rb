# == Schema Information
#
# Table name: songs
#
#  id                   :integer          not null, primary key
#  artist               :string
#  title                :string
#  content              :text
#  key                  :string
#  youtube_url          :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  views                :integer          default(0)
#  full_name            :string
#  full_name_searchable :string
#  user_id              :integer
#
class Song < ApplicationRecord
  belongs_to :user

  validates :artist, :presence => true
  validates :title, :presence => true

  before_save :handle_full_name

  decorate_with SongDecorator

  def self.search(query)
    if query.nil? || query.empty?
      all
    else
      where 'full_name_searchable LIKE :query', :query => "%#{query}%"
    end
  end

  def self.top_songs
    all.order(:views => :desc).limit(10)
  end

  def self.new_songs
    all.order(:created_at => :desc).limit(10)
  end

  private

  def handle_full_name
    self.full_name = "#{self.artist} - #{self.title}".strip
    self.full_name_searchable = "#{self.artist} #{self.title}".strip.downcase
  end
end
