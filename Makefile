DESTDIR := build
switchpalette=./lpc-shell-tools/switchpalette.sh
duplimap=./lpc-shell-tools/duplimap.sh
pandoc=pandoc
loadgpl=loadgpl/loadgpl.py
convert=magick convert
convert+= -background none

default: $(DESTDIR)/lpcmodchar_male_normal_wolf_wolf.png $(DESTDIR)/lpcmodchar_female_pregnant_human_ivory.png  $(DESTDIR)/lpcmodchar_male_muscular_ogre_ogre.png

$(DESTDIR)/:
	mkdir build

$(DESTDIR)/lpcmodchar_%.png:
	./build.sh $@

attribution.pdf: attribution.md
	$(pandoc) $< -o $@

attribution.html: attribution.md
	$(pandoc) -s --metadata pagetitle="Attributions for modular bodies and heads" -t html5 $< -o $@

.PHONY:
buildable:
	chmod +x ./build.sh

clean:
	-rm -r tmp_$(DESTDIR)/ $(DESTDIR)/ attribution.pdf attribution.html