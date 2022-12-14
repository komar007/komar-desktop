require("telescope").setup {
  defaults = {
    path_display={"truncate"},
    mappings = {
      n = {
        ['<c-d>'] = require('telescope.actions').delete_buffer
      },
      i = {
        ['<c-d>'] = require('telescope.actions').delete_buffer
      },
    },
  },
  extensions = {
  }
}

require('dressing').setup({
  input = {
    prompt_align = "left",
    anchor = "NW",
  },
  select = {
    telescope = require('telescope.themes').get_cursor(),
  },
})

local fullscreen_theme = require('telescope.themes').get_ivy({
  layout_config = {
    height = 10000,
    width = 10000,
  },
})

telescope_findfiles = function(config)
  require('telescope.builtin').find_files(fullscreen_theme)
end
telescope_buffers = function(config)
  require('telescope.builtin').buffers(fullscreen_theme)
end
