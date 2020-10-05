# Replace API_KEY and API_SECRET with the values you got from Twitter
Rails.application.config.middleware.use OmniAuth::Builder do
    provider :twitter, "XGkMptXseBljjCjuFRWg4q3yO", "gGx0nJXf4YaYHjcUnUjz3k8hMW6sCZK8fxusm6OXlglTbFcn6V"
end

def OmniAuth.login_path(provider)
    "/auth/#{provider}"
end