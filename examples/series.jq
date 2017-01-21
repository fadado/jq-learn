#!/usr/local/bin/jq -cnRrf

# Panintervalic dodecaphonic series
# https://en.wikipedia.org/wiki/Twelve-tone_technique
#
# Usage:
#   ./series.jq --argjson N n
#

# Generates all panintervalic dodecaphonic series
def series($n): #:: number -> <[number]>
    #:: [number]|([number];[number]) -> <[number]>
    def _series($notes; $intervals):
        # . is the serie beeing constructed
        if $notes == []
        then .
        elif length==0 then
            $notes[] as $note # choose any note
            | [$note]|_series($notes-[$note]; [])
        else
            ($notes-.)[] as $note # choose notes not used
            | [$note-.[-1]|length] as $i
            | if $intervals|contains($i) # interval is in use?
              then empty 
              else
                .[length]=$note | _series($notes-[$note]; $intervals+$i)
              end
        end
    ;
    #
    [] as $serie |
    $serie|_series([range($n)]; null)
;

series(12)

# vim:ai:sw=4:ts=4:et:syntax=jq