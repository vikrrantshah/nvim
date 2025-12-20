return {
  -- Avante.nvim (Cursor-like Chat & Edit)
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
      provider = "claude", -- Default Provider

      -- New Providers Configuration Structure (Migration Fix)
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-4.5-sonnet",
          timeout = 30000,
          -- parameters moved to extra_request_body as per new API
          disable_tools = true, -- Optional: disable tools if you only want chat
          extra_request_body = {
            temperature = 0,
            max_tokens = 4096,
          },
        },
        openai = {
          endpoint = "https://api.openai.com/v1",
          model = "gpt-5",
          timeout = 30000,
          extra_request_body = {
            temperature = 0,
            max_tokens = 4096,
          },
        },
        gemini = {
          endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
          model = "gemini-3.0-pro",
          timeout = 30000,
          extra_request_body = {
            temperature = 0,
            max_tokens = 4096,
          },
        },
      },

      -- Behavior & UI
      behaviour = {
        auto_suggestions = false, -- Handled by Minuet-AI
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = true,
      },
      mappings = {
        -- Cursor-like keybindings where possible
        diff = {
          ours = "co",
          theirs = "ct",
          all_theirs = "ca",
          both = "cb",
          cursor = "cc",
          next = "]x",
          prev = "[x",
        },
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
      },
      hints = { enabled = true },
      windows = {
        position = "right",
        wrap = true,
        width = 30,
        sidebar_header = {
          align = "center",
          rounded = true,
        },
      },
    },
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- Pickers (Avante will choose one, we have both Telescope and FzfLua)
      "nvim-telescope/telescope.nvim",
      "ibhagwan/fzf-lua",
      "nvim-tree/nvim-web-devicons",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = { insert_mode = true },
            use_absolute_path = true,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
    },
    build = "make", -- Requires make and cargo
  },

  -- Minuet AI (Ghost Text / Inline Completion)
  {
    "milanglacier/minuet-ai.nvim",
    config = function()
      require("minuet").setup({
        -- Use Gemini for completions by default (Fast & Smart)
        provider = "gemini",
        provider_options = {
          gemini = {
            model = "gemini-3.0-pro",
            stream = true,
            optional = {
              maxOutputTokens = 256,
            },
          },
          claude = {
            max_tokens = 256,
            model = "claude-4.5-sonnet",
          },
          openai = {
            model = "gpt-5",
            max_tokens = 256,
          },
        },
        notify = "error",
      })
    end,
    dependencies = { "nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp" },
  },

  -- Register Minuet as a CMP source
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      -- High priority for ghost text
      table.insert(opts.sources, { name = "minuet", group_index = 1, priority = 100 })
    end,
  },
}
