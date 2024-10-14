# Secure Boot

## Backstory

I'm a gamer, and I mostly play [Fortnite](https://www.fortnite.com/), [Counter-Strike](https://www.counter-strike.net/) ([FACEIT](https://www.faceit.com/en)) and many single-player games.<br>
These multiplayer games require Anti-Cheat software, such as [Easy Anti-Cheat](https://www.easy.ac/en-US) or [FACEIT Anti-Cheat](https://www.faceit.com/en/anti-cheat), respectively.

In order to run this software, [Secure Boot](https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/oem-secure-boot) must be enabled on your System's [BIOS](https://en.wikipedia.org/wiki/BIOS).

So, what's the problem?<br>
Building a Hackintosh usually requires that you _disable_ `Secure Boot`.

But, since I need it enabled... what can I do?

## The Fix

To "fix" this, I needed to find a way to have both: `Secure Boot` & `macOS`.<br>
In this folder / guide, you'll find all you need in order to do it, just the way I did!

### First Steps

#### WSL

Firstly, we need [WSL](https://learn.microsoft.com/en-us/windows/wsl/about).<br>
`Windows Sub-System for Linux` is a feature that allows you to run a [Linux](https://en.wikipedia.org/wiki/Linux) Environment within your Windows installation.

Refer to [this](https://learn.microsoft.com/en-us/windows/wsl/install) article, for instructions on how to install it and get started. I suggest [Ubuntu](https://ubuntu.com/desktop/wsl).

#### Tools

After installing `WSL`, you'll need some tools.

To install them, run the following, within the Ubuntu Terminal:
- `sudo apt update && sudo apt upgrade` - This will update all Packages.
- `sudo apt install unzip sbsigntool efitools` - This will install the required Packages (`UNZIP`, `SBSignTool` & `EFITools`).

We also need `OpenSSL`, but it is installed by default.

### Creating Keys

Now, we need to create Keys that we'll use to sign `OpenCore` as a trusted [Operating System](https://en.wikipedia.org/wiki/Operating_system).<br>
In the commands shown below, replace `NAME` with a name of your choosing - like `OPENCORE`.

Create a folder to store the files we'll create, by running:
- `mkdir EFIKeys` - Creates the folder.
- `cd EFIKeys` - Moves you into the folder.

#### Platform Key

To generate a `PK`, run the following command:
- `openssl req -new -x509 -newkey rsa:2048 -sha256 -days 3650 -nodes -subj "/CN=NAME PK Platform Key/" -keyout PK.key -out PK.pem`

#### Key Exchange Key

To generate a `KEK`, run the following command:
- `openssl req -new -x509 -newkey rsa:2048 -sha256 -days 3650 -nodes -subj "/CN=NAME KEK Exchange Key/" -keyout KEK.key -out KEK.pem`

#### Initial Supplier Key

To generate an `ISK`, run the following command:
- `openssl req -new -x509 -newkey rsa:2048 -sha256 -days 3650 -nodes -subj "/CN=NAME ISK Image Signing Key/" -keyout ISK.key -out ISK.pem`

### Key Permissions

To use these Keys, we need to give them the proper [Permissions](https://www.redhat.com/sysadmin/linux-file-permissions-explained).<br>
Do so by running:
- `chmod 0600 *.key`

### Certificates & Keys

Since we're manually selecting the `Certificates` we want within our `BIOS`' `Secure Boot` Database, we need to get and sign Microsoft's `Certificates` manually.<br>
Inside the `Microsoft Certificates` folder, you'll find the `.CRT` files you need.

#### Copy to Working Folder

To copy the `Certificates` to your working folder, created earlier, run the following commands, replacing `NAME` with your Windows Username:
- `cp /mnt/c/Users/NAME/Downloads/MicCorUEFCA2011_2011-06-27.crt ~/EFIKeys`
- `cp /mnt/c/Users/NAME/Downloads/MicWinProPCA2011_2011-10-19.crt ~/EFIKeys`

#### Sign Microsoft Certificates

We now need to sign the `Certificates`, by running:
- `openssl x509 -in MicWinProPCA2011_2011-10-19.crt -inform DER -out MicWinProPCA2011_2011-10-19.pem -outform PEM`
- `openssl x509 -in MicCorUEFCA2011_2011-06-27.crt -inform DER -out MicCorUEFCA2011_2011-06-27.pem -outform PEM`

These commands will generate two `PEM - Privacy Enhanced Mail` Certificates.

#### Convert PEM to ESL

`SecureBoot` requires `ESL - EFI Signature List` Certificates, instead of `PEM` Certificates.

First, let's convert our `PK`, `KEK` and `ISK`:
- `cert-to-efi-sig-list -g $(uuidgen) PK.pem PK.esl`
- `cert-to-efi-sig-list -g $(uuidgen) KEK.pem KEK.esl`
- `cert-to-efi-sig-list -g $(uuidgen) ISK.pem ISK.esl`

Now, the Microsoft Certificates:
- `cert-to-efi-sig-list -g $(uuidgen) MicWinProPCA2011_2011-10-19.pem MicWinProPCA2011_2011-10-19.esl`
- `cert-to-efi-sig-list -g $(uuidgen) MicCorUEFCA2011_2011-06-27.pem MicCorUEFCA2011_2011-06-27.esl`

#### Create Signature Database

Our `ISK - Initial Supplier Key` will be used, alongside the Microsoft Certificates, to create the `Signature Database`, as such:
- `cat ISK.esl MicWinProPCA2011_2011-10-19.esl MicCorUEFCA2011_2011-06-27.esl > db.esl`

#### Sign ESL Lists

We must now sign our `ESL - EFI Signature List` Lists, as such:
- `sign-efi-sig-list -k PK.key -c PK.pem PK PK.esl PK.auth` - `PK` Is Signed With Itself.
- `sign-efi-sig-list -k PK.key -c PK.pem KEK KEK.esl KEK.auth` - `KEK` Is Signed With `PK`.
- `sign-efi-sig-list -k KEK.key -c KEK.pem db db.esl db.auth` - Database Is Signed With `KEK`.

#### Final Files

Finally, we are left with these `.auth` `Signature Lists`:
- `PK.auth`
- `KEK.auth`
- `db.auth`

And these `Keys`:
- `ISK.key`
- `ISK.pem`

The `.auth` files will be used to integrate your `Signatures` into your `Firmware`, via your `BIOS`.<br>
The `.key` and `.pem` files will be used to sign `OpenCore`'s files.

### OpenCore

#### Move Signing Keys

Firstly, create a Working Directory:
- `mkdir OC`

Now, copy your `Keys` to this new directory:
- `cp ISK.key ISK.pem OC/`

Let's move into the directory:
- `cd OC`

#### Sign OpenCore Files

We now need to sign the `OpenCore` files.

This process, however, can take a long time.<br>
So, to make things easier, I wrote a Script, based on one written by @profzei - `sign_opencore.sh`.

It will download the `Version` and `Type` of `OpenCore` you choose, go through the files and finally sign each one, recursively.

To use it, you should first make the Script executable:
- `chmod +x sign_opencore.sh`

Now, let's run it:
- `sh sign_opencore.sh 1.0.0 RELEASE` - I chose version `1.0.0 Release` as an example.

After the Script finishes, you will have a new folder, called `Signed`.<br>
Inside, you'll find the signed `OpenCore` files!

All you need to do now is replace the files you have within your `EFI` folder with the signed versions of themselves.

#### Apple Secure Boot

To be able to boot a secure version of `macOS`, you'll need to set the following options within your `config.plist`:
- `SecureBootModel` -> `Default`
- `AppleSecureBoot` -> `True`

### BIOS

Within your `BIOS`, head over to the `Secure Boot` section.<br>
Here, set the `Signature Lists`, as named: `PK`, `KEK` & `DB`.

At this point, you can reboot your System and boot into `macOS`!

## What Now?

If everything went as it should, your System is now prepared to boot `macOS` securely!<br>
Since you included Microsoft's Certificates, `Windows` will also boot securely.

Therefore, Anti-Cheat software now has no problem with your System and will work as expected!

## Extras

There are a few caveats.<br>
Check out `Extras` for more information.