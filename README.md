# LIVEBTFS (bittorrent for live filesystem)

## What is this?

With LiveBTFS, you can mount any **.torrent** file or **magnet link** and then use it as any read-only directory in your file tree. The needed bytes of the files will be downloaded only when they are read by applications. Tools like **ls**, **cat** and **cp** works as expected.

LiveBTFS is optimized to access to remote OS

It is based on btfs (https://github.com/johang/btfs)

## Example usage

  * Download the torrent of the VM (example : an iso of Kali Linux)
```bash
    $ wget https://images.kali.org/kali-linux-2020.1b-live-amd64.iso.torrent
```

  * Create a mount point
```bash
    $ mkdir -p mnt/kali
```

  * Mount the VM
```bash
    $ livebtfs kali-linux-2020.1b-live-amd64.iso.torrent mnt/kali
```

The iso file is "mnt/kali/kali-linux-2020-1b-live-amd64-iso/kali-linux-2020.1b-live-amd64.iso"

  * Start the VM with your Hypervisor (example : qemu)
```bash
    $ qemu-system-x86_64 -m 1024 -cdrom mnt/kali/kali-linux-2020-1b-live-amd64-iso/kali-linux-2020.1b-live-amd64.iso -enable-kvm -usb -device usb-tablet
    $ vncviewer 'vnc:[::1]:5900'
```

  * To unmount and shutdown:
```bash
    $ fusermount -u mnt/kali
```

## Dependencies (on Linux)

* fuse : "fuse" in Debian / Ubuntu
* libtorrent : "libtorrent-rasterbar10" in Debian / Ubuntu
* libcurl : "libcurl4" in Debian / Ubuntu

## Building from git on a recent Debian/Ubuntu

```bash
    $ sudo apt-get install make g++ libfuse-dev libtorrent-rasterbar-dev libcurl4-openssl-dev gzip
    $ git clone https://github.com/Raizo62/livebtfs.git livebtfs
    $ cd livebtfs
    $ make
```

And optionally, if you want to install it:

```bash
    $ make install
```
