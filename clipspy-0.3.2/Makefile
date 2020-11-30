PYTHON			?= python
CLIPS_VERSION		?= 6.31
CLIPS_SOURCE_URL	?= "https://downloads.sourceforge.net/project/clipsrules/CLIPS/6.31/clips_core_source_631.zip"
MAKEFILE_NAME		?= makefile
SHARED_LIBRARY_DIR	?= /usr/lib

.PHONY: clips clipspy test install clean

all: clips_source clips clipspy

clips_source:
	wget -O clips.zip $(CLIPS_SOURCE_URL)
	unzip -jo clips.zip -d clips_source

clips: clips_source
	$(MAKE) -f $(MAKEFILE_NAME) -C clips_source                            \
		CFLAGS="-std=c99 -O3 -fno-strict-aliasing -fPIC"               \
		LDLIBS="-lm -lrt"
	ld -G clips_source/*.o -o clips_source/libclips.so

clipspy: clips
	$(PYTHON) setup.py build_ext

test: clipspy
	cp build/lib.*/clips/_clips*.so clips
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:clips_source			       \
		$(PYTHON) -m pytest -v

install-clips: clips
	cp clips_source/libclips.so		 			       \
	 	$(SHARED_LIBRARY_DIR)/libclips.so.$(CLIPS_VERSION)
	ln -s $(SHARED_LIBRARY_DIR)/libclips.so.$(CLIPS_VERSION)	       \
	 	$(SHARED_LIBRARY_DIR)/libclips.so.6
	ln -s $(SHARED_LIBRARY_DIR)/libclips.so.$(CLIPS_VERSION)	       \
	 	$(SHARED_LIBRARY_DIR)/libclips.so
	ldconfig -n -v $(SHARED_LIBRARY_DIR)

install: clipspy install-clips
	$(PYTHON) setup.py install

clean:
	-rm clips.zip
	-rm -fr clips_source build dist clipspy.egg-info
