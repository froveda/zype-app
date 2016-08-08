module ZypeApi
  def self.get_videos(page)
    require "uri"
    require "net/http"

    response = Net::HTTP.get(URI("https://api.zype.com/videos?app_key=#{ENV['APP_KEY']}&page=#{page}"))

    response = JSON.parse(response)

    {
        videos: response['response'],
        pagination: response['pagination']
    }
  end

  def self.get_video(video_id)
    require "uri"
    require "net/http"
    response = Net::HTTP.get(URI("https://api.zype.com/videos/#{video_id}?app_key=#{ENV['APP_KEY']}"))

    response = JSON.parse(response)

    {
        videos: response['response'],
        pagination: response['pagination']
    }
  end
end