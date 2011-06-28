module ApplicationHelper
  require 'open-uri'
  def twitter_get
    url = "http://api.twitter.com/1/statuses/user_timeline.json?screen_name=conduitrobotic"
    #open(url, 'r') do |http|
    #  @resp = http.read
    #end
    #@resp = Net::HTTP.get_response(URI.parse(url))
    h = Net::HTTP::new("api.twitter.com", 80)
    h.read_timeout = 1
    begin
      @resp = h.get("/1/statuses/user_timeline.json?screen_name=conduitrobotic")
      data = @resp.body
      result = JSON.parse(data)
      array = [result[0], result[1], result[2]]
    rescue Timeout::Error
      return false
    end
    return array
  end

  def twitter_last3    
    begin 
      fh = File.open("#{RAILS_ROOT}/tmp/cache/twitter.cache", "r")
      tcache = YAML::load(fh)
      fh.close
      time = Time.now.to_i - 600 #10 minutes
        if tcache['date'] > time
        array = tcache['data']
        return array
      end
    rescue Errno::ENOENT
      array = twitter_get
      if array == false
        return false
      end
      tcache = {'date'=>Time.now.to_i, 'data'=>array}
      fh = File.open("#{RAILS_ROOT}/tmp/cache/twitter.cache", "w")
      YAML::dump(tcache, fh)
      fh.close
      return array
    end
    array = twitter_get
    if array == false
      return false
    end
    tcache = {'date'=>Time.now.to_i, 'data'=>array}
    fh = File.open("#{RAILS_ROOT}/tmp/cache/twitter.cache", "w")
    YAML::dump(tcache, fh)
    fh.close
    #result = => ["coordinates", "truncated", "favorited", "created_at", "id_str", "in_reply_to_user_id_str", "text", "contributors", "in_reply_to_status_id_str", "id", "retweet_count", "geo", "retweeted", "in_reply_to_user_id", "source", "user", "in_reply_to_screen_name", "place", "in_reply_to_status_id"]
    return array
  end
  def twitter_get_last
    tweets = twitter_last3
    if tweets == false
      return "twitter api error"
    end
    tweet = tweets[0]
    return {'text'=>tweet['text'], 'when'=>tweet['created_at'], 'id'=>tweet['id']}
    #return "twitter placeholder"
  end
  def rel_date(date)
    date = Date.parse(date, true) unless /Date.*/ =~ date.class.to_s
    days = (date - Date.today).to_i

    return 'today'     if days >= 0 and days < 1
    return 'tomorrow'  if days >= 1 and days < 2
    return 'yesterday' if days >= -1 and days < 0

    return "in #{days} days"      if days.abs < 60 and days > 0
    return "#{days.abs} days ago" if days.abs < 60 and days < 0

    return date.strftime('%A, %B %e') if days.abs < 182
    return date.strftime('%A, %B %e, %Y')
  end
end
