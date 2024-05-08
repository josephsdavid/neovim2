local llmnvim = {
    'huggingface/llm.nvim',
    config = function()
        local llm = require('llm')

        llm.setup({
            model = "codegemma:7b-code",
            url = "http://localhost:11434/api/generate",
            -- cf https://github.com/ollama/ollama/blob/main/docs/api.md#parameters
            request_body = {
                -- Modelfile options for the model you use
                options = {
                    temperature = 0.2,
                    top_p = 0.95,
                }
            }
        })
    end
}

local model = {
    'gsuuon/model.nvim',

    -- Don't need these if lazy = false
    cmd = { 'M', 'Model', 'Mchat' },
    init = function()
        vim.filetype.add({
            extension = {
                mchat = 'mchat',
            }
        })
    end,
    ft = 'mchat',

    keys = {
        { '<C-m>d',       ':Mdelete<cr>', mode = 'n' },
        { '<C-m>s',       ':Mselect<cr>', mode = 'n' },
        { '<C-m><space>', ':Mchat<cr>',   mode = 'n' }
    },

    -- To override defaults add a config field and call setup()

    config = function()
        local ollama = require("model.providers.ollama")
        require('model').setup({
            prompts = {
                ['ollama:phi3'] = {
                    provider = ollama,
                    params = {
                        model = 'phi3'
                    },
                    builder = function(input)
                        return {
                            prompt = 'GPT4 Correct User: ' .. input .. '<|end_of_turn|>GPT4 Correct Assistant: '
                        }
                    end
                },



            },
            -- chats = {..},
            -- ..
        })
    end
}
