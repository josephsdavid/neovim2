local llmnvim = {
    'huggingface/llm.nvim',
    cmd = {"LLMSuggestion", "LLMToggleAutoSuggestion"},
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

add_plugins({llmnvim})
