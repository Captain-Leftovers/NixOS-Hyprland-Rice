{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [ inputs.nvf.homeManagerModules.default ];

  programs.nvf = {
    enable = true;

    settings = {
      vim.package =
        inputs.neovim-overlay.packages.${pkgs.system}.neovim;

      vim.theme = {
        enable = true;
        name = "gruvbox";
        style = "dark";
      };

      vim.lsp.enable = true;
      vim.treesitter.enable = true;
      vim.statusline.lualine.enable = true;
      vim.telescope.enable = true;

      #Languages support
      vim.languages.nix.enable = true;


      # Updated namespaces
      vim.autocomplete."nvim-cmp".enable = true;
      vim.autopairs."nvim-autopairs".enable = true;
      vim.mini."ai".enable = true; # for in-editor LLM UI
    };
  };
}
