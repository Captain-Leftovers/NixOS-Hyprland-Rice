{ config, pkgs, inputs, ... }:

{
  programs.nvf = {
    enable = true;

    settings = {
      # Use Nightly Neovim from overlay
      package = inputs.neovim-overlay.packages.${pkgs.system}.neovim;

      vim = {
        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        }
        lsp.enable = true;
        treesitter.enable = true;

        # Optional but nice
        statusline.lualine.enable = true;

        
        cmp.enable = true;        # Completion engine
        autopairs.enable = true;  # Automatically close brackets
        telescope.enable = true;  # Fuzzy finder
      };
    };
  };
}
