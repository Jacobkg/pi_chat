class ChatChannel < ApplicationCable::Channel

  ADJECTIVES = RandomWord.adjs.to_a
  NOUNS = RandomWord.nouns.to_a
  EMOJI = Emoji.all.to_a # Categories: ["People", "Nature", "Foods", "Activity", "Places", "Objects", "Symbols", "Flags", nil] 

  # Called when the consumer has successfully become a subscriber
  def subscribed
    stream_from "chat_#{params[:room]}"
  end

  def receive(data)
    data['body'].gsub!(/\[[dD](\d{1,2})\]/) {|x| color_wrap(SecureRandom.random_number(x[$1].to_i) + 1) }
    data['body'].gsub!('[adjective]') { |x| color_wrap(ADJECTIVES.sample.humanize(capitalize: false)) }
    data['body'].gsub!('[noun]') { |x| color_wrap(NOUNS.sample.humanize(capitalize: false)) }
    data['body'].gsub!('[emoji]') { |x| EMOJI.sample.raw }
    data['body'].gsub!('[emoji|people]') { |x| EMOJI.select {|x| x.category == 'People'}.sample.raw }
    data['body'].gsub!('[emoji|nature]') { |x| EMOJI.select {|x| x.category == 'Nature'}.sample.raw }
    data['body'].gsub!('[emoji|food]') { |x| EMOJI.select {|x| x.category == 'Foods'}.sample.raw }
    data['body'].gsub!('[emoji|activity]') { |x| EMOJI.select {|x| x.category == 'Activity'}.sample.raw }
    data['body'].gsub!('[emoji|place]') { |x| EMOJI.select {|x| x.category == 'Places'}.sample.raw }
    data['body'].gsub!(/\[yelp\|(.*)\]/) {|x| yelp($1) }
    data['body'].gsub!('[weather]') { |x| color_wrap(forecast) }
    
    $chats ||= []
    $chats << data
    ActionCable.server.broadcast("chat_home", data)
  end

  def color_wrap(str)
    "<span style=\"color: #4ca9d4\">#{str}</span>"
  end

  def yelp(term)
    coord = { latitude: $server_lat, longitude: $server_lng}
    business = Yelp.client.search_by_coordinates(coord, { term: term }).businesses.sample
    "<a href=\"#{business.url}\">#{business.name}</a>".html_safe
  end

  def forecast
    weather = HTTParty.get "https://api.darksky.net/forecast/#{$keys['forecast']}/#{$server_lat},#{$server_lng}"
    temp = weather['currently']['temperature'].to_i
    current = weather['currently']['summary']
    summary = weather['hourly']['summary']
    "#{temp}° F #{current} - #{summary}"
  end
end
