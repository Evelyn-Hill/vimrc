print("Hello")
require("evelynhill")

require("mason").setup()
require("mason-lspconfig").setup({
        ensure_installed = {"lua_ls", "gopls", "gdscript" }
})

require("lspconfig").lua_ls.setup {}

require("lspconfig").gdscript.setup {}
local pipepath = vim.fn.stdpath("cache") .. "/server.pipe"
if not vim.loop.fs_stat(pipepath) then
  vim.fn.serverstart(pipepath)
end

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false
