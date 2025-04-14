#!/bin/bash

ln -sf ./49-allow-nekoray.rules /etc/polkit-1/rules.d/

usermod -aG wheel motb
