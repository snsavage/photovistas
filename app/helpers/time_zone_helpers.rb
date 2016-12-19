module TimeZoneHelpers
  Option = Struct.new(:value, :label, :disabled, :selected)

  def time_zones(selected)
    us_zones = ActiveSupport::TimeZone.us_zones.map do |zone|
      Option.new(zone.name, zone.to_s, false, false)
    end

    all_zones = ActiveSupport::TimeZone.all.map do |zone|
      Option.new(zone.name, zone.to_s, false, false)
    end

    us_zones << Option.new("", "-------------", true, false)

    non_us_zones = all_zones - us_zones
    display_zones = us_zones + non_us_zones

    display_zones.map do |zone|
      if zone.value == selected
        zone.selected = true
      end

      zone
    end
  end

  def tz_display(user_tz)
    ActiveSupport::TimeZone.all.find do |zone|
      zone.name == user_tz
    end.to_s
  end
end
