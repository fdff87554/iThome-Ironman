#!/bin/bash

while true; do
    nc -l -p 9001 -e "/setup.sh"
done
