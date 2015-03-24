all:

include Makefile.info

CC := gcc
AR := ar
ARFLAGS := cr
RANLIB := ranlib
RM := rm -f

VALID_MAKECMDGOALS := all $(TARGET) %.c.d %.c.o clean
NONEED_DEP_MAKECMDGOALS := clean

EXTRA_MAKECMDGOALS := $(filter-out $(VALID_MAKECMDGOALS), $(MAKECMDGOALS))
ifneq '$(EXTRA_MAKECMDGOALS)' ''
  $(error No rule to make target `$(firstword $(EXTRA_MAKECMDGOALS))')
else
  ifeq '$(filter-out $(NONEED_DEP_MAKECMDGOALS), $(MAKECMDGOALS))' '$(MAKECMDGOALS)'
    sinclude $(DEPS)
	else
    ifneq '$(words $(MAKECMDGOALS))' '1'
      $(error Specify only one target if you want to make target which needs no source code dependency)
    endif
  endif
endif

MAKEFILE_LIST_SANS_DEPS := $(filter-out %.c.d, $(MAKEFILE_LIST))

COMPILE.c = $(CC) $(CFLAGS) $(CFLAGS_LOCAL) $(EXTRACFLAGS) $(CPPFLAGS) $(CPPFLAGS_LOCAL) $(EXTRACPPFLAGS) $(TARGET_ARCH) -c
COMPILE.d = $(CC) $(CFLAGS) $(CFLAGS_LOCAL) $(EXTRACFLAGS) $(CPPFLAGS) $(CPPFLAGS_LOCAL) $(EXTRACPPFLAGS) $(TARGET_ARCH) -M -MP -MT $<.o -MF $@

all: $(TARGET)

$(TARGET): $(OBJS) $(ALLDEPS)
	$(AR) $(ARFLAGS) $@ $(OBJS)
	$(RANLIB) $@

%.c.o: %.c $(ALLDEPS)
	$(COMPILE.c) $(OUTPUT_OPTION) $<

%.c.d: %.c $(ALLDEPS)
	$(COMPILE.d) $<

.PHONY: clean
clean:
	$(RM) $(TARGET)
	$(RM) $(OBJS)
	$(RM) $(DEPS)