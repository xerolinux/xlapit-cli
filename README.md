# XeroLinux Arch Post Install Toolkit

This toolkit aims to be an all-in-one solution for post-installation, expediting your Arch setup. It's offered as *use at your own risk* type of thing, without any support. You will have to rely on yourself and your own knowledge and ability to do research when it comes to the provided tools and your setup. Keep that in mind before venturing into the world of **Arch**.

This repository contains all the source code for XeroCLI, and all the scripts that go with it. For more information and details, please check the included [Wiki](https://github.com/xerolinux/xlapit-cli/wiki)

![XLAPiT](https://i.imgur.com/JuWceYE.png)

### How to get it

First off let me say that everything this awesome toolkit provides is and will forever be optional and up to you the user. I will never force anything on you.

It's just a simple Terminal curl command that you run which will prompt you before injecting as in adding the XeroLinux repository, where from it will then prompt you, should you agree, as to which AUR helper you prefer, then proceed to do so then install and launch the toolkit.. Again only if you agree..

Curl Command :
```
bash -c "$(curl -fsSL https://get.xerolinux.xyz/)"
```
![](https://i.imgur.com/ZnxxpW2.png)

### Things to note

It's crucial to clarify that this toolkit isn't intended for custom Arch-Based distros. While some elements might function, I can't ensure seamless compatibility due to potential conflicts arising from differing tweaks and repositories. To ensure optimal performance, it's strongly recommended for use on a clean Pure-Arch install executed through the **ArchInstall** script.

I'd also like to highlight that unlike the **ArchInstall**, this Toolkit won't provide Arch or DE/WM installations. Setting those up fall under your responsibility. Once these are in place, you'll be able to seamlessly install and utilize our Toolkit.
