Rack::Attack.throttle("wish_min_limit", limit: 15, period: 60) do |req|
  if req.path == '/api/wishs' && req.post?
    req.env['HTTP_X_TOKEN']
  end
end

Rack::Attack.throttle("super_wish_love_power_limit", limit: 1, period: 120) do |req|
  if req.path == '/api/super_wishs' && req.post?
    req.params['love_power']
  end
end
