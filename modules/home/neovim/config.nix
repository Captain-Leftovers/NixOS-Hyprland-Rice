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

 #symlink instead of point to -  so changes dont need system  rebuild to affect nvim
  

    # Optional: set alias so `vim` launches `nvim`
    viAlias = true;
    vimAlias = true;
  };

}
