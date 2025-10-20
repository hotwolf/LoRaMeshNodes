###############################################################################
# LoRaMeshNodes - Makefile                                                    #
###############################################################################
#    Copyright 2025 Dirk Heisswolf                                            #
#    This file is part of the LoRaMeshNodes project.                          #
#                                                                             #
#    This project is free software: you can redistribute it and/or modify     #
#    it under the terms of the GNU General Public License as published by     #
#    the Free Software Foundation, either version 3 of the License, or        #
#    (at your option) any later version.                                      #
#                                                                             #
#    This project is distributed in the hope that it will be useful,          #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of           #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            #
#    GNU General Public License for more details.                             #
#                                                                             #
#    You should have received a copy of the GNU General Public License        #
#    along with this project.  If not, see <http://www.gnu.org/licenses/>.    #
#                                                                             #
#    This project makes use of the NopSCADlib library                         #
#    (see https://github.com/nophead/NopSCADlib).                             #
#                                                                             #
###############################################################################
# Description:                                                                #
#    This is the project makefile to run all project related tasks.           #
#     A description of all supported rules is given in the help text.         #
#                                                                             #
###############################################################################
# Version History:                                                            #
#   July 18, 2025                                                             #
#      - Initial release                                                      #
#                                                                             #
###############################################################################

#Directories
REPO_DIR       := .
#REPO_DIR      := $(CURDIR)
SCAD_DIR       := $(REPO_DIR)/scad
LIB_DIR        := $(REPO_DIR)/lib
NOPSCADLIB_DIR := $(REPO_DIR)/lib/NopSCADlib

OPENSCADPATH   := $(abspath $(LIB_DIR)):.
export OPENSCADPATH

#Tools	      
ifndef EDITOR 
EDITOR        := $(shell which emacs || which xemacs || which nano || which vi)
endif	      
PYTHON        := python3

.SECONDEXPANSION:

#############
# Help text #
#############
help:
	$(info This makefile supports the following targets:)
	$(info )
	$(info all:            Render all designs)
	$(info SSNvA:          Render all Static Solar Node variant A)
	$(info MSNvA:          Render all Mobile Solar Node variant A)
	$(info )
	$(info update:         Update libraries)
	@echo "" > /dev/null

#######################
# Render node designs #
#######################
all:	SSNvA MSNvA MSNvB

SSNvA:	FORCE
	env | grep PATH
	$(PYTHON) $(NOPSCADLIB_DIR)/scripts/make_all.py SSNvA
MSNvA:  FORCE
	env | grep PATH
	$(PYTHON) $(NOPSCADLIB_DIR)/scripts/make_all.py MSNvA
MSNvB:  FORCE
	env | grep PATH
	$(PYTHON) $(NOPSCADLIB_DIR)/scripts/make_all.py MSNvB

FORCE:

####################
# Update libraries #
####################
update:
	git pull -s subtree NopSCADlib master

