local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

local function get_ts_node()
  local node = ts_utils.get_node_at_cursor()
  while node do
    if node:type() == "function_definition" or node:type() == "method_declaration" then
      return node
    end
    node = node:parent()
  end
  return nil
end

local function get_lines_in_node_range(node)
  if not node then
    return nil
  end
  local start_row, _, end_row, _ = node:range()
  local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)
  return table.concat(lines, "\n")
end

function M.set_text_before_node(text)
  local start_row, _ = M.node:start()
  vim.fn.append(start_row, vim.split(text, "\n"))
end

function M.get_node_text()
  local node = get_ts_node()

  if not node then
    print("Nothing to generate")
    return
  end

  M.node = node

  local function_body = get_lines_in_node_range(node)
  if not function_body or function_body == "" then
    print("Failed to extract function body.")
    return
  end
  return function_body
end

return M
