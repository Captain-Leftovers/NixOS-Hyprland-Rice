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

     vim = {

        
      package =
        inputs.neovim-overlay.packages.${pkgs.system}.neovim;

      theme = {
        enable = true;
        name = "gruvbox";
        style = "dark";
      };
        

      lsp.enable = true;
      treesitter.enable = true;
      statusline.lualine.enable = true;
      telescope.enable = true;

      #Languages support
      languages = {
        nix.enable = true;
        ts.enable = true;
        };


      # Updated namespaces
      autocomplete."nvim-cmp".enable = true;
      autopairs."nvim-autopairs".enable = true;
      mini."ai".enable = true; # for in-editor LLM UI
      };
    };
  };
}
