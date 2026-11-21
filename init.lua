-- tab to spaces
vim.opt.expandtab = true
vim.opt.tabstop = 4     -- a tab counts as 4 spaces (visually)
vim.opt.shiftwidth = 4  -- indent operations (>>, <<, autoindent) use 4 spaces
vim.opt.softtabstop = 4 -- pressing Tab/Backspace acts like 4 spaces

-- leader:
vim.g.mapleader = " "
vim.g.maplocalleader = ' '

-- Make line numbers default and relative to cursor
vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  See `:help 'clipboard'`
vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list' and `:help 'listchars'`
--
--  listchars is set using `vim.opt` instead of `vim.o`.
--  opt offers an interface for conveniently interacting with tables.
--   See `:help lua-options` `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Folds
vim.opt.foldenable = true
vim.opt.foldlevel = 99      -- start with everything open
vim.opt.foldlevelstart = 99 -- same, applied per new buffer
vim.opt.foldtext = ""
vim.opt.foldnestmax = 10

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- NOTE: move autocmd

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

---------------------------- LSP configurations ----------------------------

-- Commands
-- ctrl-]          -> go to definition
-- gq              -> format selected text or text object
-- shift + k       -> display documentation of the symbol under the cursor
-- ctrl-x + ctrl-o -> in insert mode, trigger code completion
-- grn        -> renames all references of the symbol under the cursor
-- gra        -> list code actions available in the line under the cursor
-- grr        -> lists all the references of the symbol under the cursor
-- gri        -> lists all the implementations for the symbol under the cursor
-- grt        -> jump to the definition of the type symbol under the cursor
-- gO         -> lists all symbols in the current buffer
-- ctrl-s     -> in insert mode, display function signature under the cursor
-- [d         -> jump to previous diagnostic in the current buffer
-- ]d         -> jump to next diagnostic in the current buffer
-- ctrl-w + d -> show error/warning message in the line under the cursor

-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(args)
--     local bufnr = args.buf
--     local opts = { buffer = bufnr }
--     vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
--     vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
--     vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
--     vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
--     vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
--     vim.keymap.set("n", "<leader>f", function()
--       vim.lsp.buf.format({ async = true })
--     end, opts)
--   end,
-- })

vim.diagnostic.config({
    -- Inline virtual text next to the underline
    virtual_text = {
        prefix = "",
        spacing = 4,
        source = "if_many",                     -- shows [rust-analyzer] when multiple sources exist
        severity = {
            min = vim.diagnostic.severity.HINT, -- show hints too; set to WARN to hide hints
        },
    },

    -- Underlines
    underline = true,

    -- Sort so errors show above warnings in the same line
    severity_sort = true,

    -- Signs in the gutter (colored icons next to line numbers)
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "E",
            [vim.diagnostic.severity.WARN] = "W",
            [vim.diagnostic.severity.HINT] = "H",
            [vim.diagnostic.severity.INFO] = "I",
        },
    },

    -- Floating window shown on hover/cursor-hold (the "tooltip")
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "true",
        header = "",
        prefix = "",
    },
})

-- Generic LSP Commands, which work on any LSP attached to buffer
-- Start LSP
vim.api.nvim_create_user_command("LspStart", function(opts)
    local name = opts.args
    if name ~= "" then
        vim.cmd("edit") -- re-trigger FileType/BufReadPost so vim.lsp.enable configs attach
        vim.lsp.enable(name)
    else
        -- No name given: try to start whatever server(s) match this filetype
        vim.cmd("edit")
    end
end, {
    nargs = "?",
    complete = function()
        return vim.tbl_keys(vim.lsp._enabled_configs or {})
    end,
})

-- Stop LSP
vim.api.nvim_create_user_command("LspStop", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    if #clients == 0 then
        vim.notify("No LSP clients attached to this buffer", vim.log.levels.WARN)
        return
    end

    local names = {}
    for _, client in ipairs(clients) do
        table.insert(names, client.name)
        client:stop()
    end
    vim.notify("Stopped LSP")
end, {})

-- restart LSP
vim.api.nvim_create_user_command("LspRestart", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    if #clients == 0 then
        vim.notify("No LSP clients attached to this buffer", vim.log.levels.WARN)
        return
    end

    local names = {}
    for _, client in ipairs(clients) do
        table.insert(names, client.name)
        client:stop()
    end

    vim.notify("Restarting: " .. table.concat(names, ", "), vim.log.levels.INFO)

    local timer = vim.uv.new_timer()
    timer:start(500, 0, function()
        vim.schedule(function()
            for _, name in ipairs(names) do
                vim.lsp.enable(name)
            end
            vim.cmd("edit")
        end)
        timer:stop()
        timer:close()
    end)
end, {})

-- LSP Log opening
vim.api.nvim_create_user_command("LspLog", function()
    vim.cmd("tabnew " .. vim.lsp.log.get_filename())
end, {})

-- LSP corner
local progress_state = {} -- [client_id] = { token = { title, message, percentage } }

vim.api.nvim_create_autocmd("LspProgress", {
    callback = function(args)
        local client_id = args.data.client_id
        local value = args.data.params.value
        local token = args.data.params.token

        progress_state[client_id] = progress_state[client_id] or {}

        if value.kind == "end" then
            progress_state[client_id][token] = nil
        else
            progress_state[client_id][token] = {
                title = value.title,
                message = value.message,
                percentage = value.percentage,
            }
        end

        render_lsp_corner()
    end,
})

local function get_progress_lines(client_id)
    local lines = {}
    local entries = progress_state[client_id]
    if not entries then return lines end

    for _, entry in pairs(entries) do
        local text = entry.title or ""
        if entry.message then
            text = text .. ": " .. entry.message
        end
        if entry.percentage then
            text = text .. string.format(" (%d%%%%)", entry.percentage)
        end
        table.insert(lines, "  ⏳ " .. text)
    end
    return lines
end


local lsp_corner = { buf = nil, win = nil }

function render_lsp_corner()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    if #clients == 0 then
        if lsp_corner.win and vim.api.nvim_win_is_valid(lsp_corner.win) then
            vim.api.nvim_win_close(lsp_corner.win, true)
            lsp_corner.win = nil
        end
        return
    end

    local lines = {}
    for _, client in ipairs(clients) do
        local diag_counts = vim.diagnostic.count(bufnr)
        local errors = diag_counts[vim.diagnostic.severity.ERROR] or 0
        local warns = diag_counts[vim.diagnostic.severity.WARN] or 0

        table.insert(lines, string.format("󰢐 %s", client.name))
        if errors > 0 or warns > 0 then
            table.insert(lines, string.format("  ✘ %d  ▲ %d", errors, warns))
        end

        for _, pline in ipairs(get_progress_lines(client.id)) do
            table.insert(lines, pline)
        end
    end

    local width = 0
    for _, line in ipairs(lines) do
        width = math.max(width, vim.fn.strdisplaywidth(line))
    end
    width = width + 2

    if not lsp_corner.buf or not vim.api.nvim_buf_is_valid(lsp_corner.buf) then
        lsp_corner.buf = vim.api.nvim_create_buf(false, true)
        vim.bo[lsp_corner.buf].buftype = "nofile"
    end
    vim.api.nvim_buf_set_lines(lsp_corner.buf, 0, -1, false, lines)

    if lsp_corner.win and vim.api.nvim_win_is_valid(lsp_corner.win) then
        vim.api.nvim_win_set_config(lsp_corner.win, {
            relative = "editor",
            anchor = "NE",
            row = 0,
            col = vim.o.columns,
            width = width,
            height = #lines,
        })
    else
        lsp_corner.win = vim.api.nvim_open_win(lsp_corner.buf, false, {
            relative = "editor",
            anchor = "NE",
            row = 0,
            col = vim.o.columns,
            width = width,
            height = #lines,
            style = "minimal",
            border = "none",
            focusable = false,
            noautocmd = true,
            zindex = 50,
        })
        vim.wo[lsp_corner.win].winhighlight = "Normal:NonText"
    end
end

vim.lsp.enable('luals')
vim.lsp.enable('rust-analyzer')
vim.lsp.enable('tslsp')
-- FIXME:nixd LSP seems to be creating a bunch of excess files when it runs. This needs to be figured out
-- vim.lsp.enable('nixd')
vim.lsp.enable('ruff')
vim.lsp.enable('cssls')
vim.lsp.enable('hls')



-- Treesitter

-- neovim filetypes where you want to enable treesitter
local ts_filetypes = {
    'sh', 'rust', 'java', 'python', 'haskell',
    'typescript', 'javascript',
}

vim.api.nvim_create_autocmd('FileType', {
    pattern = ts_filetypes,
    callback = function()
        -- enable syntax highlight
        vim.treesitter.start()

        -- enable folds
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo[0][0].foldmethod = 'expr'
    end
})


-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)


-- Plugins
require("lazy").setup({
    -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).

    -- toggleterm
    {
        'akinsho/toggleterm.nvim',
        opts = {
            open_mapping = [[<C-\>]],
            direction = 'float',
            float_opts = { border = 'rounded', width = 100, height = 25 },
        },
    },

    -- Java
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
        dependencies = {
        },
    },

    -- VimTex
    {
        "lervag/vimtex",
        lazy = false, -- we don't want to lazy load VimTeX
        init = function()
            -- VimTeX configuration goes here
            vim.g.vimtex_view_method = "zathura_simple"
            -- vim.g.vimtex_view_method = "general"
            -- vim.g.vimtex_view_general_viewer = "firefox"
            -- vim.g.vimtex_view_general_options = "--new-tab @pdf"
            vim.g.vimtex_quickfix_mode = 2
            vim.g.vimtex_compiler_method = "latexmk"
            vim.g.vimtex_compiler_latexmk = {
                out_dir = "latex-bin",
                aux_dir = "",
                continuous = 1,
                callback = 1,
                executable = "latexmk",
                hooks = {},
                options = {
                    "-verbose",
                    "-file-line-error",
                    "-synctex=1",
                    "-interaction=nonstopmode",
                },
            }
        end
    },

    -- markdown neovim plugin
    {
        "yousefhadder/markdown-plus.nvim",
        ft = "markdown",
        opts = {
            keymaps = {
                enabled = true,
            },
            table = {
                keymaps = {
                    enabled = true,
                },
            },

        },
    },

    -- Night owl theme
    {
        "oxfist/night-owl.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("night-owl").setup()
            vim.cmd.colorscheme("night-owl")
        end,
    },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter').install({ 'rust' })
        end
    },

    -- which-key shows keybinds and pending keybinds
    {
        'folke/which-key.nvim',
        event = 'VimEnter', -- Sets the loading event to 'VimEnter'
        opts = {
            -- delay between pressing a key and opening which-key (milliseconds)
            -- this setting is independent of vim.o.timeoutlen
            delay = 0,
            icons = {
                -- set icon mappings to true if you have a Nerd Font
                mappings = vim.g.have_nerd_font,
                -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
                -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
                keys = vim.g.have_nerd_font and {} or {
                    Up = '<Up> ',
                    Down = '<Down> ',
                    Left = '<Left> ',
                    Right = '<Right> ',
                    C = '<C-…> ',
                    M = '<M-…> ',
                    D = '<D-…> ',
                    S = '<S-…> ',
                    CR = '<CR> ',
                    Esc = '<Esc> ',
                    ScrollWheelDown = '<ScrollWheelDown> ',
                    ScrollWheelUp = '<ScrollWheelUp> ',
                    NL = '<NL> ',
                    BS = '<BS> ',
                    Space = '<Space> ',
                    Tab = '<Tab> ',
                    F1 = '<F1>',
                    F2 = '<F2>',
                    F3 = '<F3>',
                    F4 = '<F4>',
                    F5 = '<F5>',
                    F6 = '<F6>',
                    F7 = '<F7>',
                    F8 = '<F8>',
                    F9 = '<F9>',
                    F10 = '<F10>',
                    F11 = '<F11>',
                    F12 = '<F12>',
                },
            },

            -- Document existing key chains
            spec = {
                { '<leader>s', group = '[S]earch' },
                { '<leader>t', group = '[T]oggle' },
                { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
            },
        },
    },

    -- Detect tabstop and shiftwidth automatically
    'NMAC427/guess-indent.nvim',

    -- telescope for search box
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                -- for disabling nvim-treesitter for highlights
                defaults = {
                    preview = {
                        treesitter = false
                    }
                }
            })
        end,
    },

    -- neo-tree for file nav side window
    -- {
    --     "nvim-neo-tree/neo-tree.nvim",
    --     branch = "v3.x",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "MunifTanjim/nui.nvim",
    --         "nvim-tree/nvim-web-devicons",
    --     },
    --     lazy = true,
    --     keys = {
    --         { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    --     },
    --     opts = {
    --         filesystem = {
    --             window = {
    --                 mappings = {
    --                     ['\\'] = 'close_window',
    --                 },
    --             },
    --         },
    --     },
    -- },

    -- File operations
    {
        "Crysthamus/nvim-file-operations",
        dependencies = {
            "nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
        },
        config = function()
            require("nvim-file-operations").setup()
        end,
    },

    -- window picker
    {
        "s1n7ax/nvim-window-picker",
        version = "2.*",
        config = function()
            require("window-picker").setup({
                filter_rules = {
                    include_current_win = false,
                    autoselect_one = true,
                    -- filter using buffer options
                    bo = {
                        -- if the file type is one of following, the window will be ignored
                        filetype = { "neo-tree", "neo-tree-popup", "notify" },
                        -- if the buffer type is one of following, the window will be ignored
                        buftype = { "terminal", "quickfix" },
                    },
                },
            })
        end,
    },

    -- autopair bracket/quotes etc
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        opts = {},
    },

    -- Add indentation guides even on blank lines
    {
        {
            'lukas-reineke/indent-blankline.nvim',
            -- Enable `lukas-reineke/indent-blankline.nvim`
            -- See `:help ibl`
            main = 'ibl',
            opts = {},
        },
    },

    -- Adds git related signs to the gutter, as well as utilities for managing changes
    -- TODO: add options
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        },
    },

    -- Highlight todo, notes, etc in comments
    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

    { -- Autoformat
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        cmd = { 'ConformInfo' },
        keys = {
            {
                '<leader>f',
                function()
                    require('conform').format { async = true, lsp_format = 'fallback' }
                end,
                mode = '',
                desc = '[F]ormat buffer',
            },
        },
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                -- Disable "format_on_save lsp_fallback" for languages that don't
                -- have a well standardized coding style. You can add additional
                -- languages here or re-enable it for the disabled ones.
                local disable_filetypes = { c = true, cpp = true }
                if disable_filetypes[vim.bo[bufnr].filetype] then
                    return nil
                else
                    return {
                        timeout_ms = 500,
                        lsp_format = 'fallback',
                    }
                end
            end,
            formatters_by_ft = {
                lua = { 'stylua' },
                -- Conform can also run multiple formatters sequentially
                -- python = { "isort", "black" },
                --
                -- You can use 'stop_after_first' to run the first available formatter from the list
                -- javascript = { "prettierd", "prettier", stop_after_first = true },
            },
        },
    },

    {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        dependencies = { 'rafamadriz/friendly-snippets' },

        -- use a release tag to download pre-built binaries
        version = '1.*',
        -- AND/OR build from source
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source with:
        -- build = 'nix run .#build-plugin',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = { preset = 'default' },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono'
            },

            -- (Default) Only show the documentation popup when manually triggered
            completion = { documentation = { auto_show = false } },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" }
    },

})

-- Telescope keymaps
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Find text with grep" })
vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Find in open files" })

-- find all files
vim.keymap.set("n", "<leader>sa", function()
    require("telescope.builtin").find_files({
        hidden = true,
        no_ignore = true,
        no_ignore_parent = true,
    })
end, { desc = "Find all files" })

-- literate programming
-- treat lhs as tex
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.lhs",
    callback = function() vim.bo.filetype = "lhaskell" end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "lhaskell",
    callback = function()
        if not vim.b.vimtex then
            vim.fn["vimtex#init"]()
        end
    end,
})

local function toggle_quickfix()
    local qf_open = vim.fn.getqflist({ winid = 0 }).winid ~= 0
    if qf_open then
        vim.cmd("cclose")
    else
        vim.cmd("copen")
    end
end

vim.keymap.set("n", "<leader>lQ", toggle_quickfix, { desc = "Toggle quickfix window" })
