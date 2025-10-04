return {
  {
    "williamboman/mason.nvim",
    event = "BufRead",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    version = "1.32.0",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        automatic_installation = true,
        ensure_installed = {
          "lua_ls",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      vim.lsp.set_log_level("warn")

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

      local default_config = {
        capabilities = capabilities,
      }

      local lua_ls_config = {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {},
              checkThirdParty = false,
              maxPreload = 0,
              preloadFileSize = 0,
            },
            telemetry = {
              enable = false,
            },
          },
        },
        filetypes = { "lua" },
        root_dir = function(fname)
          local util = require("lspconfig.util")
          return util.root_pattern(
            ".luarc.json",
            ".luarc.jsonc",
            ".luacheckrc",
            ".stylua.toml",
            "stylua.toml",
            "selene.toml",
            "selene.yml",
            ".git"
          )(fname) or util.path.dirname(fname)
        end,
      }

      require("mason-lspconfig").setup_handlers({
        function(server_name)
          vim.lsp.config(server_name, default_config)
        end,

        ["lua_ls"] = function()
          vim.lsp.config("lua_ls", lua_ls_config)
        end,
      })

      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      vim.api.nvim_create_autocmd("CursorHold", {
        buffer = 0,
        callback = function()
          local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "rounded",
            source = "always",
            prefix = " ",
            scope = "cursor",
          }
          vim.diagnostic.open_float(nil, opts)
        end,
      })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, { silent = true })
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { silent = true })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { silent = true })

      -- Diagnostic key mappings
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic error messages" })
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
    end,
  },
}
