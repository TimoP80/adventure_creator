# adventure_creator

Simple text based adventure game engine

This is a game engine project inspired by finnish text adventures coded in QBasic or Turbo Pascal.
The system is based on nodes, the engine displays a text describing the current scene and gives you a few choices
to advance in the game. Some choices lead to premature ending of the game, but some choices advance the game further until
you reach a point where the game ends.

An example game is provided to show you what this engine is capable of.

Everything is coded in Object Pascal so knowledge of that language is required if you wish to contribute to this project.

This project contains three executables: 



acengine.exe for running the game files (.agf)

accompiler.exe for compiling xml files to agf

AdventureCreatorIDE.exe for editing game files and saving them to xml format

The source code is compilable with Delphi 10 Seattle and above. Compiled binaries are provided and they are
updated regularly. There is also an installer for the binary bundle in the IS-Installer folder.

This repository is the full online mirror of my local development folder. The first release will be added when I feel the engine and editor are stable enough.

For compiling the IDE, the following components are needed:

- JVCL
- JCL
- SynEdit (for syntax highlighting)

WARNING! This project is not fully documented yet, documentation is a work in progress as the engine is 
being developed to its full form.
