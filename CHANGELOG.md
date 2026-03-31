# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.93] - 2026-03-31

### Added
- New modular parser architecture:
  - ScriptLexer.pas - Clean lexical analyzer
  - ScriptParser.pas - Recursive descent parser with bytecode generation
  - ScriptAST.pas - Abstract Syntax Tree definitions
  - ScriptParserTests.pas - Unit tests
- Backward compatibility wrapper in AdventureScript.pas
- ResetGameState and ResetAllVariables procedures in AdventureBinaryRuntime.pas

### Fixed
- AddVariable now initializes variables to empty string instead of Null
- GetVariableValue now returns empty string for uninitialized/missing variables
- SetVariableValue now auto-creates variables if not found
- GetVarValue and SetVarValue now handle missing variables gracefully
- EmitParam now properly adds parameters to bytecode
- ParseVariableDeclaration now emits AddVariable bytecode
- ParseParameter now properly stores parameter info
- SetSourceStream now handles nil stream gracefully
- ParseStatement now correctly distinguishes function calls from variable assignments
- Fixed duplicate keyword definitions in lexer

### Changed
- Refactored parser from CoCo/R generated code to custom implementation
- Updated version numbers (ELEKTROMANIA_VERSION: 0.92 -> 0.93)
- Improved error reporting with line/column information

## [0.92] - Previous Versions

See git history for earlier changelog entries.
