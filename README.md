### What it is

This toolkit aims to be an all-in-one solution for post-installation, expediting your Arch setup. It's offered as *use at your own risk* type of thing, without much support. You will have to rely on yourself and your own knowledge and ability to do research your setup. For more detailed info visit the [**Wiki**](https://github.com/xerolinux/xlapit-cli/wiki).

![XLAPiT](https://i.imgur.com/JuWceYE.png)

<div align="center">

#### Activate either ChaoticAUR "OR" CachyOS Repos, NOT "Both".

#### !!! CachyOS Repos are for Advanced Users Only !!! <br />
#### (Activating them will convert your Arch to CachyOS)

</div>

### How to get it

First off let me say that everything this awesome toolkit provides is and will forever be optional and up to you the user. I will never force anything on you. Now just run this simple curl command to get started.

```
bash -c "$(curl -fsSL https://tinyurl.com/xtoolkit)"
```

It will prompt you before injecting as in adding the XeroLinux repository, where from it will then prompt you, should you agree, as to which AUR helper you prefer, then proceed to do so then install and launch the toolkit.. Again only if you agree..

**- Check the code 1st :**

> For security, don't just run script, without inspecting it first. So before using _Curl_ command you can examine it => [**HERE**](https://raw.githubusercontent.com/xerolinux/xerocurl/main/xapi.sh)

### Acessing Toolkit

You can access toolkit by either typing `xero-cli -m` in terminal or from the application menu via the **XeroLinux Post Installation Toolkit** shortcut.. Just close terminal window once done using it lol ;)

### Toolkit Notes

It's crucial to clarify that this toolkit isn't intended for custom Arch-Based distros. While some elements might function, I can't ensure seamless compatibility due to potential conflicts arising from differing tweaks and repositories. To ensure optimal performance, it's strongly recommended for use on a clean Pure-Arch install executed through the **ArchInstall** script. Nor will it provide Arch or DE/WM installations.

### GPU Driver Notes

When it comes to **GPU Drivers**, toolkit cover most common setups. There is a caveat that comes with that, it currently does **NOT** cover the AMD/nVidia Hybrid ones. For those you will have to consult online documentation, sorry. Anyway, by answering the prompts correctly you will have your system(s) up and running in no time at all. Even Kernel modiules will load for **nVidia**. If you have any issues let me know here...

### 3rd Party Kernel Support

No 3rd party Kernels are supported by this toolkit. Only Vanilla one. So if you install any, please remember to include their headers for seamless functionality of anything that relies on *DKMS* (Dynamic Kernel Modules). Keep that in mind while using this toolkit.

### How to Contribute

If you can/want to Contribute your knowledge improving this toolkit taking it above and beyond, making it the defacto for every **Arch** user, please see [**Here**](https://github.com/xerolinux/xlapit-cli/wiki/User-Contribution) for more information.
