# LIVEBTFS (bittorrent for live filesystem)

## What is this?

With LIVEBTFS, you can mount any **.torrent** file or **magnet link** and then use it as any read-only directory in your file tree. The contents of the files will be downloaded on-demand as they are read by applications. Tools like **ls**, **cat** and **cp** works as expected. Applications like **vlc** and **mplayer** can also work without changes.

## Example usage

    $ mkdir mnt
    $ livebtfs video.torrent mnt
    $ cd mnt
    $ vlc video.mp4

To unmount and shutdown:

    $ fusermount -u mnt

## Dependencies (on Linux)

* fuse ("fuse" in Ubuntu 16.04)
* libtorrent ("libtorrent-rasterbar8" in Ubuntu 16.04)
* libcurl ("libcurl3" in Ubuntu 16.04)

## Building from git on a recent Debian/Ubuntu

    $ sudo apt-get install make g++ libfuse-dev libtorrent-rasterbar-dev libcurl4-openssl-dev gzip
    $ git clone https://github.com/Raizo62/livebtfs.git livebtfs
    $ cd livebtfs
    $ make

And optionally, if you want to install it:

    $ make install
