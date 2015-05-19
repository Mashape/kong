local BaseController = require "kong.api.routes.base_controller"

local Consumers = BaseController:extend()

function Consumers:new()
  Consumers.super.new(self, dao.consumers, "consumers")
end

return Consumers
