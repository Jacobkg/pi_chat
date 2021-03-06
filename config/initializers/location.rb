response = HTTParty.post "https://www.googleapis.com/geolocation/v1/geolocate?key=#{$keys['google_geolocation']}", body: { considerIp: "true", wifiAccessPoints: [{macAddress: Mac.addr, signalStrength: -43, signalToNoiseRatio: 0}]}.to_json, headers: { 'Content-Type' => 'application/json' }

$server_lat = response['location']['lat']
$server_lng = response['location']['lng']

response = HTTParty.get "https://maps.googleapis.com/maps/api/geocode/json?latlng=#{$server_lat},#{$server_lng}&key=#{$keys['google_geocoding']}"

$server_city = response['results'].first['address_components'].select {|x| x['types'].include?('locality') }.first['long_name']
