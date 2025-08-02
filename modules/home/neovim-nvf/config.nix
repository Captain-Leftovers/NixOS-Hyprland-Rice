{
  config,
  pkgs,
  inputs,
  ...
}:

{

  imports = [
    inputs.nvf.homeManagerModules.default
  ];

  programs.nvf = {
    enable = true;

    settings = {

      vim = {
        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        };
        
        lsp.enable = true;
        treesitter.enable = true;
        statusline.lualine.enable = true;
        telescope.enable = true; # Fuzzy finder
        
      };
    };
  };
}
