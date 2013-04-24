class EventMailer < ActionMailer::Base
  default :from  => "notifier@ivolunteer.com.ph"
  helper :events

  def new_volunteer(participation)
    @user = participation.user
    @event = participation.event
    mail(:to => @user.email, :reply_to => "#{participation.id}@mail-staging.ivolunteer.com.ph", :subject => "Thank you for volunteering")
  end

  def new_volunteer_for_organization(participation)
    @user = participation.user
    @event = participation.event
    to = @event.organization.admin_emails
    mail(:to => to, :reply_to => "#{participation.id}@mail-staging.ivolunteer.com.ph", :subject => "You have a new volunteer")
  end

  def reply_from_inbound(participation, inbound_mail)
    @inbound_mail = inbound_mail
    @user = participation.user
    @event = participation.event
    to = @event.organization.admin_emails
    to << @user.email
    to = to - [inbound_mail.from.first]
    to.uniq!
    @mail_body = if @inbound_mail.body.to_s.blank?
               ""
            else
              @inbound_mail.body.to_s.
                split(/^\s*[-]+\s*Original Message\s*[-]+\s*$/).first.
                split(/^\s*--\s*$/).first.
                gsub(/On.*wrote:/, '').
                split(/[\r]*\n/).reject do |line|
                  line =~ /^\s*>/ ||
                    line =~ /^\s*Sent from my /
                end.
                join("\n").
                gsub(/^\s*On.*\r?\n?\s*.*\s*wrote:$/,'').
                strip
            end

    mail(:to => to, :reply_to => "#{participation.id}@mail-staging.ivolunteer.com.ph", :subject => "iVolunteer Reply")
  end
end
