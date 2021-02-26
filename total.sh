#!/bin/bash
#

let V=$(grep -c "PX" packages.csv)+$(grep -c "A," packages.csv)
   
echo $V
