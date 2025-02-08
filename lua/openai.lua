local M = {}
local is_debug = false

M.api_key = ""
M.model = "gpt-4o-mini"
M.endpoint = "https://api.openai.com/v1/chat/completions"

local function parse_response(response)
  if response and response.choices and response.choices[1] then
    return response.choices[1].message.content
  else
    print("Failed to generate doc block: " .. (response.error and response.error.message or "Unknown error"))
    return false
  end
end

local function send_request(payload)
  -- Curl command with correctly formatted JSON
  local curl_cmd = string.format(
    "curl -s -X POST %s " .. '-H "Authorization: Bearer %s" ' .. '-H "Content-Type: application/json" ' .. "-d '%s'",
    M.endpoint,
    M.api_key,
    payload
  )

  -- Execute the API request
  local result = vim.fn.system(curl_cmd)
  local response = vim.fn.json_decode(result)

  if is_debug then
    local file_path = vim.fn.expand(vim.fn.stdpath("state") .. "/doc-gen.log")
    local file = io.open(file_path, "a")
    if file then
      file:write("\n---\n" .. payload .. "\n")
      file:write("\n---\n" .. result .. "\n")
      file:close()
    else
      print("could open file")
    end
  end

  return response
end

local function make_payload(prompt)
  local file_ext = vim.bo.filetype

  return vim.fn.json_encode({
    model = M.model,
    messages = {
      {
        role = "system",
        content = string.format(
          "You are an AI that generates code documentation for %s files, you will always retun the doc block ready to be inserted in the code, without any markdown or any other tags",
          file_ext
        ),
      },
      {
        role = "user",
        content = "Generate a Doc block for this code:\n" .. prompt,
      },
    },
  })
end

function M.set_apikey(key)
  M.api_key = key
  return M
end

function M.set_model(model)
  M.model = model
  return M
end

function M.ask(prompt)
  if M.api_key == "" then
    print("Please configure the command to retrieve the Openai api key {get_key_cmd: 'cmd'}")
    return
  end

  local response = send_request(make_payload(prompt))

  return parse_response(response)
end

return M
