json.array!(@tests) do |test|
  json.extract! test, :id, :att1, :att2
  json.url test_url(test, format: :json)
end
