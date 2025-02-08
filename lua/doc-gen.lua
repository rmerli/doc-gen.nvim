local doc_gen = require("api")

local function check_type(name, val, ref, allow_nil)
  if type(val) == ref or (ref == "callable" and vim.is_callable(val)) or (allow_nil and val == nil) then
    return
  end
  print(string.format("`%s` should be %s, not %s", name, ref, type(val)))
end

function doc_gen.setup(config)
  check_type("config", config, "table", true)
  config = vim.tbl_deep_extend("force", vim.deepcopy(doc_gen.defaultConfig), config or {})

  doc_gen.apply_config(config)

  vim.api.nvim_create_user_command("GenFunDoc", function()
    doc_gen.generate_function_doc()
  end, { desc = "generates doc block" })
end

return doc_gen
