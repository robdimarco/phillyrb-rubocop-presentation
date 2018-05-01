def bad_use_of_time
  Rails.logger.debug Time.now
end

def foobar
  foo.present? ? foo : 'bar'
end
