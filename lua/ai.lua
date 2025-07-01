-- local llmnvim = {
--     'huggingface/llm.nvim',
--     cmd = { "LLMSuggestion", "LLMToggleAutoSuggestion" },
--     config = function()
--         local llm = require('llm')
--
--         llm.setup({
--             model = "codegemma:7b-code",
--             url = "http://localhost:11434/api/generate",
--             -- cf https://github.com/ollama/ollama/blob/main/docs/api.md#parameters
--             request_body = {
--                 -- Modelfile options for the model you use
--                 options = {
--                     temperature = 0.2,
--                     top_p = 0.95,
--                 }
--             }
--         })
--     end
-- }
--
-- add_plugins({ llmnvim })
local gen_opts = {
    model = "gemma3:4b",    -- The default model to use.
    quit_map = "q",         -- set keymap to close the response window
    retry_map = "<c-r>",    -- set keymap to re-send the current prompt
    accept_map = "<c-cr>",  -- set keymap to replace the previous selection with the last result
    host = "localhost",     -- The host running the Ollama service.
    port = "11434",         -- The port on which the Ollama service is listening.
    display_mode = "split", -- The display mode. Can be "float" or "split" or "horizontal-split".
    show_prompt = true,     -- Shows the prompt submitted to Ollama. Can be true (3 lines) or "full".
    show_model = true,      -- Displays which model you are using at the beginning of your chat session.
    no_auto_close = false,  -- Never closes the window automatically.
    file = false,           -- Write the payload to a temporary file to keep the command short.
    hidden = false,         -- Hide the generation window (if true, will implicitly set `prompt.replace = true`), requires Neovim >= 0.10
    init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
    -- Function to initialize Ollama
    command = function(options)
        local body = { model = options.model, stream = true }
        return "curl --silent --no-buffer -X POST http://" ..
            options.host .. ":" .. options.port .. "/api/chat -d $body"
    end,
    -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
    -- This can also be a command string.
    -- The executed command must return a JSON object with { response, context }
    -- (context property is optional).
    -- list_models = '<omitted lua function>', -- Retrieves a list of model names
    result_filetype = "markdown", -- Configure filetype of the result buffer
    debug = false                 -- Prints errors and the command which is run.
}
-- Custom Parameters (with defaults)
local gen = {
    "David-Kunz/gen.nvim",
    config = function()
        require('gen').setup(gen_opts)
        require('gen').prompts['document_method_or_class'] = {
            prompt =
            "Write a docstring for this function or class. Make sure to document all input parameters in the format `:param thing: ...` and returns in the format `:return: ...`. \n$text",
            replace = false
        }
        require('gen').prompts['md_doc_file'] = {
            prompt =
            "Write a high level overview of what each highest level exported function or class does in paragraph form. Then, write a simple example of using the entire supplied code, with comments! \n$text.",
            replace = false,
        }
    end
}
local avante_config = {
    ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
    provider = "gemini", -- The provider used in Aider mode or in the planning phase of Cursor Planning Mode
    ---@alias Mode "agentic" | "legacy"
    mode = "agentic",  -- The default mode for interaction. "agentic" uses tools to automatically generate code, "legacy" uses the old planning method to generate code.
    -- WARNING: Since auto-suggestions are a high-frequency operation and therefore expensive,
    -- currently designating it as `copilot` provider is dangerous because: https://github.com/yetone/avante.nvim/issues/1048
    -- Of course, you can reduce the request frequency by increasing `suggestion.debounce`.
    auto_suggestions_provider = "gemini",
    providers = {
        claude = {
            endpoint = "https://api.anthropic.com",
            model = "claude-3-5-sonnet-20241022",
            extra_request_body = {
                temperature = 0.75,
                max_tokens = 4096,
            },
            gemini = {
                endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
                model = "gemini-2.5-flash",
                timeout = 30000, -- Timeout in milliseconds
                context_window = 1048576,
                use_ReAct_prompt = true,
                extra_request_body = {
                    generationConfig = {
                        temperature = 0.75,
                    },
                },
            },
        },
    },
    ---Specify the special dual_boost mode
    ---1. enabled: Whether to enable dual_boost mode. Default to false.
    ---2. first_provider: The first provider to generate response. Default to "openai".
    ---3. second_provider: The second provider to generate response. Default to "claude".
    ---4. prompt: The prompt to generate response based on the two reference outputs.
    ---5. timeout: Timeout in milliseconds. Default to 60000.
    ---How it works:
    --- When dual_boost is enabled, avante will generate two responses from the first_provider and second_provider respectively. Then use the response from the first_provider as provider1_output and the response from the second_provider as provider2_output. Finally, avante will generate a response based on the prompt and the two reference outputs, with the default Provider as normal.
    ---Note: This is an experimental feature and may not work as expected.
    dual_boost = {
        enabled = false,
        first_provider = "openai",
        second_provider = "claude",
        prompt =
        "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
        timeout = 60000, -- Timeout in milliseconds
    },
    behaviour = {
        auto_suggestions = false, -- Experimental stage
        auto_set_highlight_group = false,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        minimize_diff = true,     -- Whether to remove unchanged lines when applying a code block
        enable_token_counting = true, -- Whether to enable token counting. Default to true.
    },
    mappings = {
        --- @class AvanteConflictMappings
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
        cancel = {
            normal = { "<C-c>", "<Esc>", "q" },
            insert = { "<C-c>" },
        },
        sidebar = {
            apply_all = "A",
            apply_cursor = "a",
            retry_user_request = "r",
            edit_user_request = "e",
            switch_windows = "<Tab>",
            reverse_switch_windows = "<S-Tab>",
            remove_file = "d",
            add_file = "@",
            close = { "<Esc>", "q" },
            close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
        },
    },
    hints = { enabled = false },
    windows = {
        ---@type "right" | "left" | "top" | "bottom"
        position = "right", -- the position of the sidebar
        wrap = true,    -- similar to vim.o.wrap
        width = 30,     -- default % based on available width
        sidebar_header = {
            enabled = true, -- true, false to enable/disable the header
            align = "center", -- left, center, right for title
            rounded = true,
        },
        input = {
            prefix = "> ",
            height = 8, -- Height of the input window in vertical layout
        },
        edit = {
            border = "rounded",
            start_insert = true, -- Start insert mode when opening the edit window
        },
        ask = {
            floating = false, -- Open the 'AvanteAsk' prompt in a floating window
            start_insert = true, -- Start insert mode when opening the ask window
            border = "rounded",
            ---@type "ours" | "theirs"
            focus_on_apply = "ours", -- which diff to focus after applying
        },
    },
    highlights = {
        ---@type AvanteConflictHighlights
        diff = {
            current = "DiffText",
            incoming = "DiffAdd",
        },
    },
    --- @class AvanteConflictUserConfig
    diff = {
        autojump = true,
        ---@type string | fun(): any
        list_opener = "copen",
        --- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
        --- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
        --- Disable by setting to -1.
        override_timeoutlen = 500,
    },
    suggestion = {
        debounce = 600,
        throttle = 600,
    },
}

local avante = {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = avante_config,
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "ibhagwan/fzf-lua",          -- for file_selector provider fzf
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        {
            -- support for image pasting
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                -- recommended settings
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    -- required for Windows users
                    use_absolute_path = true,
                },
            },
        },
        {
            -- Make sure to set this up properly if you have lazy=true
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
}
add_plugins({ gen, avante })
