-- Install/clone lazy.nvim if not present.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    local repo = 'https://github.com/folke/lazy.nvim.git'
    vim.fn.system({
        'git', 'clone', '--filter=blob:none', repo, '--branch=main', lazypath
    })
end
-- Ensure it's part of the runtime path.
vim.opt.rtp:prepend(lazypath)

-- Load all the plugins.
require('lazy').setup({ import = 'speck.lazy_plugins' }, {})
