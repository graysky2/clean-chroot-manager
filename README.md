# clean-chroot-manager
Wrapper scripts to manage clean chroots (x864_64 and i686) for building packages under Arch Linux. 

## Description
Use these scripts as a "one-click" solution for building packages in a clean chroot.  A key feature that provides both convenience and flexibility is the automatic management of a local pacman repo inside the chroot.  This is helpful if building a package that has a dependency that also has to be built (i.e. one that is not available from the Arch repos).

An illustrative example: we want to build 'bar' from the AUR.  'Bar' has a build dependency of 'foo' which is also in the AUR.  Rather than first building 'foo', then installing 'foo', then building 'bar', and finally removing 'foo', the local repo will save a copy of foo.pkg.tar.xz which is indexed automatically therein.  Pacman within the chroot is aware of that fact via the local repo; when users go to build 'bar', pacman will silently grab foo.pkg.tar.xz from the local repo just as if it were present in any of the official repos. This allows a one-step build of 'bar' without interruption to the user.

## Options
| Command | Description |
| :---: | --- |
| c | Create a clean chroot. |
| t | Toggle [testing] and [community-testing] on/off in the chroot and update packages accordingly (upgrade or downgrade). |
| m | Toggle [multilib] on/off in the chroot and update packages accordingly (upgrade or downgrade). |
| s | Run makepkg in build mode under the chroot. The equivalent of `makepkg -src` in the chroot. |
| l | List the contents of the local repo (i.e. the packages you built to date). |
| n | Nuke the clean chroot (delete it and everything under it). |
| p | Preview settings. Show some bits about the chroot itself. |
| u | Update the packages inside the chroot. The equivalent of `pacman -Syu` in the chroot. |

## Example Usage
Create a clean 64-bit chroot under the path defined in the aforementioned config file:

 $ sudo ccm64 c

Ceate a clean 32-bit chroot under the path defined in the aforementioned config file:

 $ sudo ccm32 c

Attempt to build the package in the clean 64-bit chroot. If successful, the package will be added to a local pacman repo inside the chroot so that it will be available for use as a dependency for building other packages:

 $ cd /path/to/PKGBUILD
 $ sudo ccm64 s

List out the contents of the 64-bit chroot's local repo assuming something has been built. Useful to see what is present:

 $ sudo ccm64 l

Deletes everything under the top level of the 64-bit chroot effectively removing it from the system:

 $ sudo ccm64 n

## Tips
* If your machine has lots of memory, consider locating the chroot to tmpfs to avoid disk usage/minimize access times.
* Since ccm requires sudo rights, consider making an alias for invoking it as such in your ~/.bashrc or the link. For example:
 alias ccm64='sudo ccm64'
 alias ccm32='sudo ccm32'

#Links
AUR Package: https://aur.archlinux.org/packages/clean-chroot-manager
