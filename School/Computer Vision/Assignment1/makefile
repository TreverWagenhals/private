# The name of the executable that this project is going to produce
PRODUCT := program1.exe

# Separate directories for .cpp, .h, compiler
# output files like .o amd .d, and where the executable is saved
INCDIR := inc
SRCDIR := src
OBJDIR := obj
BINDIR := bin

# Name of the C++ compiler
CXX := g++
# Point the compiler to the inc directory for all #include files
INCDIRS := -I$(INCDIR)
# Additional flags
CXXFLAGS := -std=c++11 -Wall -Wextra
# Additional libraries
LIBS :=

# Use the GNU make wildcard function to generate a list of .cpp files
# within the SRCDIR directory
SRCFILES := $(wildcard $(SRCDIR)/*.cpp) 
# Create object file names by removing the ".cpp" from all of the 
# SRCDIR files and changing it to ".o" within OBJDIR
OBJFILES := $(patsubst $(SRCDIR)/%.cpp,$(OBJDIR)/%.o,$(SRCFILES))
# Do the same thing for dependency files
DEPFILES := $(patsubst $(SRCDIR)/%.cpp,$(OBJDIR)/%.d,$(SRCFILES))

# Default
# Builds the executable from the list of object files by linking them.
$(BINDIR)/$(PRODUCT): $(OBJFILES)
	$(CXX) $(CXXFLAGS) $^ $(LIBS) -o $@

# Clean the project by removing .o files, and executable.
clean:
	rm -f $(OBJDIR)/*.o $(BINDIR)/$(PRODUCT)

# Remove any dependency files and rebuild them
depends:
	rm -f $(OBJDIR)/*.d
	$(MAKE) $(DEPFILES)

# Build a .o file in the OBJDIR directory from a .cpp file
# in the SRCDIR directory.
$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	$(CXX) $(CXXFLAGS) $(INCDIRS) -c $< -o $@

# How to build the .d dependency files. The -MM option says to generate
# these but not to create dependencies for things like <iostream>.
# We then use sed to change dependency lines like:
#    main.o: src/main.cpp inc/dice.h inc/report.h
# to lines like:
#    obj/main.d obj/main.o: src/main.cpp inc/dice.h inc/report.h
# Now use tr to remove backslashes and EOL characters when GCC 
# generates multi-line output.
$(OBJDIR)/%.d: $(SRCDIR)/%.cpp
	$(CXX) $(CXXFLAGS) $(INCDIRS) -MM $< \
	  | tr '\n\r\\' ' ' \
	  | sed -e 's%^%$@ %' -e 's% % $(OBJDIR)/%'\
	  > $@

# Include the generated dependencies. If the dependency files
# do not already exist, make will create them using the rule above.
-include $(DEPFILES)
