# GPU Preparations

The `RX580 2048SP` Card is a chinese version of the well-known `RX580 Series` Card, made by AMD.

Since it isn't exactly a "proper" version of the `RX580` Card, MacOS won't recognize it, and you'll end up with a bootloop because of it.

To fix that, we must flash a new `BIOS` Firmware on the Card.

In other words, we're going to make it <i>think</i> it's an `RX570 Series` Card.

## Necessary Tools

To begin, all you need is the `AMDVBFlash` tool, which you can download [here](https://www.techpowerup.com/download/ati-atiflash/), and a proper `ROM` file for your Card.

The `ROM` file you need is already provided above.

## How To

1. Run the Driver Setup present in the folder.

2. Place the downloaded `ROM` file within the same folder of the `AMDVBFlash` tool - makes things easier.

3. Open a Terminal (or Command Prompt) within that same folder.

4. Run this command: `amdvbflash.exe -i` (This will let you know which slot holds your GPU - <b>DO NOT SKIP</b>).

5. Run this command, using the correct slot: `amdvbflash.exe -unlockrom <slot>`.

6. Flash the provided `ROM` with the following command: `amdvbflash.exe -f -p <slot> <ROM_FILE> --show-progress`.

<br>
After these steps, your GPU <i>should</i> be flashed.

Check the Terminal for errors, and then <b>reboot</b>.

## Finishing Up

Using [GPU-Z](https://www.techpowerup.com/download/techpowerup-gpu-z/), check the data output from your GPU.

It should look like this:

![alt text](https://github.com/danfq/Ryzentosh-Sonoma/blob/main/GPU%20Preparations/success.png?raw=true)


You're done!
<br>
Your `RX580 2048SP` is now MacOS-Ready!