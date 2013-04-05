class Enrollment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :active, type: Boolean, :default => true
  field :present, type: Boolean, :default => false

  belongs_to :event

  belongs_to :user

  scope :actives, lambda { where(:active => true).order_by(:created_at => :asc) }

  def update_counter_of_events_and_users
    operation = self.active? ? :inc : :dec

    user.set_counter(:participation_events, operation)

    event.set_counter(:registered_users, operation)
  end
end