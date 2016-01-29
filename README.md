# clean-chroot-manager
Wrapper scripts to manage clean chroots (x86_64 and i686) for building packages under Arch Linux.

## Why use it?
Ccm provides several advantages over the standard arch-build scripts:
* Automatically manages a local repo within the chroot so dependencies that you build are pulled transparently from that local repo.
* Automatically setups and uses distcc to speed up compilation (if enabled).

Managing a local repo is helpful if building a package that has a dependency that also has to be built (i.e. one that is not available from the Arch repos). Another key point of differentiation is that ccm can build packages using distcc.

For example, let's say that we want to build "bar" from the AUR. "Bar" has a build dependency of "foo" which is also in the AUR. Rather than first building "foo", then installing "foo", then building "bar", and finally removing "foo", the local repo will save a copy of foo.pkg.tar.xz which is indexed automatically therein. Pacman within the chroot is aware of the "foo" package thanks to the local repo. So, when the user tries to build "bar", pacman will silently grabs foo.pkg.tar.xz from the local repo as any other dependency.

## Download
AUR Package: https://aur.archlinux.org/packages/clean-chroot-manager

## Setup
$XDG_CONFIG_HOME/clean-chroot-manager.conf will be created on the first invocation of ccm and contains all user managed settings. Edit this file prior to running ccm a second time. Make sure the user running ccm has sudo rights to execute /usr/bin/clean-chroot-manager or /usr/bin/ccm.

## Options
| Command | Description |
| :---: | --- |
| c | Create a clean chroot. |
| n | Nuke the clean chroot (delete it and everything under it). |
| t | Toggle [testing] and [community-testing] on/off in the chroot and update packages accordingly (upgrade or downgrade). |
| m | Toggle [multilib] on/off in the chroot and update packages accordingly (upgrade or downgrade). |
| s | Run makepkg in build mode under the chroot. The equivalent of `makepkg -src` in the chroot. |
| S | Run makepkg in build mode under the chroot without first cleaning it. Useful for rebuilds without dirtying the pristine chroot or when building packages with many of the same deps. |
| l | List the contents of the local repo (i.e. the packages you built to date). |
| d | Delete all packages in the local repo without nuking the entire chroot (i.e. the packages you built to date). |
| u | Update the packages inside the chroot. The equivalent of `pacman -Syu` in the chroot. |
| p | Preview settings. Show some bits about the chroot itself. |

## Example Usage
Create a clean 64-bit chroot under the path defined in the aforementioned config file:
```
$ sudo ccm64 c
```

Create a clean 32-bit chroot under the path defined in the aforementioned config file:
```
$ sudo ccm32 c
```

Attempt to build the package in the clean 64-bit chroot. If successful, the package will be added to a local pacman repo inside the chroot so that it will be available for use as a dependency for building other packages:
```
 $ cd /path/to/PKGBUILD
 $ sudo ccm64 s
```

List out the contents of the 64-bit chroot's local repo assuming something has been built. Useful to see what is present:
```
 $ sudo ccm64 l
```
Deletes everything under the top level of the 64-bit chroot effectively removing it from the system:
```
 $ sudo ccm64 n
```

## Tips
* Since ccm requires sudo rights, consider making an alias for invoking it as such in your ~/.bashrc or the like. For example:

```
 alias ccm64='sudo ccm64'
 alias ccm32='sudo ccm32'
```
* If you have multiple PCs on your LAN, consider having them help you compile via distcc which is supported within ccm. See $XDG_CONFIG_HOME/clean-chroot-manager.conf for setup instructions.
* If your machine has lots of memory, consider locating the chroot to tmpfs to avoid disk usage/minimize access times. One way is to simply define a directory to mount as tmpfs like so in `/etc/fstab`:

`tmpfs /scratch tmpfs nodev,size=10G 0 0`

In order to have the expected `CHROOTPATH64` and `CHROOTPATH32` directories created, we can use a systemd tmpfile like so:
```
/etc/tmpfiles.d/ccm_dirs.conf
d /scratch/.chroot64 0755 facade users -
d /scratch/.chroot32 0755 facade users -

Note that this is only needed if the location of the chroots are on a volatile filesystem like tmpfs.
```
