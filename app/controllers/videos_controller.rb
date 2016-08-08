class VideosController < ApplicationController
  include ZypeApi
  def index
    response = ZypeApi.get_videos(params[:page] || 1)
    @pagination = response[:pagination]
    @videos = response[:videos]

    render layout: false
  end

  def show
    @video_id = params[:id]
    @video = ZypeApi.get_video(@video_id)
    @subscription_required = @video[:videos]['subscription_required']
  end
end