-- ┌─────────────────────────┐
-- │ Plugins outside of MINI │
-- └─────────────────────────┘
--
-- This file contains installation and configuration of plugins outside of MINI.
-- They significantly improve user experience in a way not yet possible with MINI.
-- These are mostly plugins that provide programming language specific behavior.
--
-- Use this file to install and configure other such plugins.

-- Make concise helpers for installing/adding plugins in two stages
local add = vim.pack.add
local now_if_args, later = Config.now_if_args, Config.later

-- Tree-sitter ================================================================

-- Tree-sitter is a tool for fast incremental parsing. It converts text into
-- and/or more precise actions: syntax highlighting, textobjects, indent, etc.
--
-- Tree-sitter support is built into Neovim (see `:h treesitter`). However, it
-- requires two extra pieces that don't come with Neovim directly:
-- - Language parsers: programs that convert text into trees. Some are built-in
--   (like for Lua), 'nvim-treesitter' provides many others.
--   NOTE: It requires third party software to build and install parsers.
--   See the link for more info in "Requirements" section of the MiniMax README.
-- - Query files: definitions of how to extract information from trees in
--   a useful manner (see `:h treesitter-query`). 'nvim-treesitter' also provides
--   these, while 'nvim-treesitter-textobjects' provides the ones for Neovim
--   textobjects (see `:h text-objects`, `:h MiniAi.gen_spec.treesitter()`).
--
-- Add these plugins now if file (and not 'mini.starter') is shown after startup.
now_if_args(function ()
    local ts_update = function ()
        vim.cmd('TSUpdate')
    end
    Config.on_packchanged('nvim-treesitter', { 'update' }, ts_update, ':TSUpdate')

    add({
        'https://github.com/nvim-treesitter/nvim-treesitter',
        'https://github.com/nvim-treesitter/nvim-treesitter-textobjects'
    })

    -- Define languages which will have parsers installed and auto enabled
    local languages = {
        -- These are already pre-installed with Neovim. Used as an example.
        'lua',
        'vimdoc',
        'markdown',
        'go',
        'sql',
        'yaml',
        'toml',
        'rust',
        'json',
        'python',
        'html',
        'dockerfile',
        'css',
        'gitignore',
        'blade',
        'tsx',
        'haskell',
        'supercollider',
        'ron',
        'svelte',
        'nix'
        -- Add here more languages with which you want to use tree-sitter
        -- To see available languages:
        -- - Execute `:=require('nvim-treesitter').get_available()`
        -- - Visit 'SUPPORTED_LANGUAGES.md' file at
        --   https://github.com/nvim-treesitter/nvim-treesitter/blob/main
    }
    local isnt_installed = function (lang)
        return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
    end
    local to_install = vim.tbl_filter(isnt_installed, languages)
    if #to_install > 0 then require('nvim-treesitter').install(to_install) end

    -- Enable tree-sitter after opening a file for a target language
    local filetypes = {}
    for _, lang in ipairs(languages) do
        for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
            table.insert(filetypes, ft)
        end
    end
    local ts_start = function (ev)
        vim.treesitter.start(ev.buf)
    end
    Config.new_autocmd('FileType', filetypes, ts_start, 'Start tree-sitter')
end)

-- Language servers ===========================================================

-- Language Server Protocol (LSP) is a set of conventions that power creation of
-- language specific tools. It requires two parts:
-- - Server - program that performs language specific computations.
-- - Client - program that asks server for computations and shows results.
--
-- Here Neovim itself is a client (see `:h vim.lsp`). Language servers need to
-- be installed separately based on your OS, CLI tools, and preferences.
-- See note about 'mason.nvim' at the bottom of the file.
--
-- Neovim's team collects commonly used configurations for most language servers
-- inside 'neovim/nvim-lspconfig' plugin.
--
-- Add it now if file (and not 'mini.starter') is shown after startup.
now_if_args(function ()
    add({ 'https://github.com/neovim/nvim-lspconfig' })

    vim.lsp.config['vtsls'] = {
        settings = {
            vtsls = {
                autoUseWorkspaceTsdk = true
            },
            typescript = {
                updateImportsOnFileMove = { enabled = "always" }
            }
        }
    }

    vim.lsp.config('tsrs', {
        cmd = { './node_modules/tsrs/bin/tsrs', '--lsp', '-stdio' },
        filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
        root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' }
    })

    vim.lsp.config["tailwindcss"] = {
        settings = {
            tailwindCSS = {
                classFunctions = { "cva", "cx" }
            }
        }
    }

    vim.lsp.config["rust_analyzer"] = {
        settings = {
            ["rust-analyzer"] = {
                check = { command = "clippy" }
            }
        }
    }

    -- Use `:h vim.lsp.enable()` to automatically enable language server based on
    -- the rules provided by 'nvim-lspconfig'.
    -- Use `:h vim.lsp.config()` or 'after/lsp/' directory to configure servers.
    -- Uncomment and tweak the following `vim.lsp.enable()` call to enable servers.
    vim.lsp.enable({
        'gopls',
        'vtsls',
        -- 'tsrs',
        'rust_analyzer',
        -- 'lua_ls',
        'emmylua_ls',
        -- 'ts_ls',
        'html',
        'emmet_language_server',
        'yamlls',
        'docker_language_server',
        'clangd',
        'cssls',
        'tailwindcss',
        'ruff',
        'basedpyright',
        'copilot_ls',
        'svelte',
        'taplo',
        'nixd',
        'just'
        -- For example, if `lua-language-server` is installed, use `'lua_ls'` entry
    })
end)

-- Formatting =================================================================

-- Programs dedicated to text formatting (a.k.a. formatters) are very useful.
-- Neovim has built-in tools for text formatting (see `:h gq` and `:h 'formatprg'`).
-- They can be used to configure external programs, but it might become tedious.
--
-- The 'stevearc/conform.nvim' plugin is a good and maintained solution for easier
-- formatting setup.
later(function ()
    add({ 'https://github.com/stevearc/conform.nvim' })

    -- See also:
    -- - `:h Conform`
    -- - `:h conform-options`
    -- - `:h conform-formatters`
    require('conform').setup({
        formatters_by_ft = {
            go = { 'gofmt', 'lsp' },
            sql = { 'sqlfluff' },
            json = { 'biome' },
            rust = { 'rustfmt' },
            javascript = { "biome" },
            typescript = { "biome" },
            javascriptreact = { "biome" },
            typescriptreact = { "biome" },
            python = { "ruff" },
            toml = { 'taplo' },
            nix = { "nixfmt" }
        },
        format_on_save = {
            lsp_format = "fallback",
            timeout_ms = 500
        }
    })
end)

-- Snippets ===================================================================

-- Although 'mini.snippets' provides functionality to manage snippet files, it
-- deliberately doesn't come with those.
--
-- The 'rafamadriz/friendly-snippets' is currently the largest collection of
-- snippet files. They are organized in 'snippets/' directory (mostly) per language.
-- 'mini.snippets' is designed to work with it as seamlessly as possible.
-- See `:h MiniSnippets.gen_loader.from_lang()`.
later(function ()
    add({ 'https://github.com/rafamadriz/friendly-snippets' })
end)

-- Honorable mentions =========================================================

-- 'mason-org/mason.nvim' (a.k.a. "Mason") is a great tool (package manager) for
-- installing external language servers, formatters, and linters. It provides
-- a unified interface for installing, updating, and deleting such programs.
--
-- The caveat is that these programs will be set up to be mostly used inside Neovim.
-- If you need them to work elsewhere, consider using other package managers.
--
-- You can use it like so:
now_if_args(function ()
    add({ 'https://github.com/mason-org/mason.nvim' })
    require('mason').setup()
end)

-- Beautiful, usable, well maintained color schemes outside of 'mini.nvim' and
-- have full support of its highlight groups. Use if you don't like 'miniwinter'
-- enabled in 'plugin/30_mini.lua' or other suggested 'mini.hues' based ones.
Config.now(function ()
    add({ 'https://github.com/rebelot/kanagawa.nvim' })

    require("kanagawa").setup({
        compile = true,
        keywordStyle = { italic = false },
        blend = vim.o.pumblend,
        colors = {
            theme = {
                all = {
                    ui = {
                        bg_gutter = "none"
                    }
                }
            }
        },
        transparent = false,
        overrides = function (colors)
            local theme = colors.theme

            local makeDiagnosticColor = function (color)
                local c = require("kanagawa.lib.color")
                return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
            end

            return {
                NormalFloat = { bg = "none" },
                FloatBorder = { bg = "none" },
                FloatTitle  = { bg = "none" },

                -- Save an hlgroup with dark background and dimmed foreground
                -- so that you can use it where your still want darker windows.
                -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
                NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

                -- Popular plugins that open floats will link to NormalFloat by default;
                -- set their background accordingly if you wish to keep them dark and borderless
                LazyNormal  = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

                Pmenu      = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
                PmenuSel   = { fg = "NONE", bg = theme.ui.bg_p2 },
                PmenuSbar  = { bg = theme.ui.bg_m1 },
                PmenuThumb = { bg = theme.ui.bg_p2 },

                DiagnosticVirtualTextHint  = makeDiagnosticColor(theme.diag.hint),
                DiagnosticVirtualTextInfo  = makeDiagnosticColor(theme.diag.info),
                DiagnosticVirtualTextWarn  = makeDiagnosticColor(theme.diag.warning),
                DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error)
            }
        end,
        theme = "dragon",
        background = {
            dark = "dragon",
            light = "lotus"
        }
    })

    vim.cmd('colorscheme kanagawa')

    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "kanagawa",
        callback = function ()
            if vim.o.background == "light" then
                vim.fn.system("kitty +kitten themes Kanagawa_light")
            elseif vim.o.background == "dark" then
                vim.fn.system("kitty +kitten themes Kanagawa_dragon")
            else
                vim.fn.system("kitty +kitten themes Kanagawa")
            end
        end
    })
end)

later(function ()
    add({ 'https://github.com/folke/zen-mode.nvim' })
end)

-- MiniDeps.now(function()
--     add('https://github.com/vyfor/cord.nvim')
--
--     require('cord').setup({
--         editor = {
--             client = "neovim",
--             tooltip = "How do I exit Vim?",
--         },
--         text = {
--             default = "Running sudo rm -rf /",
--             workspace = "",
--             viewing = nil,
--             editing = nil,
--             file_browser = nil,
--             terminal = nil,
--             dashboard = nil,
--         },
--     })
-- end)
--
-- vim.api.nvim_create_autocmd('PackChanged', {
--     callback = function(opts)
--         if opts.data.spec.name == 'cord.nvim' and opts.data.kind == 'update' then
--             vim.cmd 'Cord update'
--         end
--     end
-- })

now_if_args(function ()
    add({ 'https://github.com/obsidian-nvim/obsidian.nvim' })
    -- add({ 'https://github.com/MeanderingProgrammer/render-markdown.nvim' })
    require('obsidian').setup({
        legacy_commands = false,
        workspaces = {
            {
                name = "personal",
                path = "~/Documents/Notes"
            }
        }
    })
end)

Config.now(function ()
    add({ 'https://github.com/mg979/vim-visual-multi' })
    add({ 'https://github.com/JoosepAlviste/nvim-ts-context-commentstring' })
    add({ "https://github.com/windwp/nvim-ts-autotag" })
    require('ts_context_commentstring').setup { enable_autocmd = false }
    require('nvim-ts-autotag').setup({})
end)

-- Config.now(function()
--     add({
--         "https://github.com/thgrund/tidal.nvim",
--     })
--
--     require("tidal").setup()
-- end)

later(function ()
    add({ "https://github.com/MunifTanjim/nui.nvim" })
    add({ "https://github.com/folke/noice.nvim" })

    require("noice").setup({
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true
                -- ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
            }
        },
        -- you can enable a preset for easier configuration
        presets = {
            bottom_search = true,         -- use a classic bottom cmdline for search
            command_palette = true,       -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false,           -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = true         -- add a border to hover docs and signature help
        },
        popupmenu = {
            enabled = false
        },
        views = {
            popupmenu = {
                border = {
                    style = "rounded"
                }
            }
        }
    })
end)
