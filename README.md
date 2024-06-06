# Ryzentosh (Sonoma | OC 1.0.0)

![alt text](https://github.com/danfq/Ryzentosh-Sonoma/blob/main/Screenshots/system.png?raw=true)

After quite a lot of tweaks, twists and turns, I finally made my Build 100% functional.

If you have the same Build, check out the `Releases` Page to get the EFI.<br>
Don't forget to generate your own `SMBIOS` and replace it via `ProperTree`.

To get as much Performance as you can out of your Ryzentosh, with these specifications, I suggest you use `iMac20,1`.

## Build Specifications

| Component   | Model       | Working       |
| :---        |    :----:   |          ---: |
| CPU         | AMD Ryzen 5 5600X | <b>YES</b> |
| Motherboard | PRIME B450-PLUS   | <b>YES</b> \| USB Ports Mapped    |
| RAM         | 32GB (4 x 8GB) (3400MHz)       | <b>YES</b>    |
| WiFi + BT   | BCM94360CD | <b>YES</b> |
| Storage     | Crucial P3 1TB NVMe | <b>YES</b> |
| GPU (1)     | XFX RX580 2048SP | <b>YES</b> * |
| GPU (2)     | NVIDIA RTX 3060Ti | <b>NO</b> (Unsupported \| Disabled) |

## What Works

<b>Everything!</b>

I've tested all `iServices` and ran benchmarks - no issues to report.

### CPU

![alt text](https://github.com/danfq/Ryzentosh-Sonoma/blob/main/Screenshots/cpu.png?raw=true)

### GPU
![alt text](https://github.com/danfq/Ryzentosh-Sonoma/blob/main/Screenshots/gpu.png?raw=true)

Sometimes, `GPU Monitor Pro` will report a wrong value for "Current Free Video Memory", while there are actually 8GB in total.

Most of the time, this can be "fixed" by rebooting.

\* This GPU <b>MUST</b> be flashed, before attempting to use it in MacOS.<br>
Make sure to follow the steps in the `GPU Preparations` folder.
