DESTDIR := build
TMP := tmp
PREFIX := lpcmodchar
switchpalette=./lpc-shell-tools/switchpalette.sh
duplimap=./lpc-shell-tools/duplimap.sh
pandoc=pandoc
loadgpl=loadgpl/loadgpl.py
convert=magick convert
convert+= -background none

default: $(DESTDIR)/$(PREFIX)_male_normal_wolf_wolf.png $(DESTDIR)/$(PREFIX)_female_pregnant_human_ivory.png  $(DESTDIR)/$(PREFIX)_male_muscular_ogre_ogre.png

$(DESTDIR)/:
	mkdir build

# don't delete these automatically
.PRECIOUS: $(DESTDIR)/$(PREFIX)_%.png

# build full collection
$(DESTDIR)/$(PREFIX)_%.png:
# know what to build when you want just one animation (for gif)
$(DESTDIR)/$(PREFIX)_%__walkcycle.png:
$(DESTDIR)/$(PREFIX)_%__slash.png:
	./build.sh $(DESTDIR)/$(PREFIX)_$*.png

# turn spritesheet into gif
# also compress the gif
$(DESTDIR)/%.gif: $(DESTDIR)/%.png
	$(convert) -delay 16 $< -crop 64x256 +repage -set dispose background -loop 0 -layers optimize -compress LZW $@

attribution.pdf: attribution.md
	$(pandoc) $< -o $@

attribution.html: attribution.md
	$(pandoc) -s --metadata pagetitle="Attributions for modular bodies and heads" -t html5 $< -o $@

.PHONY:
buildable:
	chmod +x ./build.sh

clean:
	-rm -rf tmp_$(DESTDIR)/ $(TMP)/ $(DESTDIR)/ attribution.pdf attribution.html