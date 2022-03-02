# Notes for locations up to February 28th

---

# Wasn't sure on rules

I added the following manual rule:

```
Europe,Austria,Upper Austria / Voecklabruck / Voecklamarkt,             Europe,Austria,Upper Austria,Voecklamarkt
```

But still have to fix the spelling during the curate script:

```
# Austria #

Current place for missing division:	Upper Austria / Voecklabruck / Voecklamarkt, Austria
The place as currently written could not be found.
For: Upper Austria / Voecklabruck / Voecklamarkt, Austria
Type a more specific place name or 'NA' to leave blank: Vöcklamarkt Austria
```
---

The following also didn't seem to work as a rule? Maybe I have the wrong formatting?

Added the following to geoLocation rules

```
Africa/Botswana/Greater Phikwe/	Africa/Botswana/Central District BW/Greater Phikwe
```

But still hit the following during the curate script:

```
Current place for missing division:	Greater Phikwe, Botswana
The place as currently written could not be found.
For: Greater Phikwe, Botswana
Type a more specific place name or 'NA' to leave blank: Phikwe

Current place for missing division:	Greater Phikwe, Botswana
Geopy suggestion: Selebi Phikwe, Central District, Botswana
Is this the right place (a - alter division level) [y/n/a]? a
Type correct division to produce corrective rule: Central District BW
Africa/Botswana/Greater Phikwe/	Africa/Botswana/Central District BW/Greater Phikwe
```
---

## Uncertain on location or couldn't find location that geopy was happy with:

```
# Botswana #

Current place for missing division:	Greater Gaborone, Botswana
The place as currently written could not be found.
For: Greater Gaborone, Botswana
Type a more specific place name or 'NA' to leave blank:


# Too many options?
grep -i "Gaborone" defaults/color_ordering.tsv 

location	Greater Gaborone (Southern)
location	Gaborone
location	Greater Gaborone (Southern East)
location	Greater Gaborone (Kweneng District)
```

---

```
# Ghana #

Current place for missing division:	Brong Ahafo Region, Ghana
The place as currently written could not be found.
For: Brong Ahafo Region, Ghana
Type a more specific place name or 'NA' to leave blank:
```

---

```
# Morocco #

Current place for missing division:	Fnidek, Morocco
Geopy suggestion: Dg auto fnidek, Hassan II Boulevard, Fnideq, Pachalik de Fnideq باشوية الفنيدق, M'diq-Fnideq Prefecture, Tangier-Tetouan-Al Hoceima, 93102, Morocco
Is this the right place (a - alter division level) [y/n/a]?
```

