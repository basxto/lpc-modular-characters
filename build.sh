#!/bin/sh
prefix="lpcmodchar"
loadgpl="loadgpl/loadgpl.py"

strip_base(){
    input=$1
    # allow cin
    if [ -z "${input}" ]; then
        read -r input
    fi
    echo "${input}" | sed "s/${prefix}_\(.*\)/\1/g"
}

usage(){
    echo "Usage:"
    echo "$ $0 [--list] [--help/--usage] [--random] ${prefix}_<gender>_<bodytype>_<head>_<skincolor>.png"
}

fix_transparency(){
    magick $1 -transparent "#000000" $1
}

build_character(){
    name=$(strip_base "$(basename $1 .png)")
    dir=$(strip_base "$(dirname $1)")
    tmp=./tmp
    if [ -z "${dir}" ]; then
        dir="build/"
    fi
    mkdir -p "${dir}" "${tmp}"

    gender=$(echo ${name} | cut -f1 -d_)
    body=$(echo ${name} | cut -f2 -d_)
    head=$(echo ${name} | cut -f3 -d_)
    skinc=$(echo ${name} | cut -f4 -d_)
    if [ -z "$skinc" ]; then
        skinc="ivory"
    fi

    animations="walkcycle slash"

    # change skin colors
    for animation in ${animations}; do
        ${loadgpl} headless/${gender}/${body}_${animation}.png palette/skin/${skinc}.gpl ${tmp}/${gender}_${body}_headless_${animation}_${skinc}.png
        fix_transparency ${tmp}/${gender}_${body}_headless_${animation}_${skinc}.png
    done
    if [ "${head}" == "skeleton" ]; then
        # these heads do not use palette swapping
        cp head/${gender}/${head}_head.png ${tmp}/${gender}_${head}_head_${skinc}.png
    else
        ${loadgpl} head/${gender}/${head}_head.png palette/skin/${skinc}.gpl ${tmp}/${gender}_${head}_head_${skinc}.png
    fi
    fix_transparency ${tmp}/${gender}_${head}_head_${skinc}.png
    if [ -f head/${gender}/${head}_head_shadow.png ];then
        ${loadgpl} head/${gender}/${head}_head_shadow.png palette/skin/${skinc}.gpl ${tmp}/${gender}_${head}_head_shadow_${skinc}.png
        fix_transparency ${tmp}/${gender}_${head}_head_shadow_${skinc}.png
    else
        cp no_shadow.png ${tmp}/${gender}_${head}_head_shadow_${skinc}.png
    fi

    # rearrange heads for animations
    for animation in ${animations}; do
        ./lpc-shell-tools/duplimap.sh ${tmp}/${gender}_${head}_head_${skinc}.png ${tmp}/${gender}_${head}_head_${skinc}_${animation}.png ./lpc-shell-tools/animation/head/${gender}/${animation}.map.csv 64 64
        ./lpc-shell-tools/duplimap.sh ${tmp}/${gender}_${head}_head_shadow_${skinc}.png ${tmp}/${gender}_${head}_head_shadow_${skinc}_${animation}.png ./lpc-shell-tools/animation/head/${gender}/${animation}.map.csv 64 64
    done

    # combine each animation
    for animation in ${animations}; do
        magick convert -background none ${tmp}/${gender}_${body}_headless_${animation}_${skinc}.png ${tmp}/${gender}_${head}_head_shadow_${skinc}_${animation}.png  ${tmp}/${gender}_${head}_head_${skinc}_${animation}.png -layers flatten ${tmp}/${gender}_${body}_${animation}_${skinc}.png
    done
    # remove target file if it already exists
    [ -f $1 ] && rm $1
    # combine all animations into one big spritesheet
    for animation in ${animations}; do
        if [ -f $1 ]; then
            magick montage -mode concatenate -tile 1x -background none $1 ${tmp}/${gender}_${body}_${animation}_${skinc}.png $1
        else
            cp ${tmp}/${gender}_${body}_${animation}_${skinc}.png $1
        fi
    done
}

get_gender(){
    for i in headless/*; do
        basename $i | strip_base
    done
}

get_body(){
    gender=$1
    for i in headless/${gender}/*_walkcycle.png; do
        basename $i _walkcycle.png | strip_base
    done
}

get_head(){
    gender=$1
    for i in head/${gender}/*_head.png; do
        basename $i _head.png | strip_base
    done
}

get_skincolor(){
    for i in palette/skin/*; do
        basename $i .gpl | strip_base
    done
}

list(){
    echo "Gender:"
    for i in $(get_gender); do
        echo "- $i"
    done
    echo
    echo "Body:"
    echo " Male:"
    for i in $(get_body "male"); do
        echo " - $i"
    done
    echo " Female:"
    for i in $(get_body "female"); do
        echo " - $i"
    done
    echo
    echo "Head:"
    echo " Male:"
    for i in $(get_head "male"); do
        echo " - $i"
    done
    echo " Female:"
    for i in $(get_head "female"); do
        echo " - $i"
    done
    #echo " Both:"
    #for i in $(get_hair "both"); do
    #    echo " - $i"
    #done
    echo
    echo "Skin color:"
    for i in $(get_skincolor); do
        echo "- $i"
    done
}

random(){
    gender=$(get_gender | sort -R | head -1)
    body=$(get_body ${gender} | grep -v "none" | sort -R | head -1)
    head=$(get_head ${gender} | grep -v "none" | sort -R | head -1)
    skinc=$(get_skincolor | sort -R | head -1)
    filename=build/${prefix}_${gender}_${body}_${head}_${skinc}.png
    echo "${filename}"
    build_character ${filename}
}

if [ "$#" == "0" ]; then
    usage
    exit
fi

case "$1" in
    "--list")
        list
        exit
        ;;
    "--usage"|"--help")
        usage
        exit
        ;;
    "--clean")
        make clean
        exit
        ;;
    "--random")
        random
        exit

esac
while [ "$#" != "0" ]; do
    build_character $1
    shift
done