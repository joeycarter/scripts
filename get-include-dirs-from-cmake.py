#!/usr/bin/env python

"""
Get Project Include Directories from CMake
==========================================

Get project include directories from the associated CMake file. This is useful
for configuring an IDE or text editor for a project that uses Athena or other
ATLAS software.
"""

from __future__ import absolute_import, division, print_function


import argparse
import sys


def _docstring(docstring):
    """Return summary of docstring
    """
    return " ".join(docstring.split('\n')[4:7]) if docstring else ""


def parse_args():
    """Parse command-line arguments
    """
    parser = argparse.ArgumentParser(description=_docstring(__doc__))
    parser.add_argument("--version", action="version", version="%(prog)s 0.1")
    parser.add_argument("-v", "--verbose", action="count", default=0,
                        help="print verbose messages; multiple -v result in more verbose messages")
    parser.add_argument("infile", help="Path to the 'flags.make' file in your build directory")

    args = parser.parse_args()

    return args


def main():
    try:
        args = parse_args()

        with open(args.infile, "r") as infile:
            flags_file = infile.readlines()

        cxx_includes = [s for s in flags_file if s.startswith("CXX_INCLUDES")]

        if len(cxx_includes) != 1:
            print("warning: using first instances of 'CXX_INCLUDES' in {}".format(args.infile))

        cxx_includes = cxx_includes[0].strip()

        for inc_dir in cxx_includes.split():
            if inc_dir in ["CXX_INCLUDES", "=", "-isystem"]:
                continue

            print(inc_dir.strip("-I"))

    except KeyboardInterrupt:
        return 1


if __name__ == '__main__':
    sys.exit(main())
