#!/bin/sh

if [ -f "/usr/local/bin/mint" ] ; then
    ./Utilities/StencilPreprocessor.swift ./Templates ./.build/Templates
    mint run krzysztofzablocki/Sourcery
else
    echo "Please install the Mint package manager (https://github.com/yonaskolb/Mint) to continue."
fi
