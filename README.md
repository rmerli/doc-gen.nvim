# doc-gen.nvim

A Neovim plugin for generating functions doc comments using OpenAI's GPT API.

## Installation (LazyVim)

To install `doc-gen.nvim` using LazyVim, add the following to your LazyVim plugin configuration:

```lua
return {
  {
    "rmerli/doc-gen.nvim",
    config = function()
      require("doc-gen").setup({
        get_key_cmd = "cmd_to_get_api_key", -- cmd needs to return only the api-key
      })
    end,
  },
}
```

## Requirements

- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- An OpenAI API key

## Usage

Run the command to generate a doc block:

```vim
:GenFunDoc
```
This will analyze the function under the cursor and insert the generated Doc block above it.

## Configuration

You can customize the plugin in your Neovim configuration:

```lua
require("doc-gen").setup({
    get_key_cmd = "cmd_to_get_api_key", -- cmd needs to return only the api-key
    model = "gpt-4o-mini", --default
})
```
## Adding keymaps

You can add keymap like this:

```lua
vim.keymap.set('n', '<leader>gd', ':GenFunDoc<CR>', {})
```
## License

MIT License

