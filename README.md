# Warthog tutorials workspace

This repository contains the source code for the tutorials on the [Warthog website](http://www.clearpathrobotics.com/assets/guides/noetic/warthog/).

## Building the image

To build the image, run the following command:

    ./build.sh

This will build the image and tag it as `ros1:warthog-tutorials`.

## Running the image

To run the image, run the following command:

    ./run_container.sh

This will run the image and mount the source directory as a volume in the container. This means that any changes made to the files in the source directory will be reflected in the container.
