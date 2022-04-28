julia = {
  tasks = {
    run = {
      command = 'julia %',
      output = 'terminal',
      opts = { open_on_run = 'never' }
    },
    test = {
      command = "julia -e 'using Pkg; Pkg.test()'",
      output = 'terminal',
      opts = { open_on_run = 'auto' }
    }
  }
}


require('yabs'):setup({
  languages = { -- List of languages in vim's `filetype` format
    julia = julia
  },
})
