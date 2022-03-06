Tools v0.1
==========

A collection of tools created for simple automation tasks.
    -   iorl returns the names of ASCII characters

iorl
----

Usage: `irol <string_of_characters>`

-   This returns the names (or phonetic alphabet words) of the characters in the string


passgen
------

Usage: `passgen [args]`

The number of each category can be specified with:

- `-w (--words) <number_of_words>` default = 3
- `-s (--symbols) <number_of_symbols>` default = 3
- `-n (--numbers) <number_of_numbers>` default = 3
- `-c (--capitals) <number_of_capitals>` default = 0

wordgen
------

Usage: `wordgen` 

-   Simple script that takes in a number of valid english sounds and
    generates a plausible sounding word. 

TODO: add an option for variable word lengths, and selection of subtypes (e.g.
scientific, uses prefixes/suffixes, sound types ).
