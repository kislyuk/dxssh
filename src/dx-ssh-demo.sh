#!/bin/bash

main() {
    echo "Will wait for 6000 seconds..."
    for i in {1..600}; do
        echo $i
        sleep 10
    done
}
