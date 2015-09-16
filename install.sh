#!/bin/bash

{
    echo "Starting install..."

    echo "=============="

    echo "Running npm install..."
    npm install

    echo "=============="

    echo "Running gulp task..."
    gulp test

    echo "=============="

    echo "Installed!"

} 2>&1 | tee install.log
