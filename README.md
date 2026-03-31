# Adventure Creator

Simple text based adventure game engine

This is a game engine project inspired by finnish text adventures coded in QBasic or Turbo Pascal.
The system is based on nodes, the engine displays a text describing the current scene and gives you a few choices
to advance in the game. Some choices lead to premature ending of the game, but some choices advance the game further until
you reach a point where the game ends.

An example game is provided to show you what this engine is capable of.

Everything is coded in Object Pascal so knowledge of that language is required if you wish to contribute to this project.

## Executables

This project contains three executables:

- **acengine.exe** - Runtime engine for running compiled game files (.agf)
- **accompiler.exe** - Command-line compiler for converting XML files to .agf format
- **AdventureCreatorIDE.exe** - Full-featured IDE for creating and editing game files

## Requirements

The source code is compilable with Delphi 10 Seattle and above. Compiled binaries are provided and they are
updated regularly. There is also an installer for the binary bundle in the IS-Installer folder.

For compiling the IDE, the following components are needed:

- JVCL (Jedi Visual Component Library)
- JCL (Jedi Code Library)
- SynEdit (for syntax highlighting)

## Current Versions

- **Engine**: v0.92
- **Editor**: v0.97
- **Script Engine**: v0.15
- **Lines of Code**: ~22,979

## New Modular Parser Architecture (v0.93+)

Starting from version 0.93, the Adventure Scripting Language uses a new modular parser architecture:

- **ScriptLexer.pas** - Clean lexical analyzer with comprehensive token support
- **ScriptParser.pas** - Recursive descent parser with direct bytecode generation
- **ScriptAST.pas** - Abstract Syntax Tree node definitions
- **ScriptParserTests.pas** - Unit tests for the parser

The new parser provides:
- Better maintainability with clean separation of concerns
- Comprehensive error reporting with line/column information
- Unit tests for validation
- Backward compatibility with existing scripts through the AdventureScript wrapper

## Features

- Node-based story progression system
- Conditional choices and branching narratives
- Variable system for game state tracking
- Built-in scripting language for advanced game logic
- Save/Load game functionality
- Audio support for background music and sound effects
- Cross-platform compatible game files

## Warning

This project is not fully documented yet, documentation is a work in progress as the engine is 
being developed to its full form.

## License

This repository is the full online mirror of the local development folder. Releases are added when the engine and editor are stable enough.
