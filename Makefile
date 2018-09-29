default: male_ogre_head_walkcycle_green.png male_muscular_headless_walkcycle_green.png male_ivory_human_head_walkcycle.png male_ivory_human_shadow_head_walkcycle.png

male_%_head_walkcycle.png: male_%_head.png
	./lpc-shell-tools/duplimap.sh $< ./lpc-shell-tools/animation/head/male/walkcycle.map.csv 64 64

male_%_green.png: male_ivory_%.png
	./lpc-shell-tools/switchpalette.sh  $< palette/skin/ivory.gpl palette/skin/green.gpl

clean:
	-rm -r tmp_*
	-rm *_head_*.png
	-rm *_green_*.png