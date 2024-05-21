### What it is

This toolkit aims to be an all-in-one solution for post-installation, expediting your Arch setup. It's offered as *use at your own risk* type of thing, without any support. You will have to rely on yourself and your own knowledge and ability to do research when it comes to the provided tools and your setup. For more detailed info visit the [**Wiki**](https://github.com/xerolinux/xlapit-cli/wiki).

![XLAPiT](https://i.imgur.com/JuWceYE.png)

<div align="center">

### ! DO NOT ADD CachyOS Repo !

#### ...Unless you know what you are doing...

</div>

### How to get it

First off let me say that everything this awesome toolkit provides is and will forever be optional and up to you the user. I will never force anything on you. Now just run this simple curl command to get started.

```
bash -c "$(curl -fsSL https://tinyurl.com/xtoolkit)"
```

It will prompt you before injecting as in adding the XeroLinux repository, where from it will then prompt you, should you agree, as to which AUR helper you prefer, then proceed to do so then install and launch the toolkit.. Again only if you agree..

**- For the security concious :**

If you care about security, instead of using _Curl_ command you can download the script, inspect it then run it.. Do it via the following commands :
```
wget https://tinyurl.com/xt-code
```
And after inspection set as executable and run via
```
chmod +x xapi.sh && ./xapi.sh
```

You can access toolkit by either typing `xero-cli -m` in terminal or from the application menu via the **XeroLinux Post Installation Toolkit** shortcut.. Just close terminal window once done using it lol ;)

### Toolkit Notes

It's crucial to clarify that this toolkit isn't intended for custom Arch-Based distros. While some elements might function, I can't ensure seamless compatibility due to potential conflicts arising from differing tweaks and repositories. To ensure optimal performance, it's strongly recommended for use on a clean Pure-Arch install executed through the **ArchInstall** script. Nor will it provide Arch or DE/WM installations.

### How to Contribute

If you can/want to Contribute your knowledge improving this toolkit taking it above and beyond, making it the defacto for every **Arch** user, please see [**Here**](https://github.com/xerolinux/xlapit-cli/wiki/User-Contribution) for more information.
