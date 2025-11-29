-- =========================================================================
-- 1. BASE CONFIGURATION (vim.opt for core settings)
-- =========================================================================

-- Line Numbers (Essential for Vim movement)
vim.opt.number = true             -- Turn on absolute line numbers
vim.opt.relativenumber = true     -- Turn on relative line numbers

-- Appearance and Colors
vim.opt.termguicolors = true      -- Enable 24-bit color
vim.opt.mouse = 'a'               -- Enable mouse support in all modes
vim.opt.cursorline = true         -- Highlight the current line

-- Indentation and Spacing
vim.opt.tabstop = 4               -- Number of spaces a <Tab> counts for
vim.opt.shiftwidth = 4            -- Size of an indent step
vim.opt.expandtab = true          -- Convert tabs to spaces (using spaces is standard)
vim.opt.breakindent = true        -- Maintain indent when wrapping lines

-- Search Settings
vim.opt.incsearch = true          -- Highlight matches as you type
vim.opt.hlsearch = true           -- Highlight all search matches
vim.opt.ignorecase = true         -- Ignore case in search patterns
vim.opt.smartcase = true          -- Don't ignore case if search pattern contains uppercase

-- System Commands (Must be done via vim.cmd or they won't execute as options)
vim.cmd('filetype plugin indent on') -- Enable filetype detection and indentation
vim.cmd('syntax on')                 -- Enable syntax highlighting


-- =========================================================================
-- 2. PLUGIN MANAGER SETUP (lazy.nvim)
-- =========================================================================

-- Define the path for lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check if lazy.nvim is already installed, if not, clone it
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath) -- Add lazy.nvim to the runtime path


-- =========================================================================
-- 3. PLUGIN DEFINITIONS (The Visuals and Functionality)
-- =========================================================================

require("lazy").setup({

  -- -----------------------------------------------------------------------
  -- VISUALS: STATUSLINE (The Mode/File Indicator)
  -- -----------------------------------------------------------------------
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Needs devicons for fancy icons
    config = function()
      require('lualine').setup({
        options = {
          theme = 'auto', -- Automatically use the colorscheme defined above
          component_separators = { left = '', right = ''}, -- Optional: fancy separators
          section_separators = { left = '', right = ''},  -- Optional: fancy separators
        },
        sections = {
          lualine_a = {'mode'}, -- CRITICAL: This is the colored mode indicator
        },
      })
    end,
  },
  
  -- -----------------------------------------------------------------------
  -- FUNCTIONALITY: ICONS
  -- -----------------------------------------------------------------------
  {
    'nvim-tree/nvim-web-devicons', -- Provides icons for Lualine and file explorers
  },

  -- -----------------------------------------------------------------------
  -- FUNCTIONALITY: FILE NAVIGATION (Highly Recommended)
  -- -----------------------------------------------------------------------
  {
      'nvim-tree/nvim-tree.lua',
      config = function()
          require("nvim-tree").setup {}
      end
  },
  {
    'RedsXDD/neopywal.nvim',
    name = 'neopywal',
    lazy = false,
    priority = 1000,
    config = function()
        require("neopywal").setup({
         transparent_background = false, -- Your desired option
        terminal_colors = true,       -- Recommended for pywal integration
        })
        vim.cmd("colorscheme neopywal")
    end
  },
  {
    'elkowar/yuck.vim',
    ft = 'yuck', -- Ensures the filetype is recognized
  },

})

