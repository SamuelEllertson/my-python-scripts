#!/usr/bin/env python

from my_utils.args import parseArgs
from my_utils.helpers import isFloat

import matplotlib.pyplot as plot
import sys


def main():
    args = getArgs()
    function = getFunction(args)

    function(args)

#abstract away which function gets called
def getFunction(args):

    if(args.type == "histogram"):
        return histogram

    if args.type == "bar":
        return bar

    #not really necessary
    return lambda value: None

def histogram(args):
    plot.hist(args.data, bins=args.bins)
    autoScaleAndDisplay()

def bar(args):
    data = args.data
    size = len(data)
    xvalues = range(0, size)

    plot.bar(x=xvalues, height=data, width=1)
    autoScaleAndDisplay()

def autoScaleAndDisplay():
    plot.autoscale(enable=True, axis='both', tight=True)
    plot.show()

def getArgs():
    argType = {
        "flags": ["-t", "--type"],
        "options": {
            "default": "histogram",
            "choices": ["histogram", "bar"],
            "help": "choose what plot to use",
            "metavar": "plot"
        }
    }
    argBins = {
        "flags": ["-b", "--bins"],
        "options": {
            "default": None,
            "type": int,
            "help": "Number of bins to use",
            "metavar": "int"
        }
    }
    argInput = {
        "flags": "input",
        "options": {
            "nargs": "*",
            "default": [],
            "help": "The values to plot"
        }
    }

    parserSetup = {
        "description": "Plots values, default is histogram.\
        If no input is specified, it reads values from stdin",
        "args": [
            argType,
            argBins,
            argInput
        ]
    }

    args = parseArgs(parserSetup)

    #read from stdin if no input supplied
    if(len(args.input) == 0):
        args.input = sys.stdin.read().split()

    #convert to proper list of values
    args.data = [float(line) for line in args.input if isFloat(line)]

    return args

if __name__ == '__main__':
    debug = False

    if debug:
        main()
        sys.exit()

    try:
       main()
    except Exception:
        print("plot: an error occured", file=sys.stderr)