vim.cmd('source ~/.vimrc')

require "user.plugins"

-- coq_nvim
vim.g.coq_settings = { auto_start = "shut-up" }
require "coq"
