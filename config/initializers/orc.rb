if Rails.env.development?
  ENV['GOOGLE_APPLICATION_CREDENTIALS'] ||= File.expand_path('~/work/publisher/lib/resources/urbyapp-com-14ff574b9257.json')
elsif Rails.env.production?
  ENV['GOOGLE_APPLICATION_CREDENTIALS'] ||= File.expand_path('/var/www/html/disertatie_calin/publisher/lib/resources/urbyapp-com-14ff574b9257.json')
end
