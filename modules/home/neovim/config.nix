{
  config,
  pkgs,
  inputs,
  ...
}:

{
 
 #  package = inputs.neovim-overlay.packages.${pkgs.system}.neovim;
        
   programs.neovim = {
    enable = true;

  #point kickstart init lua to nvim config
   extraLuaConfig = builtins.readFile ./nvim-dotfiles/init.lua;
  

    # Optional: set alias so `vim` launches `nvim`
    viAlias = true;
    vimAlias = true;
  };

}
