local BasePlugin = require "kong.plugins.base_plugin"
local cjson = require "cjson"


local kong = kong
local tostring = tostring
local init_worker_called = false


local ShortCircuitHandler = BasePlugin:extend()


ShortCircuitHandler.PRIORITY = math.huge


function ShortCircuitHandler:new()
  ShortCircuitHandler.super.new(self, "short-circuit")
end


function ShortCircuitHandler:init_worker()
  init_worker_called = true
end


function ShortCircuitHandler:access(conf)
  ShortCircuitHandler.super.access(self)
  return kong.response.exit(conf.status, {
    status  = conf.status,
    message = conf.message,
  }, {
    ["Kong-Init-Worker-Called"] = tostring(init_worker_called),
  })
end


function ShortCircuitHandler:preread(conf)
  ShortCircuitHandler.super.preread(self)
  local message = cjson.encode({
    status             = conf.status,
    message            = conf.message,
    init_worker_called = init_worker_called,
  })
  return kong.response.exit(conf.status, message)
end


return ShortCircuitHandler
