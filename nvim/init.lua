vim.cmd('source ~/.vimrc')

require "user.plugins"

-- Comment.nvim
require('Comment').setup()

require'nvim-treesitter.configs'.setup {
  -- nvim-ts-context-commentstring
  context_commentstring = {
    enable = true
  }
}

-- vim.opt.foldmethod     = 'expr'
-- vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
---WORKAROUND
vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
  group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
  callback = function()
    vim.opt.foldmethod     = 'expr'
    vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
  end
})
---ENDWORKAROUND
