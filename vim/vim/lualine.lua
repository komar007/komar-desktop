local colors = {
  grey     = '#a0a1a7',
  black    = '#111111',
  white    = '#f3f3f3',
  lgreen   = '#83a598',
  bg       = '#202328',
  fg       = '#bbc2cf',
  darkfg   = '#6b727f',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#fe8019',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#51afef',
  red      = '#fb4934',
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local theme = {
  normal = {
    a = { fg = colors.fg, bg = '#3a3430'},
    b = { fg = colors.fg, bg = '#2a2420' },
    c = { fg = colors.darkfg, bg = '#1d2021' },
    x = { fg = colors.darkfg, bg = '#1d2021' },
    y = { fg = colors.darkfg, bg = '#2a2420' },
    z = { fg = colors.darkfg, bg = '#3a3430'},
  },
  insert = { c = { fg = colors.black, bg = colors.green } },
  visual = { c = { fg = colors.black, bg = colors.orange } },
  replace = { c = { fg = colors.black, bg = colors.violet } },
}

local function search_result()
  if vim.v.hlsearch == 0 then
    return ''
  end
  local last_search = vim.fn.getreg('/')
  if not last_search or last_search == '' then
    return ''
  end
  local searchcount = vim.fn.searchcount { maxcount = 9999 }
  return ' ' .. last_search .. ' (' .. searchcount.current .. '/' .. searchcount.total .. ')'
end

local function modified()
  if vim.bo.modified then
    return '✎'
  elseif vim.bo.modifiable == false or vim.bo.readonly == true then
    return ''
  end
  return ''
end

require('lualine').setup {
  options = {
    theme = theme,
    component_separators = '',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = {
      {
        'branch',
        icon = '',
      },
      {
        'diff',
        symbols = { added = ' ', modified = '柳', removed = ' ' },
        diff_color = {
          added = { fg = colors.green },
          modified = { fg = colors.orange },
          removed = { fg = colors.red },
        },
        on_click = function(n, but, mod)
          if but == 'l' then
            vim.api.nvim_command('GitGutterNextHunk')
          elseif but == 'r' then
            vim.api.nvim_command('GitGutterPrevHunk')
          end
        end,
      },
    },
    lualine_b = {
      {
        'filename',
        file_status = false,
        path = 1
      },
      {
        modified,
        color = { fg = colors.red }
      },
      {
        '%w',
        cond = function()
          return vim.wo.previewwindow
        end,
      },
      {
        '%q',
        cond = function()
          return vim.bo.buftype == 'quickfix'
        end,
      },
    },
    lualine_c = {
      {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        symbols = { error = ' ', warn = ' ', info = ' ' },
        diagnostics_color = {
          error = { fg = colors.red },
          warn = { fg = colors.yellow },
          info = { fg = colors.cyan },
        },
        on_click = function(n, but, mod)
          if but == 'l' then
            vim.diagnostic.goto_next();
          elseif but == 'r' then
            vim.diagnostic.goto_prev();
          end
        end,
      },
    },
    lualine_x = {
      {
        search_result,
      },
    },
    lualine_y = {
      'filetype',
      {
        'o:encoding', -- option component same as &encoding in viml
        cond = conditions.hide_in_width,
      },
      {
        'fileformat',
        icons_enabled = true, -- I think icons are cool but Eviline doesn't have them. sigh
        cond = conditions.hide_in_width,
      },
    },
    lualine_z = {
      {
        '%p%%/%L',
      },
      {
        '%l:%c',
        color = { fg = colors.fg },
      }
    },
  },
  inactive_sections = {
  },
  tabline = {
    lualine_a = {
      {
        function()
          return '   ';
        end,
        on_click = function(n, but, mod)
          telescope_buffers()
        end,
      },
    },
    lualine_b = {
      {
        'buffers',
        show_filename_only = false,
        padding = { left = 1, right = 1 },
        symbols = {
          modified = ' ✎',      -- Text to show when the buffer is modified
          alternate_file = '⬌', -- Text to show to identify the alternate file
        },
        buffers_color = {
          active = { fg = colors.fg, bg = '#1d2021' },
          inactive = { fg = colors.darkfg }
        },
      },
      {
        function()
          return ' ';
        end,
      },
    },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {
      {
        function()
          return vim.loop.cwd()
        end,
      }
    },
    lualine_z = {
      'hostname',
    },
  },
}
