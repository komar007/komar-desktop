{ lib, config, pkgs, ... }: {
  options.alacritty.font = lib.mkOption {
    type = lib.types.str;
  };
  options.alacritty.font-size = lib.mkOption {
    type = lib.types.float;
  };

  config.programs.alacritty.enable = true;
  config.programs.alacritty.settings = {
    bell.animation = "EaseOutExpo";
    bell.color = "#444444";
    bell.duration = 60;

    cursor.style.blinking = "Always";

    colors.cursor.cursor = "CellForeground";
    colors.cursor.text = "CellBackground";

    colors.normal.black = "#7c6f64";
    colors.normal.blue = "#83a5d8";
    colors.normal.cyan = "#8ec07c";
    colors.normal.green = "#c5c821";
    colors.normal.magenta = "#d3869b";
    colors.normal.red = "#fb4934";
    colors.normal.white = "#ebdbb2";
    colors.normal.yellow = "#fabd2f";

    colors.primary.background = "#000000";
    colors.primary.bright_foreground = "#f9f5d7";
    colors.primary.dim_foreground = "#f2e5bc";
    colors.primary.foreground = "#fbf1c7";

    colors.selection.background = "CellForeground";
    colors.selection.text = "CellBackground";

    colors.vi_mode_cursor.cursor = "CellForeground";
    colors.vi_mode_cursor.text = "CellBackground";

    font.size = config.alacritty.font-size;

    font.bold.family = config.alacritty.font;
    font.bold.style = "Bold";

    font.bold_italic.family = config.alacritty.font;
    font.bold_italic.style = "Bold Italic";

    font.italic.family = config.alacritty.font;
    font.italic.style = "Italic";

    font.normal.family = config.alacritty.font;
    font.normal.style = "Light";

    font.offset.y = -4;

    font.glyph_offset.y = -2;

    scrolling.history = 32768;
    scrolling.multiplier = 5;

    # unbind unnecessary defaults
    keyboard.bindings = [
      {
        mods = "Control";
        key = "-";
        action = "None";
      }
      {
        mods = "Control";
        key = "=";
        action = "None";
      }
      {
        mods = "Control | Shift";
        key = "_";
        action = "DecreaseFontSize";
      }
      {
        mods = "Control | Shift";
        key = "+";
        action = "IncreaseFontSize";
      }

      # Special combos that are hard (or impossible) to achieve using regular terminal codes
      # They use Unicode PUA from E100 onwards and can be later bound for example in tmux
      {
        mods = "Control";
        key = "-";
        chars = "\\uE100";
      }
      {
        mods = "Control";
        key = "m";
        chars = "\\uE101";
      }
      {
        mods = "Control|Shift";
        key = "m";
        chars = "\\uE102";
      }
      {
        mods = "Control|Shift";
        key = "j";
        chars = "\\uE103";
      }
      {
        mods = "Control|Shift";
        key = "k";
        chars = "\\uE104";
      }
      {
        mods = "Control|Shift";
        key = "y";
        chars = "\\uE105";
      }
      {
        mods = "Control|Shift";
        key = "p";
        chars = "\\uE106";
      }
      {
        mods = "Control|Shift";
        key = "n";
        chars = "\\uE107";
      }
      {
        mods = "Control";
        key = "Backspace";
        chars = "\\uE108";
      }
    ];
  };
}
