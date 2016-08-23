#!/usr/bin/env python
"""
reencode.py

Encode all FLAC files in the current directory to MP3 with
the specified bitrate. This script performs multiple transocding
jobs at a time. The number of child processes it creates is equal
to the number of cores on the system.

reencode.py <bit rate (Kbps)>
"""
from argparse import ArgumentParser
from glob import glob
from multiprocessing import Pool
from subprocess import run, CalledProcessError
import os
import sys

def reencode(args):
    """Worker function to encode the file"""
    file_name, bit_rate = args
    cmd = ("ffmpeg -loglevel quiet -n -i \"{file_name}.flac\""
           " -ab {bit_rate}k \"{file_name}.mp3\"").format(
               bit_rate=bit_rate,
               file_name=file_name
           )
    try:
        run(cmd, shell=True, check=True)
    except CalledProcessError:
        print("failed to encode: ", file_name, file=sys.stderr)
        return 1
    else:
        print("success: ", file_name)
        return 0

def main():
    """main method"""
    parser = ArgumentParser()
    parser.add_argument("bit_rate", type=int)

    args = parser.parse_args()
    flac_files = glob("*.flac")

    if len(flac_files) == 0:
        print("There are no FLAC files here", file=sys.stderr)
        sys.exit(1)

    if args.bit_rate < 60:
        print("Use a sane bit rate!", file=sys.stderr)
        sys.exit(1)

    if not input("Will encode {num_files} files to {bit_rate}Kbps files. OK? [Y/n]".format(
            num_files=len(flac_files), bit_rate=args.bit_rate)).lower() in ["y", "yes"]:
        print("Ok, not doing anything then.")
        sys.exit(1)

    files = ((os.path.basename(i).split(".")[0], args.bit_rate) for i in flac_files)

    with Pool() as pool:
        sys.exit(sum(pool.map(reencode, files)))


if __name__ == "__main__":
    main()
