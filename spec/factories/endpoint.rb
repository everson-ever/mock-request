FactoryBot.define do
  factory :endpoint do
    endpoint { '/server/a/users' }
    request_method { 'GET' }
    content_type { 'text/plain' }
    status_code { 200 }
    delay { 0 }
    response_body { 'Hello World' }
    association :client
  end
end
