#!/bin/bash

set -x

fly m run . --schedule daily -a s2ofgo --vm-memory 512
