local M = {}
local ts_service = require("ts_service")
local chatgpt = require("openai")

M.defaultConfig = {
  model = "gpt-4o-mini",
  get_key_cmd = "",
}

M.config = {}

local function get_api_key()
  if M.config.get_key_cmd == "" then
    return false
  end

  local api_key, _ = string.gsub(vim.fn.system(M.config.get_key_cmd), "\n", "")
  return api_key
end

function M.apply_config(config)
  M.config = config
  M.config.api_key = get_api_key()
end

function M.generate_function_doc()
  local prompt = ts_service.get_node_text()

  if not prompt then
    return
  end

  local doc = chatgpt.set_apikey(M.config.api_key).set_model(M.config.model).ask(prompt)

  if doc ~= false then
    ts_service.set_text_before_node(doc)
    vim.lsp.buf.format()
  end
end

return M
