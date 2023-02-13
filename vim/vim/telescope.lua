require("telescope").setup {
  defaults = {
    path_display={"smart"},
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

require('telescope').load_extension('fzf')

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

local fullscreen_horizontal_theme = require('telescope.themes').get_ivy({
  layout_config = {
    height = 10000,
    width = 10000,
  },
  layout_strategy = 'vertical',
})

telescope_findfiles = function(config)
  require('telescope.builtin').find_files(fullscreen_theme)
end
telescope_buffers = function(config)
  require('telescope.builtin').buffers(fullscreen_theme)
end
telescope_references = function(config)
  require('telescope.builtin').lsp_references(fullscreen_horizontal_theme)
end
telescope_implementations = function(config)
  require('telescope.builtin').lsp_implementations(fullscreen_horizontal_theme)
end
