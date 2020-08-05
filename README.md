# The euaid R Package

This package provides easy access to data and documentation from the European Union State Aid (EUSA) Database by Joshua C. Fjelstul, Ph.D. The database includes three datasets: `cases`, `decisions`, and `awards`. 

The `cases` dataset includes all state aid cases that the Commission has opened in response to member states notifying state aid measures under [Article 108(3) TFEU](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:12008E108) from 2000 through 2020. The unit of observation is a case. The source of the raw data is the Commission's [state aid cases database](https://ec.europa.eu/competition/elojade/isef/).

The `decisions` dataset includes all decisions made in all state aid cases under [Article 108(2) TFEU](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:12008E108) and [Council Regulation (EU) 2015/1589](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=celex:32015R1589) over the same period. The unit of observation is a decision. Again, the source of the raw data is the Commission's [state aid cases database](https://ec.europa.eu/competition/elojade/isef/).

The `awards` dataset includs all awards granted by member states as part of authorized state aid measures from 2016 through 2020. These awards are reported under transparency requirements introduced by the Commission's [State Aid Modernisation (SAM) programme](https://eur-lex.europa.eu/legal-content/EN/ALL/?uri=CELEX:52012DC0209) and [Commission Regulation (EU) No 651/2014](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32014R0651). The unit of observation is an individual award. The source of the raw data is the Commission's [state aid transparency databse](https://webgate.ec.europa.eu/competition/transparency/public?lang=en).

## Installation

You can install the latest development version from GitHub:

```r
# install.packages("devtools")
devtools::install_github("jfjelstul/euaid")
```

## Documentation

See examples and read the documentation on the [package site](https://jfjelstul.github.io/euaid/). 

## Citation

If you use data from this package in a project or paper, please use the following citation:

> Joshua C. Fjelstul (2020). euaid: The European Union State Aid (EUSA) Database. R package version 1.0.0. https://github.com/jfjelstul/euaid

The bibtex entry for the article is:

```
@Manual{,
    title = {euaid: The European Union State Aid (EUSA) Database},
    author = {Joshua C. Fjelstul},
    year = {2020},
    note = {R package version 1.0.0},
    url = {https://github.com/jfjelstul/euaid},
  }
```
