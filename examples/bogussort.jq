#!/usr/local/bin/jq -cnRrf

include "fadado.github.io/prelude";
import "fadado.github.io/generator/choice" as choice;

def issorted:
    def _issorted($xs; $len):
        def r:
            . >= $len
            or $xs[.] >= $xs[.-1]
               and (.+1|r)
        ;
        1|r
    ;
    _issorted(.; length)
;

def bogussort:
    choice::shuffle
    | try (
        choice::permutation | keep(issorted) | fence
    ) catch fenced
#   | once(
#       choice::permutation
#       | keep(issorted)
#   )
;

def main:
    [range(8)] | bogussort
;

main

# vim:ai:sw=4:ts=4:et:syntax=jq
