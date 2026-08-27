local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.tbl_islist = vim.islist or vim.tbl_islist
vim.g.markdown_fenced_languages = { "js=javascript", "ts=typescript" }

require("vim-options")
require("lazy").setup("plugins")
