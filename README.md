# clean-chroot-manager
Wrapper script to manage buildroots when building packages under Arch Linux.

## Why use it?
Ccm provides several advantages over the standard arch-build scripts:
* Automatically manages a local repo so dependencies that you build are pulled transparently from that local repo.
* Automatically setups and uses distcc to speed up compilation (if enabled).

Managing a local repo is helpful if building a package that has a dependency that also has to be built (i.e. one that is not available from the Arch repos). Another key point of differentiation is that ccm can build packages using distcc.

For example, let's say that we want to build "bar" from the AUR. "Bar" has a build dependency of "foo" which is also in the AUR. Rather than first building "foo", then installing "foo", then building "bar", and finally removing "foo", the local repo will save a copy of foo.pkg.tar.xz which is indexed automatically therein. Pacman within the buildroot is aware of the "foo" package thanks to the local repo. So, when the user tries to build "bar", pacman will silently grabs foo.pkg.tar.xz from the local repo as any other dependency.

## Download
AUR Package: https://aur.archlinux.org/packages/clean-chroot-manager

## Setup
`$XDG_CONFIG_HOME/clean-chroot-manager.conf` will be created on the first invocation of ccm and contains all user managed settings. Edit this file prior to running ccm a second time. Make sure the user running ccm has sudo rights to execute `/usr/bin/clean-chroot-manager` or `/usr/bin/ccm`.

## Options
| Command | Description |
| :---: | --- |
| a | Add packages in current dir to the local repo. |
| c | Create the buildroot. |
| cd | Create the buildroot with distcc enabled (if you do not want to set up in the config file). |
| cp | Purge all files in the CCACHE_DIR (optional if building with ccache). |
| d | Delete all packages in the local repo without nuking the entire build (i.e. the packages you built to date). |
| l | List the contents of the local repo (i.e. the packages you built to date). |
| N | Nuke the buildroot and the external repo (if defined). |
| n | Nuke the buildroot (delete it and everything under it). |
| p | Preview settings. Show some bits about the buildroot itself. |
| R | Repackage the current package if built. The equivalent of `makepkg -sR` in the buildroot. |
| s | Run makepkg in build mode under the buildroot. The equivalent of `makepkg -s` in the buildroot. |
| S | Run makepkg in build mode under the buildroot without first cleaning it. Useful for rebuilds without dirtying the pristine buildroot or when building packages with many of the same deps. |
| t | Toggle [testing] and [community-testing] on/off in the buildroot and update packages accordingly (upgrade or downgrade). |
| ti | Show run time of current build. |
| u | Update the packages inside the buildroot. The equivalent of `pacman -Syu` in the buildroot. |

## Example Usage
Create a clean 64-bit buildroot under the path defined in the aforementioned config file:
```
$ sudo ccm c
```

Attempt to build the package in the clean 64-bit buildroot. If successful, the package will be added to a local repo so that it will be available for use as a dependency for building other packages:
```
 $ cd /path/to/PKGBUILD
 $ sudo ccm s
```

List out the contents of the 64-bit buildroot's local repo assuming something has been built. Useful to see what is present:
```
 $ sudo ccm l
```
Deletes everything under the top level of the 64-bit buildroot effectively removing it from the system:
```
 $ sudo ccm n
```

## Tips
* Since ccm requires sudo rights, consider making an alias for invoking it as such in your ~/.bashrc or the like. For example:

```
 alias ccm='sudo ccm'
```
* If you have multiple PCs on your LAN, consider having them help you compile via distcc which is supported within ccm. See `$XDG_CONFIG_HOME/clean-chroot-manager.conf` for setup instructions.
* If your machine has lots of memory, consider locating the buildroot to tmpfs to avoid disk usage/minimize access times. One way is to simply define a directory to mount as tmpfs like so in `/etc/fstab`:

`tmpfs /scratch tmpfs nodev,size=20G 0 0`

In order to have the expected `CHROOTPATH64` directory created, we can use a systemd tmpfile like so:
```
/etc/tmpfiles.d/ccm_dirs.conf
d /scratch/.buildroot 0750 foo users -

Note that this is only needed if the location of the buildroot are on a volatile filesystem like tmpfs.
```
