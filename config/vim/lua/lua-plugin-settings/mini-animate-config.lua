
if HasPlug('mini.animate') and Animation_enable then
  local animate = require('mini.animate')
  animate.setup({
    cursor = {
      -- Whether to enable this animation
      enable = true,
      -- Timing of animation (how steps will progress in time)
      -- timing = --<function: implements linear total 250ms animation duration>,
    },
    scroll = {
      -- Whether to enable this animation
      enable = true,
      -- Timing of animation (how steps will progress in time)
      timing = animate.gen_timing.linear({ duration = 150, unit = 'total' }),
    },
    open = {
      -- Whether to enable this animation
      enable = false,
    },
  })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason",
      "NvimTree", "vista", "toggleterm", "noice" },
    callback = function()
      vim.b.minianimate_disable = true
    end,
  })
end

