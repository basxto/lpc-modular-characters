#!/bin/sh
for file in male_drake_head.png male_drake_head_shadow.png male_human_head.png male_human_head_shadow.png male_ogre_head.png male_skeleton_head.png;do
    ./lpc-shell-tools/duplimap.sh ${file} ./lpc-shell-tools/animation/head/male/walkcycle.map.csv 64 64
done