NAME = container-exception-logger
SPEC = $(NAME).spec
VERSION = `rpmspec -P $(SPEC) | grep "^Version:" | tr -s " " | cut -f2- -d " "`
RELEASE = `rpmspec -P $(SPEC) | grep "^Release:" | tr -s " " | cut -f2- -d " "`
NVR = $(NAME)-$(VERSION)-$(RELEASE)

CC = gcc
CFLAGS = -g -O2 -Wall

SOURCE_DIR=src
SOURCE_FILES= \
	$(NAME).c

DIST_FILES= \
	$(SOURCE_DIR)/$(NAME).c \
	Makefile

all:
	$(CC) $(CFLAGS) $(SOURCE_DIR)/$(SOURCE_FILES) -o $(SOURCE_DIR)/$(NAME)
	a2x -d manpage -f manpage man/container-exception-logger.1.asciidoc

dist:
	tar -czvf $(NAME)-$(VERSION).tar.gz $(DIST_FILES)
