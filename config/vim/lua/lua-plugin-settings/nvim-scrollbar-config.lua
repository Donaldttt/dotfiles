
if HasPlug('nvim-scrollbar') then
  require("scrollbar").setup({
    excluded_filetypes = {
      "prompt",
      "TelescopePrompt",
      "noice",
      "startify",
      "vista",
    },
    excluded_buftypes = {
      "terminal",
      "nofile",
      "help",
    },
  })
end
