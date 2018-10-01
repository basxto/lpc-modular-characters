default: male_wolfbrown_normal_wolf_walkcycle_compound.png male_ivory_normal_skeleton_walkcycle_compound.png female_drakegreen_normal_lizard_walkcycle_compound.png male_drakegreen_normal_lizard_walkcycle_compound.png female_ogregreen_normal_ogre_walkcycle_compound.png male_ogregreen_muscular_ogre_walkcycle_compound.png female_ivory_normal_human_walkcycle_compound.png male_ivory_normal_human_walkcycle_compound.png male_ivory_muscular_human_walkcycle_compound.png

male_ivory_ogre_shadow_head.png: no_shadow.png
	cp $< $@

male_ivory_wolf_shadow_head.png: no_shadow.png
	cp $< $@

female_ivory_ogre_shadow_head.png: female_ivory_human_shadow_head.png
	cp $< $@

female_ivory_ogre_head.png: female_ivory_human_head.png female_ivory_ogre_overlay_head.png
	convert -background none $? -layers flatten $@

male_%_head_walkcycle.png: male_%_head.png
	./lpc-shell-tools/duplimap.sh $< $@ ./lpc-shell-tools/animation/head/male/walkcycle.map.csv 64 64

female_%_head_walkcycle.png: female_%_head.png
	./lpc-shell-tools/duplimap.sh $< $@ ./lpc-shell-tools/animation/head/female/walkcycle.map.csv 64 64

male_ogregreen_%.png: male_ivory_%.png
	./lpc-shell-tools/switchpalette.sh $< $@ palette/skin/ivory.gpl palette/skin/ogre_green.gpl

female_ogregreen_%.png: female_ivory_%.png
	./lpc-shell-tools/switchpalette.sh $< $@ palette/skin/ivory.gpl palette/skin/ogre_green.gpl

male_drakegreen_%.png: male_ivory_%.png
	./lpc-shell-tools/switchpalette.sh $< $@ palette/skin/ivory.gpl palette/skin/drake_green.gpl

female_drakegreen_%.png: female_ivory_%.png
	./lpc-shell-tools/switchpalette.sh $< $@ palette/skin/ivory.gpl palette/skin/drake_green.gpl

male_wolfbrown_%.png: male_ivory_%.png
	./lpc-shell-tools/switchpalette.sh $< $@ palette/skin/ivory.gpl palette/skin/wolf_brown.gpl

female_wolfbrown_%.png: female_ivory_%.png
	./lpc-shell-tools/switchpalette.sh $< $@ palette/skin/ivory.gpl palette/skin/wolf_brown.gpl

%_normal_human_walkcycle_compound.png: %_normal_headless_walkcycle.png %_human_shadow_head_walkcycle.png %_human_head_walkcycle.png
	convert -background none $? -layers flatten $@

%_muscular_human_walkcycle_compound.png: %_muscular_headless_walkcycle.png %_human_shadow_head_walkcycle.png %_human_head_walkcycle.png
	convert -background none $? -layers flatten $@

%_normal_ogre_walkcycle_compound.png: %_normal_headless_walkcycle.png %_ogre_shadow_head_walkcycle.png %_ogre_head_walkcycle.png
	convert -background none $? -layers flatten $@

%_muscular_ogre_walkcycle_compound.png: %_muscular_headless_walkcycle.png %_ogre_shadow_head_walkcycle.png %_ogre_head_walkcycle.png
	convert -background none $? -layers flatten $@

%_normal_drake_walkcycle_compound.png: %_normal_headless_walkcycle.png %_drake_shadow_head_walkcycle.png %_drake_head_walkcycle.png
	convert -background none $? -layers flatten $@

%_muscular_drake_walkcycle_compound.png: %_muscular_headless_walkcycle.png %_drake_shadow_head_walkcycle.png %_drake_head_walkcycle.png
	convert -background none $? -layers flatten $@

%_normal_lizard_walkcycle_compound.png: %_normal_headless_walkcycle.png %_lizard_shadow_head_walkcycle.png %_lizard_head_walkcycle.png
	convert -background none $? -layers flatten $@

%_muscular_lizard_walkcycle_compound.png: %_muscular_headless_walkcycle.png %_lizard_shadow_head_walkcycle.png %_lizard_head_walkcycle.png
	convert -background none $? -layers flatten $@

%_normal_wolf_walkcycle_compound.png: %_normal_headless_walkcycle.png %_wolf_shadow_head_walkcycle.png %_wolf_head_walkcycle.png
	convert -background none $? -layers flatten $@

%_muscular_wolf_walkcycle_compound.png: %_muscular_headless_walkcycle.png %_wolf_shadow_head_walkcycle.png %_wolf_head_walkcycle.png
	convert -background none $? -layers flatten $@

%_normal_skeleton_walkcycle_compound.png: %_normal_headless_walkcycle.png male_skeleton_head_walkcycle.png
	convert -background none $? -layers flatten $@

%_muscular_skeleton_walkcycle_compound.png: %_muscular_headless_walkcycle.png male_skeleton_head_walkcycle.png
	convert -background none $? -layers flatten $@

clean:
	-rm -r tmp_*
	-rm *_head_*.png *green_*.png *brown_*.png *_compound.png
	-rm *_ogre_shadow_head.png *_wolf_shadow_head.png female_*_ogre_head.png