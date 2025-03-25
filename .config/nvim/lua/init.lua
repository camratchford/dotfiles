require('everforest').setup {
  background = "medium",
  transparent_background_level = 0,
  italics = true,
  disable_italic_comments = true
}

require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "python", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "yaml" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "all"},

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

require('glow').setup({
  glow_path = "", -- will be filled automatically with your glow bin in $PATH, if any
  install_path = "~/.local/bin", -- default path for installing glow binary
  border = "shadow", -- floating window border config
  style = "dark|light", -- filled automatically with your current editor background, you can override using glow json style
  pager = false,
  width = 80,
  height = 100,
  width_ratio = 0.7, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
  height_ratio = 0.7,
})
yaml = require("yaml_nvim")
toc = require("nvim-toc")
toc.setup({toc_header = "Table of Contents"})

require('markdown-togglecheck').setup({
  -- create empty checkbox on item without any while toggling
  create = true,
  -- remove checked checkbox instead of unckecking it while toggling
  remove = false,
})

require('nvim-search-and-replace').setup{
    -- file patters to ignore
    ignore = {
        '**/node_modules/**',
        '**/.git/**',
        '**/.gitignore',
        '**/.gitmodules',
        'build/**',
        '**/venv/**',
        '**/.venv/**'
    },
    -- save the changes after replace
    update_changes = false,
    -- keymap for search and replace
    replace_keymap = '<C-F2>',
    -- keymap for search and replace ( this does not care about ignored files )
    replace_all_keymap = '<C-A-F2>',
    -- keymap for search and replace
    replace_and_save_keymap = '',
    -- keymap for search and replace ( this does not care about ignored files )
    replace_all_and_save_keymap = '',
}

require('nvim-ts-autotag').setup({
  opts = {
    -- Defaults
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    enable_close_on_slash = false -- Auto close on trailing </
  },
  -- Also override individual filetype configs, these take priority.
  -- Empty by default, useful if one of the "opts" global settings
  -- doesn't work well in a specific filetype
  per_filetype = {
  }
})


require("nvim-autopairs").setup()

require("auto-save").setup({
  enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
  trigger_events = { -- See :h events
    immediate_save = { "BufLeave", "FocusLost" }, -- vim events that trigger an immediate save
    defer_save = { "InsertLeave", "TextChanged" }, -- vim events that trigger a deferred save (saves after `debounce_delay`)
    cancel_deferred_save = { "InsertEnter" }, -- vim events that cancel a pending deferred save
  },
  -- function that takes the buffer handle and determines whether to save the current buffer or not
  -- return true: if buffer is ok to be saved
  -- return false: if it's not ok to be saved
  -- if set to `nil` then no specific condition is applied
  condition = nil,
  write_all_buffers = false, -- write all buffers when the current one meets `condition`
  noautocmd = false, -- do not execute autocmds when saving
  lockmarks = false, -- lock marks when saving, see `:h lockmarks` for more details
  debounce_delay = 1000, -- delay after which a pending save is executed
 -- log debug messages to 'auto-save.log' file in neovim cache directory, set to `true` to enable
  debug = false,
})


