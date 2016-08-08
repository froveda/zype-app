# Zype Video Example App

This is an example application using the Zype api to login a user and to list and show videos.

## Login
For the login part of the application, I use [Warden](https://github.com/hassox/warden) along with ActiveModel (for [User](https://github.com/froveda/zype-app/blob/master/app/models/user.rb) model), since all the login activity is done through Zype login api.

The login strategy is in [ZypeLoginStrategy](https://github.com/froveda/zype-app/blob/master/lib/strategies/zype_login_strategy.rb) module:
```
lib/strategies/zype_login_strategy.rb
```
It calls to:
```
https://login.zype.com/oauth/token
```
with the correct parameters and wait for a 200 response and an access_token value. If it happens, it initializes a new User and then sign in in the system. Otherwise, it will call warden fail!.

In [**SessionsController**](https://github.com/froveda/zype-app/blob/master/app/controllers/sessions_controller.rb) I manage the login of the user using warden. If the login is successful, it will redirect to the previous page. If not, Warden is configured in [*application.rb*](https://github.com/froveda/zype-app/blob/master/config/application.rb#L16) to redirect to [**SessionsController#login_fail**](https://github.com/froveda/zype-app/blob/master/app/controllers/sessions_controller.rb#L13):

```
manager.failure_app = ->(env){ SessionsController.action(:login_fail).call(env) }
```

which will render [**SessionsController#new**](https://github.com/froveda/zype-app/blob/master/app/controllers/sessions_controller.rb#L4) with an error message.

## Videos listing and show
### List of Videos
The root of the application is in [**HomeController#index**](https://github.com/froveda/zype-app/blob/master/app/controllers/home_controller.rb#L2). Through an ajax call, it calls to [**VideosController#index**](https://github.com/froveda/zype-app/blob/master/app/controllers/videos_controller.rb#L3) to get the list of videos. In subsequent calls (clicking in previous or next links in home index) it asks for new video pages.

The Video api is being call through [ZypeApi](https://github.com/froveda/zype-app/blob/master/lib/zype_api.rb) module.

Calling [*ZypeApi.get_videos(page)*](https://github.com/froveda/zype-app/blob/master/lib/zype_api.rb#L2), I get the list of videos in that page calling
```
https://api.zype.com/videos?app_key=#{ENV['APP_KEY']}&page=#{page}
```

### Show a Video
To show a video, we access to [**VideosController#show**](https://github.com/froveda/zype-app/blob/master/app/controllers/videos_controller.rb#L11) with a *video_id* got from Zype api, and then calls to
```
https://api.zype.com/videos/#{video_id}?app_key=#{ENV['APP_KEY']}
```
through [*ZypeApi.self.get_video(video_id)*](https://github.com/froveda/zype-app/blob/master/lib/zype_api.rb#L16).

If the video is not *subscription_required*, then I use
```
div id="zype_#{@video_id}"
script src="https://player.zype.com/embed/#{@video_id}.js?autoplay=true&app_key=#{ENV['APP_KEY']}" type="text/javascript"
```

If the video is *subscription_required* and the user is not logged in, then a paywall subscription form is shown to allow the user to sign in. Otherwise, the video is being shown using:
```
div id="zype_#{@video_id}"
script src="https://player.zype.com/embed/#{@video_id}.js?autoplay=true&access_token=#{current_user['access_token']} " type="text/javascript"
```
## Considerations
- I use [bootstrap-sass](https://github.com/twbs/bootstrap-sass) gem to include bootstrap 3 components into the application
- A live version of the application is hosted on Heroku. [click here](https://zype-videos.herokuapp.com/) to access it.
- I have not used ActiveRecord to store users since right now I use the Zype login api to get the data that I need. But in the future, it is possible to use ActiveRecord for users if there is a need to do this
