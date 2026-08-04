local function get_visual_selection()
  local reg_save = vim.fn.getreg("z")
  local regtype_save = vim.fn.getregtype("z")
  vim.cmd('noautocmd normal! "zy')
  local text = vim.fn.getreg("z")
  vim.fn.setreg("z", reg_save, regtype_save)
  return text
end

return {
  { "folke/which-key.nvim", lazy = true },

  -- Loaded eagerly (not lazy) since config/lsp.lua needs its 
  -- `default_capabilities()` helper at startup, before nvim-cmp itself loads.
  { "hrsh7th/cmp-nvim-lsp" },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping(function(fallback)
            fallback()
          end, { "i", "s" }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true })
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
        }),
      })
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
    },
    config = function()
      require("nvim-tree").setup()

      -- If nvim-tree is the only window left after :q closes the current
      -- window, close nvim-tree too instead of leaving it open alone.
      vim.api.nvim_create_autocmd("QuitPre", {
        callback = function()
          local tree_wins = {}
          local floating_wins = {}
          local wins = vim.api.nvim_list_wins()
          for _, w in ipairs(wins) do
            local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
            if vim.api.nvim_win_get_config(w).relative ~= "" then
              table.insert(floating_wins, w)
            elseif bufname:match("NvimTree_") ~= nil then
              table.insert(tree_wins, w)
            end
          end
          if #tree_wins > 0 and #wins - #floating_wins - #tree_wins == 1 then
            for _, w in ipairs(tree_wins) do
              vim.api.nvim_win_close(w, true)
            end
          end
        end,
      })
    end,
  },

  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      compile = false, -- enable compiling the colorscheme
      undercurl = true, -- enable undercurls
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false, -- do not set background color
      dimInactive = false, -- dim inactive window `:h hl-NormalNC`
      terminalColors = true, -- define vim.g.terminal_color_{0,17}
      colors = { -- add/modify theme and palette colors
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
      overrides = function(colors) -- add/modify highlights
        return {}
      end,
      theme = "wave", -- Load "wave" theme
      background = { -- map the value of 'background' option to a theme
        dark = "wave", -- try "dragon" !
        light = "lotus",
      },
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd("colorscheme kanagawa")
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Telescope find files" },
      { "<leader>ft", function() require("telescope.builtin").git_files() end, desc = "Telescope find files in git" },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep({
            additional_args = function()
              return { "--hidden" }
            end,
          })
        end,
        desc = "Telescope live grep",
      },
      {
        "<leader>fr",
        function()
          require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
        end,
        desc = "Telescope find files in project",
      },
      {
        "<leader>fr",
        function()
          require("telescope.builtin").grep_string({ search = get_visual_selection() })
        end,
        mode = "v",
        desc = "Telescope grep visual selection in project",
      },
      {
        "gr",
        function()
          require("telescope.builtin").lsp_references({ include_declaration = false })
        end,
        desc = "LSP References",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "go", "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
      sync_install = false,
      auto_install = true,
      ignore_install = {},
      highlight = {
        enable = true,
        disable = {},
        additional_vim_regex_highlighting = false,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "ThePrimeagen/harpoon",
    keys = (function()
      local keys = {
        { "<leader>a", function() require("harpoon.mark").add_file() end, desc = "Harpoon add file" },
        { "<C-h>", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon quick menu" },
        { "<C-j>", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon file 1" },
        { "<C-k>", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon file 2" },
        { "<C-l>", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon file 3" },
      }
      if vim.fn.has("mac") == 1 then
        table.insert(keys, { "<C-'>", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon file 4" })
      else
        table.insert(keys, { "<C-;>", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon file 4" })
      end
      return keys
    end)(),
  },

  {
    "tpope/vim-fugitive",
    cmd = { "Git" },
    keys = {
      {
        "<leader>gs",
        function()
          local buf = vim.fn.bufnr("fugitive://")
          if buf ~= -1 and vim.fn.bufwinnr(buf) ~= -1 then
            vim.cmd("bdelete " .. buf)
          else
            vim.cmd.Git()
          end
        end,
        desc = "Toggle Fugitive",
      },
      { "<leader>gc", function() vim.cmd("Git commit") end, desc = "Git commit" },
      { "<leader>gp", function() vim.cmd("Git push") end, desc = "Git push" },
      { "<leader>gl", function() vim.cmd("Git log") end, desc = "Git log" },
      { "<leader>gb", function() vim.cmd("Git blame") end, desc = "Git blame" },
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose" },
    keys = {
      { "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "Diffview open" },
      { "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Diffview close" },
    },
  },

  { "airblade/vim-gitgutter", event = "VeryLazy" },

  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    init = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    keys = {
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
      { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Open folds except kinds" },
      { "zm", function() require("ufo").closeFoldsWith() end, desc = "Close folds with" },
    },
    opts = {
      provider_selector = function(bufnr, filetype, buftype)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("^diffview://") or buftype == "nofile" then
          return ""
        end
        return { "lsp", "indent" }
      end,
    },
  },

  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSelectModel",
      "ClaudeCodeAdd",
      "ClaudeCodeSend",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
    },
    keys = {
      { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>cr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>cC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      { "<leader>ca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>cd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
    config = function()
      local opts = {}
      local wrapper = vim.fn.expand("~/.config/nvim/scripts/claude-wrapper.sh")
      if vim.fn.filereadable(wrapper) == 1 then
        opts.terminal_cmd = wrapper
      end
      require("claudecode").setup(opts)
    end,
  },

  {
    "hashivim/vim-terraform",
    ft = { "terraform", "hcl" },
    init = function()
      vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
      vim.cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
      vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
      vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
      vim.cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])
      vim.g.terraform_fmt_on_save = 1
      vim.g.terraform_align = 1
    end,
  },

  {
    "mbbill/undotree",
    init = function()
      vim.g.undotree_SplitWidth = 28
      vim.g.undotree_DiffpanelHeight = 10
    end,
    keys = {
      {
        "<leader>u",
        function()
          -- Undotree returns focus to whatever window was active when it
          -- opened/closed (g:undotree_SetFocusWhenToggle=0, the default).
          -- We temporarily focus nvim-tree below so the split lands next
          -- to it, so remember the real origin window and jump back to
          -- it afterwards, rather than getting stranded in nvim-tree.
          local origin_win = vim.api.nvim_get_current_win()

          local ok, api = pcall(require, "nvim-tree.api")
          if ok and api.tree.is_visible() then
            -- Focus nvim-tree and split relative to *that* window
            -- ("belowright vertical" is window-relative, unlike the
            -- tabpage-relative topleft/botright WindowLayout presets),
            -- so undotree lands as its direct neighbour.
            api.tree.focus()
            vim.g.undotree_CustomUndotreeCmd = "belowright vertical" .. vim.g.undotree_SplitWidth .. " new"
          else
            -- No tree to sit next to: fall back to the original
            -- tabpage-relative default (top-left of the whole layout).
            vim.g.undotree_CustomUndotreeCmd = "topleft vertical" .. vim.g.undotree_SplitWidth .. " new"
          end
          vim.cmd("UndotreeToggle")

          if vim.api.nvim_win_is_valid(origin_win) then
            vim.api.nvim_set_current_win(origin_win)
          end
        end,
        desc = "Toggle Undotree",
      },
    },
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  {
    url = "https://gitlab.com/itaranto/plantuml.nvim",
    version = "*",
    ft = "plantuml",
    config = function()
      require("plantuml").setup()
    end,
  },

  {
    "martineausimon/nvim-lilypond-suite",
    ft = { "lilypond", "tex", "texinfo" },
    config = function()
      require("nvls").setup({
        lilypond = {
          mappings = {
            player = "<F3>",
            compile = "<F5>",
            open_pdf = "<F6>",
            switch_buffers = "<A-Space>",
            insert_version = "<F4>",
            hyphenation = "<F12>",
            hyphenation_change_lang = "<F11>",
            insert_hyphen = "<leader>ih",
            add_hyphen = "<leader>ah",
            del_next_hyphen = "<leader>dh",
            del_prev_hyphen = "<leader>dH",
          },
          options = {
            pitches_language = "default",
            hyphenation_language = "en_DEFAULT",
            output = "pdf",
            backend = nil,
            main_file = "main.ly",
            main_folder = "%:p:h",
            include_dir = nil,
            pdf_viewer = nil,
            errors = {
              diagnostics = true,
              quickfix = "external",
              filtered_lines = {
                "compilation successfully completed",
                "search path",
              },
            },
          },
        },
        latex = {
          mappings = {
            compile = "<F5>",
            open_pdf = "<F6>",
            lilypond_syntax = "<F3>",
          },
          options = {
            lilypond_book_flags = nil,
            clean_logs = false,
            main_file = "main.tex",
            main_folder = "%:p:h",
            include_dir = nil,
            lilypond_syntax_au = "BufEnter",
            pdf_viewer = nil,
            errors = {
              diagnostics = true,
              quickfix = "external",
              filtered_lines = {
                "Missing character",
                "LaTeX manual or LaTeX Companion",
                "for immediate help.",
                "Overfull \\hbox",
                "^%s%.%.%.",
                "%s+%(.*%)",
              },
            },
          },
        },
        texinfo = {
          mappings = {
            compile = "<F5>",
            open_pdf = "<F6>",
            lilypond_syntax = "<F3>",
          },
          options = {
            lilypond_book_flags = "--pdf",
            clean_logs = false,
            main_file = "main.texi",
            main_folder = "%:p:h",
            lilypond_syntax_au = "BufEnter",
            pdf_viewer = nil,
            errors = {
              diagnostics = true,
              quickfix = "external",
              filtered_lines = {
                "Missing character",
                "LaTeX manual or LaTeX Companion",
                "for immediate help.",
                "Overfull \\hbox",
                "^%s%.%.%.",
                "%s+%(.*%)",
              },
            },
          },
        },
        player = {
          mappings = {
            quit = "q",
            play_pause = "p",
            loop = "<A-l>",
            backward = "h",
            small_backward = "<S-h>",
            forward = "l",
            small_forward = "<S-l>",
            decrease_speed = "j",
            increase_speed = "k",
            halve_speed = "<S-j>",
            double_speed = "<S-k>",
          },
          options = {
            row = 1,
            col = "99%",
            width = "37",
            height = "1",
            border_style = "single",
            winhighlight = "Normal:Normal,FloatBorder:Normal,FloatTitle:Normal",
            midi_synth = "fluidsynth",
            fluidsynth_flags = nil,
            timidity_flags = nil,
            ffmpeg_flags = nil,
            audio_format = "mp3",
            mpv_flags = {
              "--msg-level=cplayer=no,ffmpeg=no,alsa=no",
              "--loop",
              "--config-dir=/dev/null",
              "--no-video",
            },
          },
        },
      })
    end,
  },

}
