funktionsbeteende:
input -> execution -> output

interaktionsbeteende:
request -> response -> request -> ...

beteendeegenskaper är temporala i sin karaktär. Något

- är alltid sant
- blir sant så småningom
- är sant oändligt ofta
- är sant tills någonting annat blir sant

vad som är sant eller inte i ett givet tillstånd beskrivs med satslogik. Vi introducerar temporala kvantifierare.

### CTL

- specifikationer är formler i CTL.
- atomerna är alla satslogiska variabler ({p1, p2, ..., pn}) som vi använder i specifikationen.
- modeller är övergångssystem som kan åskådliggöras som grafer

En modell M består av

- en mängd S av tillstånd
- en övergångsrelation -> <= SxS
- en sanningstilldelning L (en funktion från S till 2^atoms)
