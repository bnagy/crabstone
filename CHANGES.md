## 0.0.1
* Alpha release.

## 0.0.2
* Update tests, add syntax sugar

## 0.0.3
* Refactoring and cosmetics

## 0.0.4
* Verify MIPS support, tests, slight API changes

## 0.0.5
* API changes including cs_errno.

## 0.0.6
* Final set of API changes before public beta.

## 1.0.0
* Move to new github repo

## 2.0.0
* Add PPC support
* Assorted API changes
* disasm can now ONLY be used with a block ( hopefully fix later )
* THIS IS A BREAKING CHANGE

## 2.0.1
* Update X86 constants

## 2.1rc1
* Many constant changes
* disasm CAN now return an Array, with a slightly scary built-in finalizer

## 2.1.0
* Full compliance with 2.1 API
* Better error handling for diet mode
* Internally change cs_close() signature, so closed handles can't be used

## 2.2.0
* Add support for Sparc and SystemZ

## 3.0rc1
* Update for C side changes
* Add support for Xcore
* ARM, ARM64 and X86 passing, rest waiting for upstream

## 3.0rc3
* Generic groups ( CS_GRP_JUMP, CS_GRP_CALL etc)
* Mips 32R6 + MICRO
* Many constant changes
* PPC CRX operand
* X86: added prefixed symbols
* THIS IS A BREAKING CHANGE ( even from rc1 )

## 3.0
* See https://github.com/aquynh/capstone/wiki/ChangeLog-since-3.0-rc3
* Shouldn't be breaking, most changes are internal.

## 3.0.3-rc1
* Internal binding updates, updated some test specs.
