GOBS = numbers.gob objects.gob rabbit.gob font.gob
DATAFILES = \
	bump.mod calib.dat death.smp fly.smp jump.mod \
	jump.smp levelmap.txt level.pcx mask.pcx menu.pcx \
	menumask.pcx scores.mod splash.smp spring.smp
GOBDATAFILES= \
	numbers.pcx numbers.txt objects.pcx objects.txt \
	rabbit.pcx rabbit.txt font.pcx font.txt

CLEANFILES = $(GOBS) jumpbump.dat

nodist_pkgdata_DATA = jumpbump.dat

%.gob: ../modify/gobpack
	[ "$(srcdir)" = . ] || ln -s $(filter-out %.gob,$(wildcard $(srcdir)/$(basename $@).*)) ./
	../modify/gobpack $(basename $@)

font.gob: $(filter-out %.gob,$(wildcard $(srcdir)/font.*))
rabbit.gob: $(filter-out %.gob,$(wildcard $(srcdir)/rabbit.*))
numbers.gob: $(filter-out %.gob,$(wildcard $(srcdir)/numbers.*))
objects.gob: $(filter-out %.gob,$(wildcard $(srcdir)/objects.*))

jumpbump.dat: $(DATAFILES) $(GOBS) ../modify/jnbpack
	[ "$(srcdir)" = . ] || for f in $(DATAFILES) ; do ln -s "$(srcdir)/$$f" ./ ; done
	../modify/jnbpack -o jumpbump.dat $(DATAFILES) $(GOBS)

../modify/jnbpack:
	$(MAKE) -C ../modify jnbpack

EXTRA_DIST = \
	$(DATAFILES) \
	$(GOBDATAFILES) \
	pack.bat

#pkgdatadir = @datadir@/@PACKAGE@
