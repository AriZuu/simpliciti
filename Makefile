#
# Copyright (c) 2012-2013, Ari Suutari <ari@stonepile.fi>.
# All rights reserved. 
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 
#  1. Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#  2. Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#  3. The name of the author may not be used to endorse or promote
#     products derived from this software without specific prior written
#     permission. 
# 
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS
# OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
# INDIRECT,  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.

#
# Compile SimpliciTI library using Pico]OS library Makefile
#

SIMPLICITI_VER=1.1.1
PORT ?= msp430
BUILD ?= RELEASE
MCU ?= cc430f5137

RELROOT = ../picoos/
TEXAS_CONF ?=../msptest/texas

SIMPLICITI_DEFINES ?= NUM_CONNECTIONS=1 \
	SIZE_INFRAME_Q=1 \
	SIZE_OUTFRAME_Q=1 \
	THIS_DEVICE_ADDRESS="{{0x78,0x56,0x34,0x12}}" \
	ACCESS_POINT \
	AP_IS_DATA_HUB \
	NUM_STORE_AND_FWD_CLIENTS=2 \
	STARTUP_JOINCONTEXT_ON \
	MAX_HOPS=2 \
	MAX_HOPS_FROM_AP=1 \
	MAX_NWK_PAYLOAD=9 \
	MAX_APP_PAYLOAD=10 \
	DEFAULT_LINK_TOKEN=0x01020304 \
	DEFAULT_JOIN_TOKEN=0x05060708 \
	FREQUENCY_AGILITY \
	APP_AUTO_ACK \
	SW_TIMER \
	MRFI_CC2500 \
	SMPL_SECURE 

EXTRA_CFLAGS =  -Wno-parentheses \
		-Wno-missing-field-initializers \
		-Wno-cast-align \
		-Wno-missing-braces \
		-Wno-shadow

include $(RELROOT)make/common.mak

TARGET = simpliciti
SRC_TXT =	mrfi/mrfi.c \
		simpliciti/nwk_applications/nwk_freq.c \
		simpliciti/nwk_applications/nwk_ping.c \
		simpliciti/nwk_applications/nwk_ioctl.c \
		simpliciti/nwk_applications/nwk_join.c \
		simpliciti/nwk_applications/nwk_link.c \
		simpliciti/nwk_applications/nwk_mgmt.c \
		simpliciti/nwk_applications/nwk_security.c  \
		simpliciti/nwk/nwk.c \
		simpliciti/nwk/nwk_QMgmt.c \
		simpliciti/nwk/nwk_api.c \
		simpliciti/nwk/nwk_frame.c \
		simpliciti/nwk/nwk_globals.c

SRC_HDR = 
SRC_OBJ =
CDEFINES += $(SIMPLICITI_DEFINES)

MODULES = ../picoos-micro
DIR_USRINC += $(TEXAS_CONF)  \
		bsp/ \
		mrfi/ \
		simpliciti/nwk/ \
		simpliciti/nwk_applications/ \
		../msptest

ifeq '$(strip $(DIR_OUTPUT))' ''
DIR_OUTPUT = $(CURRENTDIR)/bin
endif

include $(MAKE_LIB)

#
# Extra stuff to build distribution zip.
#
dist:
	git diff Simpliciti_$(SIMPLICITI_VER) bsp mrfi simpliciti  > simpliciti_$(SIMPLICITI_VER).diff
	rm -f ../dist/simpliciti-`date +%Y%m%d`.zip
	cd ..; zip -qr dist/simpliciti-`date +%Y%m%d`.zip simpliciti -i simpliciti/Makefile simpliciti/simpliciti_$(SIMPLICITI_VER).diff
	rm -f simpliciti_$(SIMPLICITI_VER).diff
