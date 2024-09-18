TOPLEVEL_LANG ?= verilog
SIM ?= xcelium
PWD=$(shell pwd)

ifeq ($(TOPLEVEL_LANG), verilog)
    VERILOG_SOURCES = $(PWD)/design.sv
else ifeq ($(TOPLEVEL_LANG), vhdl)
    VHDL_SOURCES = $(PWD)/design.vhdl
else
    $(error A valid value (verilog or vhdl) was not provided for TOPLEVEL_LANG=$(TOPLEVEL_LANG))
endif

TOPLEVEL := ALU     # Module_NAME
MODULE   := test    # Python file name without .py extension

include $(shell cocotb-config --makefiles)/Makefile.sim
