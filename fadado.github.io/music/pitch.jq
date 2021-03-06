module {
    name: "music/pitch",
    description: "Pitch functions",
    namespace: "fadado.github.io",
    author: {
        name: "Joan Josep Ordinas Rosa",
        email: "jordinas@gmail.com"
    }
};

include "fadado.github.io/prelude";
include "fadado.github.io/types";
import "fadado.github.io/string/regexp" as re;
import "fadado.github.io/math" as math;

########################################################################
# Names used in type declarations
#
# PITCH: 0..127; as string: (C0..G10), MIDI based octave count
# PI (pitch interval): -127..127 (has direction)
#
# Useful primitives:

# Produces a new pitch
def new: #:: <number^string> => PITCH
    if isnumber then
        if 0 <= . and . <= 127 # . is a pitch in the range 0..127
        then .
        else error("Pitch out of range: \(.)")
        end
    elif isstring then
        if test("^[A-G][♯♭]?(?:[0-9]|10)$") # . is a note name with octave
        then
            match("^(?<n>[A-G])(?<a>[♯♭])?(?<o>[0-9]|10)$")
            | re::tomap as $m
            | {"C":0,"D":2,"E":4,"F":5,"G":7,"A":9,"B":11}[$m["n"]] as $n
            | $m["o"]|tonumber * 12
            + if $m["a"]=="♯"
              then $n+1
              elif $m["a"]=="♭"
              then $n-1
              else $n
              end
        else
            error("Malformed pitch: \(.)")
        end
    else typerror("number or string")
    end
;
def new($x): #:: (<number^string>) => PITCH
    $x | new
;

# Produces the note name
def name($flats): #:: PITCH|(boolean) => string
    if $flats
    then ["C","D♭","D","E♭","E","F","G♭","G","A♭","A","B♭","B"][. % 12]
    else ["C","C♯","D","D♯","E","F","F♯","G","G♯","A","A♯","B"][. % 12]
    end
;
def name: #:: PITCH => string
    ["C","C♯","D","D♯","E","F","F♯","G","G♯","A","A♯","B"][. % 12]
;

# Produces the note octave
def octave: #:: PITCH => number
    math::div(.;12)
;

# Formats a pitch (C0..G10)
def format: #:: PITCH => string
    "\(name)\(octave)"
;

########################################################################

## Add a directed pitch interval to the pitch
def transpose($i): #:: PITCH|(PI) => PITCH
    . + $i
    | if false==(0 <= . and . <= 127)
      then error("Pitch out of range: \(.)") end
;

# Produces the pitch interval (-127..127) between two pitches
def interval($p): #:: PITCH|(PITCH) => PI
    $p - .
;

# vim:ai:sw=4:ts=4:et:syntax=jq
