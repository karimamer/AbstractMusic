\begin{code}
{-#
\end{code}

# Guillaume Costeley's 19-tone keyboard

One of the few pieces composed specifically for a keyboard with 19
keys (it is keyboard music, despite being an arrangement of one of his
own Chansons, and my [ropey Lilypond output](lily.html) which spreads it onto
4+ staves).

There is a synthesised performance in [19-equal
temperament](tet19.ogg) -- TET-19 allows for a distinction to be made
between sharp and flat notes that would be enharmonically equivalent
in TET-12.

On a normal [12-equal temperament](tet12.ogg) keyboard, it would sound
like [this](tet12.ogg), but note that a fair bit of the writing
assumes that accidentals borrowed from other keys are tuned in such a
way to make chords sound right in TET-19. No distinction between
enharmonic accidentals is possible.

In [TET-7](tet7.ogg) (which really exists) it would sound like this
[this](tet7.ogg) -- accidentals cannot be represented at all in this
tuning system.

[TET-31](tet31.ogg) would allow for some number of double-sharps/flats
(of which there aren't any in this piece, obviously), but the other
changes to the sound are interesting too.

Note: the input syntax below is Lilypond-esque, but all the pitches
are absolute.

----------------

\begin{code}
#-}
\end{code}


\begin{code}
{-# LANGUAGE PostfixOperators,
             FlexibleContexts #-}

module Costeley where

import Music (mapPhraseSingle, apPitch, apDur, apTran, apInt,
              explodeVoices, splitVoices, mapMusic, Metronome(..),
              AbstractNote(..), Music(..), mapPhrase, noteToSound, Tuning(..),
              revVoices)

import Shortcuts
import Output
import qualified Data.Music.Lilypond as L
import Lilypond
import Tuning
import Analysis

import FiveLimit (JustTuning(..), ForceJustTuning(..))


\end{code}
\begin{code}
downNoctaves n = mapPhraseSingle (apTran ((-n) *^ octave))

v4 = downNoctaves 2 $ phrase $
  [Directive $ L.Clef L.Bass,
   note (a∧) s,
   note (a∧) s,
   note d s,
   note (bes∧) (dotted s),
   note (a∧) m,
   co v3,
   note g s,
   rest m,
   note g m,
   note (bes∧) m,
   note (bes∧) m,
   note (c∧) m,
   note (c∧) m,
   note g s,
   rest m,
   note c m,
   note g m,
   note g m,
   note (aes∧) (dotted m),
   note g cr,
   note f m,
   note f m,
   note c s,
   rest s,
   rest br,
   rest s,
   rest m,
   note f m,
   note f s,
   note bes s,
   note ges (dotted s),
   note f m,
   note ees s,
   rest m,
   note bes m,
   note ges m,
   note ges m,
   note (aes∧) m,
   note (aes∧) m,
   note ees s,
   rest m,
   note aes m,
   note ees m,
   note ees m,
   note fes (dotted m),
   note ees cr,
   note des m,
   note des m,
   note aes s,
   rest m,
   note des m,
   note fes (dotted s),
   note ces m,
   note des m,
   note ais m,
   note ces s,
   note fes (dotted s),
   note fes m,
   note fes m,
   note fes m,
   note ges m,
   note dis m,
   note fes s]

v3 = downNoctaves 1 $ phrase $
  [Directive $ L.Clef L.Alto,
   note d s,
   note d s,
   note (g∨) s,
   note ees (dotted s),
   note d m,
   co v2,
   note c (dotted s),
   note b m,
   note ees m,
   note ees m,
   note f m,
   note f s,
   note e m,
   note f m,
   note (f∨) m,
   note c m,
   note c m,
   note des (dotted m),
   note c cr,
   note bes m,
   note bes m,
   note (f∨) s,
   rest m,
   note c m,
   note des (dotted m),
   note c cr,
   note bes m,
   note bes s,
   note a m,
   note bes s,
   note bes s,
   note (ees∨) s,
   note ces s,
   note bes s,
   note aes s,
   rest m,
   note (g∨) m,
   note ces m,
   note ces m,
   note des m,
   note des m,
   note c m,
   note c m,
   note des s,
   note ces s,
   note fes m,
   note ees m,
   note des s,
   note ces s,
   note aes s,
   rest m,
   note aes m,
   note aes m,
   note aes m,
   note ais m,
   note ais m,
   note aes s]
   
v2 = downNoctaves 1 $ phrase $
  [Directive $ L.Clef L.Alto,
   note g s,
   note g s,
   note c s,
   note (aes∧) (dotted s),
   note g m,
   co v1,
   note f s,
   rest m,
   note e m,
   note (aes∧) m,
   note (aes∧) m,
   note (bes∧) m,
   note (bes∧) s,
   note (a∧) cr,
   note g cr,
   note (a∧) cr,
   note g cr,
   note f cr,
   note ees cr,
   note f s,
   note des s,
   rest m,
   note f m,
   note ges m,
   note ges m,
   note f m,
   note f m,
   note ees (dotted br),
   note ees s,
   note ees s,
   note aes s,
   note fes s,
   note ees s,
   note des m,
   note fes m,
   note fes cr,
   note ees cr,
   note fes cr,
   note ges cr,
   note aes m,
   note ges (dotted m),
   note fes cr,
   note fes s,
   note ees m,
   note fes m,
   note ces m,
   note ces m,
   note ces m,
   note des (dotted s),
   note dis m,
   note ces s]

v1 = phrase $
  [Directive $ L.Clef L.Treble,
   note c s,
   note c s,
   note (f∨) s,
   note des (dotted s),
   note c cr,
   note bes cr,
   note c s,
   note bes s,
   rest m,
   note bes m,
   note des m,
   note des m,
   note ees m,
   note ees m,
   note d s,
   rest m,
   note bes m,
   note aes s,
   note (g∨) m,
   note (g∨) m,
   note ces m,
   note ces m,
   note bes m,
   note bes m,
   note aes br,
   rest m,
   note aes m,
   note aes (dotted s),
   note aes m,
   note ces (dotted m),
   note bes cr,
   note aes m,
   note ais m,
   note (ges∨) s,
   note (fes∨) (dotted br),
   rest s,
   co v1a]

v1a = phrase $
  [Directive $ L.Clef L.Treble,
   rest m,
   note (fes∨) m,
   note (fes∨) m,
   co v2a,
   co v3a,
   co v4a,
   note (fes∨) m,
   note aes s,
   note ais s,
   note (ges∨) m,
   note (ges∨) m,
   note (gis∨) (dotted m),
   note ais cr,
   note bis s,
   note ais s,
   note aes m,
   note aes m,
   note ais m,
   note ais s,
   note (gis∨) m,
   note (fis∨) s,
   note (eis∨) s,
   note (eis∨) s,
   note (gis∨) (dotted m),
   note (gis∨) cr,
   note (fis∨) m,
   note ais m,
   note (gis∨) s,
   rest (dotted s),
   note (gis∨) (dotted m),
   note (gis∨) cr,
   note (fis∨) m,
   note (eis∨) m,
   note (eis∨) m,
   note (dis∨) s,
   rest br,
   rest m,
   note (gis∨) m,
   note cis s,
   note bis s,
   rest (dotted s),
   note (gis∨) m,
   note b s,
   note ais br,
   rest m,
   note (gis∨) m,
   note cis s,
   note (fis∨) m,
   note b s,
   note ais m,
   note (gis∨) s,
   note (gis∨) s,
   note (gis∨) s,
   note (gis∨) m,
   note ais m,
   note b s,
   note ais s,
   note (gis∨) s,
   rest (dotted s),
   note (gis∨) m,
   note bis (dotted m),
   note cis cr,
   note dis m,
   note dis m,
   note (gis∨) long,
   rest m,
   note cis m,
   note cis m,
   note bis m,
   note cis m,
   note cis m,
   note ais s,
   note (gis∨) m,
   rest br,
   note cis m,
   note cis m,
   note bis m,
   note cis (dotted s),
   note cis m,
   note bis m,
   note ais cr,
   note aes cr,
   note ais s,
   note aes br,
   co v1b]


v2a = downNoctaves 1 $ phrase $
  [Directive $ L.Clef L.Alto,
   note ces m,
   note fes (dotted m),
   note fes cr,
   note fes m,
   note ges m,
   note dis s,
   rest m,
   note dis m,
   note gis m,
   note gis m,
   note eis m,
   note eis m,
   note eis s,
   rest m,
   note eis m,
   note eis m,
   note eis m,
   note cis m,
   note cis m,
   note cis s,
   rest m,
   note cis m,
   note eis (dotted m),
   note eis cr,
   note dis m,
   note fis m,
   note eis (dotted m),
   note dis q,
   note cis q,
   note dis m,
   note dis (dotted m),
   note dis cr,
   note cis m,
   note bis m,
   note ais m,
   note (gis∨) s,
   rest (dotted s),
   note cis m,
   note fis s,
   note eis s,
   rest m,
   note cis m,
   note gis s,
   note eis (dotted m),
   note dis q,
   note cis q,
   note dis s,
   rest m,
   note dis m,
   note fis s,
   note cis m,
   note cis m,
   note eis br,
   note dis m,
   note fis s,
   note fis m,
   note dis s,
   note eis br,
   note eis s,
   note dis m,
   note eis m,
   note fis s,
   note eis br,
   note dis s,
   rest m,
   note eis m,
   note fis s,
   note eis s,
   note eis s,
   note dis s,
   note cis m,
   note eis m,
   note eis m,
   note cis m,
   note dis m,
   note dis m,
   note eis cr,
   note dis cr,
   note cis cr,
   note bis cr,
   note cis m,
   rest s,
   note fis m,
   note fis m,
   note fis m,
   note eis (dotted m),
   note fis cr,
   note dis s,
   note cis m,
   note gis m,
   note gis m,
   note gis m,
   note fis m,
   note eis s,
   note dis m,
   note eis br]


   
v3a = downNoctaves 1 $ phrase $
  [Directive $ L.Clef L.Alto,
   note aes m,
   note ces (dotted m),
   note ces cr,
   note des m,
   note dis m,
   note ais m,
   note ais m,
   note bis (dotted m),
   note cis cr,
   note dis s,
   note cis s,
   note bis m,
   note bis m,
   note cis m,
   note cis s,
   note bis m,
   note ais s,
   note (gis∨) br,
   rest m,
   note (gis∨) m,
   note b m,
   note (fis∨) m,
   note cis m,
   note cis s,
   note bis cr,
   note ais cr,
   note bis m,
   rest br,
   note cis (dotted m),
   note cis cr,
   note bis m,
   note ais cr,
   note (gis∨) cr,
   note (gis∨) s,
   note (fis∨) m,
   note (gis∨) br,
   rest m,
   note (gis∨) m,
   note cis s,
   note bis s,
   rest br,
   rest m,
   note ais m,
   note cis s,
   note (gis∨) m,
   note (gis∨) m,
   note b (dotted m),
   note cis cr,
   note dis m,
   note cis s,
   note bis m,
   note cis br,
   rest s,
   note (gis∨) s,
   note ais m,
   note bis m,
   note cis s,
   note cis s,
   note bis s,
   note (gis∨) s,
   note ais (dotted m),
   note bis cr,
   note cis m,
   note cis m,
   note (gis∨) m,
   note cis m,
   note cis m,
   note bis m,
   note cis m,
   note cis m,
   note ais s,
   note (gis∨) s,
   rest (dotted s),
   note cis m,
   note cis m,
   note ais m,
   note ais m,
   note (fis∨) m,
   note (gis∨) s,
   note (gis∨) s,
   rest m,
   note eis m,
   note eis m,
   note eis m,
   note dis m,
   note cis m,
   note ais s,
   note bis br]



   
v4a = downNoctaves 2 $ phrase $
  [Directive $ L.Clef L.Bass,
   note fes m,
   note fes m,
   note fes m,
   note (ais∧) m,
   note dis m,
   note dis m,
   note dis m,
   rest m,
   note gis m,
   note gis m,
   note gis m,
   note (ais∧) m,
   note (ais∧) m,
   note eis s,
   rest m,
   note ais m,
   note eis m,
   note eis m,
   note fis m,
   note fis m,
   note cis (dotted br),
   rest (dotted s),
   note cis m,
   note gis (dotted m),
   note fis cr,
   note gis m,
   note eis m,
   note dis s,
   rest s,
   note gis (dotted m),
   note gis cr,
   note fis m,
   note eis m,
   note dis s,
   note cis br,
   rest (dotted s),
   note cis m,
   note gis s,
   note gis (dotted m),
   note fis q,
   note eis q,
   note dis m,
   note dis m,
   note fis s,
   note cis br,
   rest m,
   note b s,
   note fis m,
   note gis s,
   note cis (dotted br),
   rest br,
   note cis s,
   note eis m,
   note fis m,
   note gis s,
   note eis s,
   note dis s,
   rest m,
   note cis m,
   note eis (dotted m),
   note fis cr,
   note gis m,
   note gis m,
   note cis s,
   rest br,
   rest m,
   note fis m,
   note fis m,
   note fis m,
   note eis m,
   note fis m,
   note dis s,
   note cis s,
   rest (dotted s),
   note cis m,
   note cis m,
   note cis m,
   note dis m,
   note eis m,
   note fis s,
   note eis br]


v1b = phrase $
  [Directive $ L.Clef L.Treble,
   note ces br,
   note (fes∨) s,
   note ces s,
   note cis m,
   co v2b,
   note ais s,
   note aes cr,
   note (ges∨) cr,
   note aes s,
   note ais m,
   note cis s,
   note bis m,
   note ais cr,
   note (gis∨) cr,
   note (fis∨) m,
   note (eis∨) s,
   rest m,
   note ais m,
   note ais s,
   note ais s,
   note (fis∨) m,
   note (gis∨) m,
   note ais br,
   rest m,
   note (gis∨) m,
   note (fis∨) m,
   note ais m,
   note b s,
   note (gis∨) s,
   note (ges∨) br,
   note (fis∨) br,
   rest br,
   note (dis∨) s,
   note (gis∨) s,
   note (ges∨) m,
   note b s,
   note ais m,
   note (gis∨) s,
   note (fis∨) s,
   rest m,
   note (gis∨) m,
   note ais s,
   note ais (dotted s),
   note b m,
   note (gis∨) s,
   note (fis∨) m,
   note (fis∨) m,
   note (fis∨) m,
   note (fis∨) m,
   note (gis∨) m,
   note b s,
   note ais cr,
   note (gis∨) cr,
   note ais s,
   note (fis∨) s,
   note b s,
   note (gis∨) s,
   note (fis∨) br,
   note (fis∨) s,
   note (fis∨) m,
   note (gis∨) m,
   note a (dotted s),
   note b m,
   note cis br,
   note (gis∨) s,
   note cis m,
   note cis m,
   note a m,
   note a m,
   note d s,
   note cis s,
   rest s,
   note cis s,
   note cis m,
   note cis m,
   note cis (dotted m),
   note b cr,
   note a m,
   note a m,
   note b s,
   note (gis∨) s,
   rest m,
   note (gis∨) m,
   note a m,
   note a m,
   note (fis∨) m,
   note b m,
   note (gis∨) s,
   rest m,
   note a m,
   note (gis∨) s,
   note (gis∨) s,
   note (fis∨) (dotted m),
   note (e∨) cr,
   note (dis∨) s,
   rest m,
   note (gis∨) s,
   note (gis∨) m,
   note cis s,
   note cis (dotted m),
   note b cr,
   note a s,
   note (gis∨) m,
   note (gis∨) s,
   note (gis∨) m,
   note cis s,
   note ces br,
   rest m,
   note cis s,
   note a s,
   note a m,
   note b m,
   note cis s,
   note b s,
   note ais cr,
   note (gis∨) cr,
   note ais s,
   co v1c]

v2b = downNoctaves 1 $ phrase $
  [Directive $ L.Clef L.Alto,
   rest m,
   note eis br,
   note ais s,
   note eis s,
   note fis m,
   co v3b,
   note dis s,
   note des cr,
   note ces cr,
   note des s,
   note dis m,
   note fis s,
   note eis m,
   note dis m,
   note b m,
   note ais s,
   rest m,
   note cis m,
   note b m,
   note dis s,
   note cis m,
   note b cr,
   note ais cr,
   note dis s,
   note cis m,
   note dis s,
   note ais s,
   note b s,
   note ais m,
   note bis (dotted m),
   note cis m,
   note b q,
   note ais q,
   note b s,
   note ais s,
   rest m,
   note (gis∨) m,
   note dis s,
   note dis (dotted s),
   note dis (dotted m),
   note cis cr,
   note cis s,
   note bis m,
   note cis s,
   rest m,
   note cis m,
   note dis s,
   note dis m,
   note e m,
   note cis s,
   note b m,
   note dis m,
   note dis m,
   note e m,
   note fis m,
   note dis m,
   note cis br,
   rest m,
   note b m,
   note e s,
   note dis s,
   note cis br,
   rest s,
   note cis s,
   note cis m,
   note dis m,
   note e s,
   note eis m,
   note fis s,
   note eis m,
   note fis (dotted br),
   rest m,
   note cis m,
   note fis m,
   note fis m,
   note e m,
   note e m,
   note (a∧) s,
   note gis m,
   note a s,
   note fis m,
   note fis m,
   note gis s,
   note fis s,
   note eis m,
   note fis s,
   rest m,
   note dis m,
   note eis m,
   note eis m,
   note fis m,
   note fis m,
   note cis s,
   rest m,
   note e m,
   note dis m,
   note cis s,
   note bis cr,
   note ais cr,
   note bis m,
   note bis m,
   note cis m,
   note cis s,
   note cis m,
   note fis (dotted s),
   note fis s,
   note eis cr,
   note dis cr,
   note eis s,
   note cis s,
   note dis s,
   rest m,
   note gis s,
   note e s,
   note cis s,
   note fis cr,
   note e cr,
   note dis cr,
   note cis cr,
   note e m,
   note d s,
   note cis br]

v3b = downNoctaves 2 $ phrase $
  [Directive $ L.Clef L.Bass,
   rest m,
   note (ais∧) br,
   note dis s,
   note (ais∧) s,
   note (b∧) m,
   note gis s,
   note ges cr,
   note fes cr,
   note ges s,
   note gis m,
   note (b∧) s,
   note (ais∧) m,
   note gis s,
   note e s,
   note dis (dotted br),
   note dis s,
   note e s,
   note dis m,
   note gis s,
   note fis m,
   note e s,
   note dis m,
   note gis s,
   note fis m,
   note (b∧) (dotted s),
   note (ais∧) m,
   note gis s,
   note fis br,
   rest m,
   note gis m,
   note gis s,
   note (ais∧) s,
   note (b∧) s,
   note gis s,
   note fis (dotted br),
   note e s,
   note e s,
   note (b∧) s,
   note fis br,
   note fis s,
   note fis m,
   note gis m,
   note (a∧) (dotted s),
   note (b∧) m,
   note (cis∧) br,
   rest s,
   note fis s,
   note (b∧) m,
   note (b∧) m,
   note (a∧) m,
   note (a∧) m,
   note (d∧) s,
   note (cis∧) s,
   rest m,
   note fis m,
   note (cis∧) m,
   note (cis∧) m,
   note (d∧) s,
   note (b∧) s,
   note (cis∧) s,
   note (cis∧) s,
   rest m,
   note fis m,
   note (b∧) m,
   note (b∧) m,
   note (cis∧) m,
   note (cis∧) m,
   note fis s,
   rest s,
   note e s,
   note fis m,
   note fis m,
   note gis s,
   note gis s,
   note cis br,
   rest m,
   note fis s,
   note fis m,
   note (cis∧) s,
   note (cis∧) (dotted m),
   note (b∧) cr,
   note (a∧) s,
   note gis br,
   note (cis∧) s,
   note (a∧) s,
   note fis s,
   note (b∧) m,
   note (a∧) m,
   note (b∧) s,
   note fis br]


v1c = phrase $
  [Directive $ L.Clef L.Treble,
   co v2c,
   co v3c,
   co v4c,
   note a s,
   note (gis∨) s,
   note b s,
   note b m,
   note a m,
   note (gis∨) br,
   note cis s,
   note cis m,
   note b m,
   note a m,
   note a m,
   note (gis∨) s,
   rest m,
   note a m,
   note b (dotted m),
   note b cr,
   note b m,
   note a m,
   note (gis∨) s,
   rest m,
   note cis m,
   note cis m,
   note b m,
   note a m,
   note a m,
   note (gis∨) m,
   note (gis∨) m,
   note cis (dotted m),
   note b cr,
   note ais m,
   note (gis∨) m,
   note (fis∨) cr,
   note (eis∨) cr,
   note (fis∨) cr,
   note (gis∨) cr,
   note ais s,
   rest m,
   note (gis∨) m,
   note cis (dotted m),
   note b cr,
   note ais m,
   note (fis∨) m,
   note ais m,
   note b m,
   note cis s,
   rest m,
   note (fis∨) m,
   note b m,
   note b m,
   note ais m,
   note (gis∨) m,
   note (fis∨) s,
   note (eis∨) m,
   note (eis∨) m,
   note ais s,
   rest m,
   note (gis∨) m,
   note b (dotted m),
   note ais q,
   note (gis∨) q,
   note (fis∨) m,
   note ais m,
   note (gis∨) cr,
   note (fis∨) cr,
   note (fis∨) cr,
   note (eis∨) q,
   note (dis∨) q,
   note (eis∨) s,
   note (dis∨) m,
   rest cr,
   note ais m,
   note (eis∨) m,
   note (gis∨) m,
   note (dis∨) (dotted cr),
   note (eis∨) q,
   note (fis∨) (dotted cr),
   note (gis∨) q,
   note ais m,
   note b (dotted cr),
   note ais q,
   note (gis∨) q,
   note (ges∨) q,
   note (gis∨) m,
   note (ges∨) m,
   note b m,
   note ais m,
   note (gis∨) m,
   note (ges∨) m,
   note (gis∨) s,
   note (ges∨) m,
   note (gis∨) m,
   rest cr,
   note ais m,
   note (eis∨) m,
   note (gis∨) m,
   note (dis∨) (dotted cr),
   note (eis∨) q,
   note (fis∨) (dotted cr),
   note (gis∨) q,
   note ais m,
   note b (dotted cr),
   note ais q,
   note (gis∨) q,
   note (ges∨) q,
   note (gis∨) m,
   note (ges∨) m,
   note b m,
   note ais m,
   note (gis∨) m,
   note (ges∨) m,
   note (gis∨) s,
   note (ges∨) m,
   note (gis∨) br]

v2c = downNoctaves 1 $ phrase $
  [Directive $ L.Clef L.Alto,
   note fis s,
   note eis s,
   note fis s,
   note gis m,
   note fis m,
   note eis br,
   note (a∧) s,
   note (a∧) m,
   note gis m,
   note fis m,
   note fis m,
   note eis s,
   rest m,
   note fis m,
   note gis (dotted m),
   note gis cr,
   note gis m,
   note fis m,
   note eis s,
   rest m,
   note (a∧) m,
   note (a∧) m,
   note gis m,
   note fis m,
   note fis m,
   note eis (dotted br),
   rest m,
   note cis m,
   note fis m,
   note fis m,
   note eis (dotted m),
   note dis cr,
   note cis (dotted s),
   note cis m,
   note fis (dotted m),
   note fis cr,
   note eis m,
   note eis m,
   note dis m,
   note dis m,
   note fis m,
   note fis m,
   note fis m,
   note eis m,
   note dis s,
   note des s,
   note eis s,
   note eis s,
   note dis s,
   note dis m,
   note fis m,
   note eis m,
   note dis s,
   note des m,
   note dis m,
   note fis m,
   note cis m,
   note cis m,
   note b m,
   note b m,
   note ais cr,
   note dis (dotted cr),
   note cis q,
   note b q,
   note ais q,
   note (gis∨) cr,
   note b m,
   note ais q,
   note (gis∨) q,
   note ais cr,
   note dis (dotted cr),
   note cis q,
   note b q,
   note cis q,
   note dis q,
   note eis q,
   note fis cr,
   note dis (dotted m),
   note dis cr,
   note b cr,
   note cis cr,
   note dis s,
   note dis m,
   note fis m,
   note cis m,
   note cis m,
   note b m,
   note b m,
   note ais cr,
   note dis (dotted cr),
   note cis q,
   note b q,
   note ais q,
   note (gis∨) cr,
   note b m,
   note ais q,
   note (gis∨) q,
   note ais cr,
   note dis (dotted cr),
   note cis q,
   note b q,
   note cis q,
   note dis q,
   note eis q,
   note fis cr,
   note dis (dotted m),
   note dis cr,
   note b cr,
   note cis cr,
   note dis s,
   note bis br]


v3c = downNoctaves 1 $ phrase $
  [Directive $ L.Clef L.Alto,
   note cis s,
   note cis s,
   note dis s,
   note e m,
   note cis m,
   note cis br,
   note e s,
   note e m,
   note e m,
   note cis m,
   note cis m,
   note cis s,
   rest m,
   note cis m,
   note e (dotted m),
   note e cr,
   note e m,
   note cis m,
   note cis s,
   rest m,
   note e m,
   note e m,
   note e m,
   note cis m,
   note cis m,
   note cis s,
   rest m,
   note (gis∨) m,
   note cis (dotted m),
   note b cr,
   note ais (dotted m),
   note (gis∨) cr,
   note (fis∨) m,
   note (fis∨) m,
   note cis (dotted m),
   note b cr,
   note ais m,
   note (gis∨) m,
   note (fis∨) cr,
   note (gis∨) cr,
   note ais s,
   note (gis∨) cr,
   note (fis∨) cr,
   note (gis∨) m,
   note ais m,
   note b s,
   note dis s,
   note cis m,
   note cis m,
   note ais s,
   note ais s,
   rest m,
   note ais m,
   note cis (dotted m),
   note b cr,
   note (gis∨) m,
   note (gis∨) m,
   note b m,
   note (fis∨) m,
   note (gis∨) m,
   note b m,
   note ais s,
   note (dis∨) m,
   rest m,
   note ais m,
   note (eis∨) m,
   note (gis∨) m,
   note (dis∨) (dotted cr),
   note (eis∨) q,
   note (fis∨) (dotted cr),
   note (gis∨) q,
   note ais cr,
   note (gis∨) q,
   note ais q,
   note b q,
   note cis q,
   note dis m,
   note cis cr,
   note dis m,
   rest cr,
   note dis m,
   note cis m,
   note b cr,
   note ais m,
   note gis m,
   note ais s,
   note (gis∨) cr,
   note b m,
   note ais cr,
   note ais m,
   note (eis∨) m,
   note (gis∨) m,
   note (dis∨) (dotted cr),
   note (eis∨) q,
   note (fis∨) (dotted cr),
   note (gis∨) q,
   note ais cr,
   note (gis∨) q,
   note ais q,
   note b q,
   note cis q,
   note dis m,
   note cis cr,
   note dis m,
   rest cr,
   note dis m,
   note cis m,
   note b cr,
   note ais m,
   note (gis∨) m,
   note ais s,
   note (gis∨) br]

v4c = downNoctaves 2 $ phrase $
  [Directive $ L.Clef L.Bass,
   note fis s,
   note cis s,
   note b s,
   note e m,
   note fis m,
   note cis br,
   note a s,
   note a m,
   note e m,
   note fis m,
   note fis m,
   note cis s,
   rest m,
   note fis m,
   note e (dotted m),
   note e cr,
   note e m,
   note fis m,
   note cis s,
   rest m,
   note a m,
   note a m,
   note e m,
   note fis m,
   note fis m,
   note cis br,
   rest m,
   note cis m,
   note fis (dotted m),
   note eis cr,
   note dis m,
   note dis m,
   note cis s,
   rest m,
   note cis m,
   note fis (dotted m),
   note eis cr,
   note dis m,
   note dis m,
   note cis s,
   note b s,
   note b m,
   note b m,
   note fis m,
   note cis m,
   note dis s,
   note ais br,
   rest s,
   rest br,
   rest br,
   rest m,
   note dis m,
   note ais m,
   note cis m,
   note (gis∨) (dotted cr),
   note ais q,
   note b (dotted cr),
   note cis q,
   note dis (dotted cr),
   note eis q,
   note fis cr,
   note gis (dotted cr),
   note fis q,
   note e q,
   note dis q,
   note e m,
   note dis m,
   note gis m,
   note fis m,
   note gis m,
   note dis m,
   note e m,
   note dis s,
   note (gis∨) m,
   note dis m,
   note ais m,
   note cis m,
   note (gis∨) (dotted cr),
   note ais q,
   note b (dotted cr),
   note cis q,
   note dis (dotted cr),
   note eis q,
   note fis cr,
   note gis (dotted cr),
   note fis q,
   note e q,
   note dis q,
   note e m,
   note dis m,
   note gis m,
   note fis m,
   note gis m,
   note dis m,
   note e m,
   note dis s,
   note (gis∨) br]










\end{code}


\begin{code}
-- tuning = TET12 (a, freq 440)
tuning = synTET19 (a, freq 440)
speed = Metronome 480

music = Start v4

-- Change the order in which the parts appear in the score (still not ideal)
voices = revVoices $ explodeVoices music

performance t = mapMusic (mapPhrase (noteToSound t speed)) voices

\end{code}

To hear sounds, make sure you have Csound installed, then execute
    the command: playCsounds (performance tuning)

To get Lilypond output, execute the command:
    writeLilypond "/tmp" $ lilypondFile voices






