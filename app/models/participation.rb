class Participation < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  has_many :event_messages
  def self.volunteer(event, user)
    return unless Participation.where(:event_id => event, :user_id => user).empty?
    p = Participation.new
    p.event = event
    p.user = user
    result = p.save
    if result
      # send email
      EventMailer.new_volunteer(p).deliver
      EventMailer.new_volunteer_for_organization(p).deliver
    end
  end
end
