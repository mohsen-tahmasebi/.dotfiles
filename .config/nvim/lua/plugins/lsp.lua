return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      vtsls = {
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },

        settings = {
          complete_function_calls = true,

          vtsls = {
            -- enableMoveToFileCodeAction = true,

            -- IMPORTANT: reduces filesystem probing overhead
            autoUseWorkspaceTsdk = false,

            experimental = {
              -- disable expensive server-side fuzzy matching
              completion = {
                enableServerSideFuzzyMatch = false,
              },

              -- keep this minimal; avoids large hint payloads
              maxInlayHintLength = 20,
            },
          },

          typescript = {
            updateImportsOnFileMove = { enabled = "always" },

            suggest = {
              completeFunctionCalls = true,
            },

            inlayHints = {
              -- 🔥 PERFORMANCE TUNING: keep only low-cost hints
              enumMemberValues = { enabled = false },
              functionLikeReturnTypes = { enabled = false },
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = false },
              propertyDeclarationTypes = { enabled = false },
              variableTypes = { enabled = false },
            },
          },
        },

        keys = {
          {
            "gD",
            function()
              local win = vim.api.nvim_get_current_win()
              local params = vim.lsp.util.make_position_params(win, "utf-16")
              LazyVim.lsp.execute({
                command = "typescript.goToSourceDefinition",
                arguments = { params.textDocument.uri, params.position },
                open = true,
              })
            end,
            desc = "Goto Source Definition",
          },

          {
            "gR",
            function()
              LazyVim.lsp.execute({
                command = "typescript.findAllFileReferences",
                arguments = { vim.uri_from_bufnr(0) },
                open = true,
              })
            end,
            desc = "File References",
          },

          {
            "<leader>cM",
            LazyVim.lsp.action["source.addMissingImports.ts"],
            desc = "Add missing imports",
          },

          {
            "<leader>cD",
            LazyVim.lsp.action["source.fixAll.ts"],
            desc = "Fix all diagnostics",
          },
        },
      },
    },
    emmet_language_server = {
      filetypes = {
        "css",
        "eruby",
        "html",
        "javascript",
        "javascriptreact",
        "less",
        "sass",
        "scss",
        "pug",
        "typescriptreact",
      },
      -- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
      -- **Note:** only the options listed in the table are supported.
      init_options = {
        ---@type table<string, string>
        includeLanguages = {},
        --- @type string[]
        excludeLanguages = {},
        --- @type string[]
        extensionsPath = {},
        --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
        preferences = {},
        --- @type boolean Defaults to `true`
        showAbbreviationSuggestions = true,
        --- @type "always" | "never" Defaults to `"always"`
        showExpandedAbbreviation = "always",
        --- @type boolean Defaults to `false`
        showSuggestionsAsSnippets = false,
        --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
        syntaxProfiles = {},
        --- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
        variables = {},
      },
    },

    setup = {
      vtsls = function(_, opts)
        -- 🔥 avoid duplicate JS/TS heavy settings merge cost
        opts.settings.javascript =
          vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})

        -- ⚠️ IMPORTANT: only keep this if you REALLY use move refactoring
        -- otherwise it adds tsserver round-trips
        Snacks.util.lsp.on({ name = "vtsls" }, function(_, client)
          client.commands["_typescript.moveToFileRefactoring"] = function(command)
            local action, uri, range = unpack(command.arguments)

            local function move(newf)
              client:request("workspace/executeCommand", {
                command = command.command,
                arguments = { action, uri, range, newf },
              })
            end

            local fname = vim.uri_to_fname(uri)

            client:request("workspace/executeCommand", {
              command = "typescript.tsserverRequest",
              arguments = {
                "getMoveToRefactoringFileSuggestions",
                {
                  file = fname,
                  startLine = range.start.line + 1,
                  startOffset = range.start.character + 1,
                  endLine = range["end"].line + 1,
                  endOffset = range["end"].character + 1,
                },
              },
            }, function(_, result)
              local files = result.body.files or {}
              table.insert(files, 1, "Enter new path...")

              vim.ui.select(files, {
                prompt = "Select move destination:",
                format_item = function(f)
                  return vim.fn.fnamemodify(f, ":~:.")
                end,
              }, function(f)
                if not f then
                  return
                end

                if f:find("^Enter new path") then
                  vim.ui.input({
                    prompt = "Enter move destination:",
                    default = vim.fn.fnamemodify(fname, ":h") .. "/",
                    completion = "file",
                  }, function(newf)
                    if newf then
                      move(newf)
                    end
                  end)
                else
                  move(f)
                end
              end)
            end)
          end
        end)
      end,
    },
  },
}
