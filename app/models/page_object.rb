class PageObject < ActiveRecord::Base
  include ThriveSmartObjectMethods
  self.caching_default = :page_update #[in :forever, :page_update, :any_page_update, 'data_update[datetimes]', :never, 'interval[5]']

  DAYS = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)
  DEFAULT_OPEN_HOUR = 9
  DEFAULT_CLOSE_HOUR = 17

  # TODO fix once http://rails.lighthouseapp.com/projects/8994/tickets/862 is resolved
  attr_accessor :monday_opens_1i_, :monday_opens_2i_, :monday_opens_3i_, :monday_opens_4i_, :monday_opens_5i_,
    :monday_closes_1i_, :monday_closes_2i_, :monday_closes_3i_, :monday_closes_4i_, :monday_closes_5i_,
    :tuesday_opens_1i_, :tuesday_opens_2i_, :tuesday_opens_3i_, :tuesday_opens_4i_, :tuesday_opens_5i_,
    :tuesday_closes_1i_, :tuesday_closes_2i_, :tuesday_closes_3i_, :tuesday_closes_4i_, :tuesday_closes_5i_,
    :wednesday_opens_1i_, :wednesday_opens_2i_, :wednesday_opens_3i_, :wednesday_opens_4i_, :wednesday_opens_5i_,
    :wednesday_closes_1i_, :wednesday_closes_2i_, :wednesday_closes_3i_, :wednesday_closes_4i_, :wednesday_closes_5i_,
    :thursday_opens_1i_, :thursday_opens_2i_, :thursday_opens_3i_, :thursday_opens_4i_, :thursday_opens_5i_,
    :thursday_closes_1i_, :thursday_closes_2i_, :thursday_closes_3i_, :thursday_closes_4i_, :thursday_closes_5i_,
    :friday_opens_1i_, :friday_opens_2i_, :friday_opens_3i_, :friday_opens_4i_, :friday_opens_5i_,
    :friday_closes_1i_, :friday_closes_2i_, :friday_closes_3i_, :friday_closes_4i_, :friday_closes_5i_,
    :saturday_opens_1i_, :saturday_opens_2i_, :saturday_opens_3i_, :saturday_opens_4i_, :saturday_opens_5i_,
    :saturday_closes_1i_, :saturday_closes_2i_, :saturday_closes_3i_, :saturday_closes_4i_, :saturday_closes_5i_,
    :sunday_opens_1i_, :sunday_opens_2i_, :sunday_opens_3i_, :sunday_opens_4i_, :sunday_opens_5i_,
    :sunday_closes_1i_, :sunday_closes_2i_, :sunday_closes_3i_, :sunday_closes_4i_, :sunday_closes_5i_

  # TODO fix once http://rails.lighthouseapp.com/projects/8994/tickets/862 is resolved
  before_validation :fix_hours
  before_validation :add_link_protocol

  def after_initialize
    if new_record?
      DAYS.each do |day|
        send "#{day.downcase}_opens=".to_sym, Time.zone.local(Time.now.year, 1, 1, DEFAULT_OPEN_HOUR, 0)
        send "#{day.downcase}_closes=".to_sym,Time.zone.local(Time.now.year, 1, 1, DEFAULT_CLOSE_HOUR, 0)
      end
    end
  end

  def blank?
      not (
        !name.blank? or
        !street_line1.blank? or
        !street_line2.blank? or
        !city.blank? or
        # state by itself is not meaningful
        !zipcode.blank? or
        # country defaults to US so it's neither.
        !time_zone.blank? or
        !phone.blank? or
        !fax.blank? or
        !email.blank? or
        !link.blank?)
  end
  
  def mappable?
    !city.blank? || !state.blank? || !zipcode.blank?
  end
  
  def location_s(use_street_2 = true)
    "" + 
    ( !street_line1.blank? ? street_line1 + ", " : "" ) +
      ( use_street_2 && !street_line2.blank? ? street_line2 + ", " : "" ) +
      ( !city.blank? ? city + ", " : "" ) +
      ( !state.blank? ? state : "" ) +
      ( !zipcode.blank? ? " #{zipcode}" : "" )
  end
  
  # Organizes hours into groups of sequential days of the week with the same hours 
  # Returns an array of these: [[days_of_week], closed, opens, closes]
  def group_days_of_hours
    last_opens_match, last_closes_match, last_closed_match = nil, nil, nil
    matched_days = []
    groups = []

    DAYS.each do |day|
      hours = hours_for_day(day)
      if !matched_days.empty? && hours_match(last_closed_match, hours[0], last_opens_match, hours[1], last_closes_match, hours[2])
        matched_days << day
        next
      elsif !matched_days.empty?
        groups << [matched_days, last_closed_match, last_opens_match, last_closes_match]
      end 

      # Continue on the next iteration with a new value
      matched_days = [day]
      last_closed_match = hours[0]
      last_opens_match, last_closes_match = hours[1], hours[2]
    end

    # Catch the last one
    groups << [matched_days, last_closed_match, last_opens_match, last_closes_match]


    if groups.size > 1
      # Do a little surgery to handle if the end of the week is the same as the start of the week to group them correctly
      g1 = groups[0]
      g2 = groups[groups.size - 1]
      if hours_match(g1[1], g2[1], g1[2], g2[2], g1[3], g2[3]) then
        g3 = groups.pop
        g3[0].reverse_each { |dow| groups[0][0].unshift(dow) }
      end

      # Make sure not to display a 'closed' first, because it looks bad
      if groups[0][1] == true then
        first = groups.shift
        groups << first
      end

    end


    return groups
  end
  
  protected
  
  def hours_for_day(day_name)
    [send("#{day_name.downcase}_closed".to_sym), send("#{day_name.downcase}_opens".to_sym), send("#{day_name.downcase}_closes".to_sym)]
  end
  
  # has the !closed because the previous location may have the same hours, but a different closed value
  def hours_match(closed_1, closed_2, start_1, start_2, end_1, end_2) 
    ((closed_1 && closed_2) || (!closed_1 && !closed_2 && start_1 == start_2 && end_1 == end_2))
  end
  
  def fix_hours
    DAYS.each do |day|
      send "#{day.downcase}_opens=".to_sym, Time.zone.local(Time.now.year, 1, 1, send("#{day.downcase}_opens_4i_".to_sym), send("#{day.downcase}_opens_5i_".to_sym)) unless send("#{day.downcase}_opens_4i_".to_sym).nil?
      send "#{day.downcase}_closes=".to_sym, Time.zone.local(Time.now.year, 1, 1, send("#{day.downcase}_closes_4i_".to_sym), send("#{day.downcase}_closes_5i_".to_sym)) unless send("#{day.downcase}_closes_4i_".to_sym).nil?
    end
  end
  
  def add_link_protocol
    self.link = 'http://' + self.link unless self.link.index('://')
  end
end
