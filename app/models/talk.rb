class Talk
  include Mongoid::Document
  include Mongoid::Timestamps

  field :presentation_url, type: String
  field :title, type: String
  field :description, type: String
  field :tags, type: String
  field :thumbnail, type: String
  field :code, type: String
  field :to_public, type: Boolean, :default => false

  belongs_to :user

  validates_presence_of :title, :description, :tags, :user
end