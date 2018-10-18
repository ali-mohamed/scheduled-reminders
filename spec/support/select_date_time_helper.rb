module SelectDateTimeHelper
  def select_time(time, options={})
    field = options[:from]
    select time.strftime('%Y'),  from: "#{field}_1i"
    select time.strftime('%B'),  from: "#{field}_2i"
    select time.strftime('%-d'), from: "#{field}_3i" 
    select time.strftime('%H'),  from: "#{field}_4i"
    select time.strftime('%M'),  from: "#{field}_5i"
  end
end

RSpec.configure do |config|
  config.include SelectDateTimeHelper, type: :feature
end
