Rails.application.routes.draw do
  root to: "api/v1/home#index"

  namespace :api do
    namespace :v1 do
      scope "routes" do
        get ":client/:endpoint", to: "routes#index",
          constraints: { endpoint: /[0-z\.\/\-\_\?]+/ }
      end

      scope "clients" do
        get ":url", to: "clients#show"
        post "", to: "clients#create"
      end

      scope "endpoints" do
        post "", to: "endpoints#create"
        delete ":request_method/:client/:endpoint", to: "endpoints#destroy",
          constraints: { endpoint: /[0-z\.\/\-\_\?]+/ }
      end
    end
  end
end
