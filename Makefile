DESTDIR := build
switchpalette=./lpc-shell-tools/switchpalette.sh
duplimap=./lpc-shell-tools/duplimap.sh
pandoc=pandoc
loadgpl=loadgpl/loadgpl.py
convert=magick convert
convert+= -background none

default: $(DESTDIR)/male_wolfbrown_normal_wolf_all.png $(DESTDIR)/male_ivory_normal_skeleton_walkcycle_compound.png $(DESTDIR)/female_drakegreen_normal_lizard_all.png $(DESTDIR)/male_drakegreen_normal_lizard_all.png $(DESTDIR)/female_ogregreen_normal_ogre_all.png $(DESTDIR)/male_ogregreen_muscular_ogre_all.png $(DESTDIR)/female_ivory_normal_human_all.png $(DESTDIR)/male_ivory_normal_human_all.png $(DESTDIR)/male_ivory_muscular_human_all.png $(DESTDIR)/female_ivory_pregnant_human_all.png

$(DESTDIR)/:
	mkdir build

$(DESTDIR)/%.png: headless/%.png $(DESTDIR)/
	cp $< $@

$(DESTDIR)/male_ivory_ogre_shadow_head.png: no_shadow.png $(DESTDIR)/
	cp $< $@

$(DESTDIR)/male_ivory_wolf_shadow_head.png: no_shadow.png $(DESTDIR)/
	cp $< $@

$(DESTDIR)/female_ivory_wolf_shadow_head.png: no_shadow.png $(DESTDIR)/
	cp $< $@

$(DESTDIR)/female_ivory_ogre_shadow_head.png: head/female_ivory_human_shadow_head.png $(DESTDIR)/
	cp $< $@

$(DESTDIR)/female_ivory_ogre_head.png: head/female_ivory_human_head.png overlay/female_ivory_ogre_overlay_head.png $(DESTDIR)/
	$(convert)  $? -layers flatten $@

$(DESTDIR)/%_head_walkcycle.png: head/%_head.png $(DESTDIR)/
	./lpc-shell-tools/duplimap.sh $< $@ ./lpc-shell-tools/animation/head/$(shell echo $* | cut -d'_' -f1)/walkcycle.map.csv 64 64

$(DESTDIR)/%_head_walkcycle.png: $(DESTDIR)/%_head.png
	./lpc-shell-tools/duplimap.sh $< $@ ./lpc-shell-tools/animation/head/$(shell echo $* | cut -d'_' -f1)/walkcycle.map.csv 64 64

$(DESTDIR)/%_head_slash.png: head/%_head.png $(DESTDIR)/
	./lpc-shell-tools/duplimap.sh $< $@ ./lpc-shell-tools/animation/head/$(shell echo $* | cut -d'_' -f1)/slash.map.csv 64 64

$(DESTDIR)/%_head_slash.png: $(DESTDIR)/%_head.png
	./lpc-shell-tools/duplimap.sh $< $@ ./lpc-shell-tools/animation/head/$(shell echo $* | cut -d'_' -f1)/slash.map.csv 64 64

$(DESTDIR)/male_ogregreen_%.png: $(DESTDIR)/male_ivory_%.png
	$(switchpalette) $< $@ palette/skin/ivory.gpl palette/skin/ogre_green.gpl

$(DESTDIR)/female_ogregreen_%.png: $(DESTDIR)/female_ivory_%.png
	$(switchpalette) $< $@ palette/skin/ivory.gpl palette/skin/ogre_green.gpl

$(DESTDIR)/male_drakegreen_%.png: $(DESTDIR)/male_ivory_%.png
	$(switchpalette) $< $@ palette/skin/ivory.gpl palette/skin/drake_green.gpl

$(DESTDIR)/female_drakegreen_%.png: $(DESTDIR)/female_ivory_%.png
	$(switchpalette) $< $@ palette/skin/ivory.gpl palette/skin/drake_green.gpl

$(DESTDIR)/male_wolfbrown_%.png: $(DESTDIR)/male_ivory_%.png
	$(switchpalette) $< $@ palette/skin/ivory.gpl palette/skin/wolf_brown.gpl

$(DESTDIR)/female_wolfbrown_%.png: $(DESTDIR)/female_ivory_%.png
	$(switchpalette) $< $@ palette/skin/ivory.gpl palette/skin/wolf_brown.gpl

$(DESTDIR)/%_skeleton_walkcycle_compound.png: $(DESTDIR)/%_headless_walkcycle.png $(DESTDIR)/male_skeleton_head_walkcycle.png
	$(convert) $? -layers flatten $@

$(DESTDIR)/%_all.png: $(DESTDIR)/%_walkcycle_compound.png $(DESTDIR)/%_slash_compound.png
	$(convert) -append $? $@ 

attribution.pdf: attribution.md
	$(pandoc) $< -o $@

attribution.html: attribution.md
	$(pandoc) -s --metadata pagetitle="Attributions for modular bodies and heads" -t html5 $< -o $@

.SECONDEXPANSION:
$(DESTDIR)/%_compound.png: $(DESTDIR)/$$(shell echo $$* | cut -d'_' -f1-3)_headless_$$(shell echo $$* | cut -d'_' -f5).png $(DESTDIR)/$$(shell echo $$* | cut -d'_' -f1-2)_$$(shell echo $$* | cut -d'_' -f4)_head_$$(shell echo $$* | cut -d'_' -f5).png $(DESTDIR)/$$(shell echo $$* | cut -d'_' -f1-2)_$$(shell echo $$* | cut -d'_' -f4)_shadow_head_$$(shell echo $$* | cut -d'_' -f5).png
	$(convert) $? -layers flatten $@

clean:
	-rm -r tmp_$(DESTDIR)/ $(DESTDIR)/ attribution.pdf attribution.html