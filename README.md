# Nix/NixOS Configuration

This contains my general Nix configuration.

Be gentle, I am new to Nix and still learning. This definition should evolve
over time, but so far I am liking it.

For context, I'm a long time Mac and Arch user. I've previously tried to
codify my system setup through Ansible, but it never lasts. I love the feeling
of a fresh system install, but it always deviates. Modifying a config file or 
installing a package is just too easy. Eventually when you want back to that 
fresh state, it is a heavy lift.

Nix strips it down. Want to just try out an app? Easy, `nix-shell`. Want to 
keep it around, add it to your list of packages. Want more freedom with certain
apps, use a Flatpak. You can even do isolated devshells for specific apps. It can
all even work cross platform.
