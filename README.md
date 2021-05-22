# eusa

An `R` package for the European Union State Aid (EUSA) Database. The EUSA database is part of the European Union Compliance Project (EUCP), which also includes the [European Union Infringement Procedure (EUIP) Database](https://github.com/jfjelstul/euip) and the [European Union Technical Regulation (EUTR) Database](https://github.com/jfjelstul/eutr). The EUCP is introduced in the working paper "Legal Compliance in the European Union: Institutional Procedures and Strategic Enforcement Behavior" by Joshua C. Fjelstul. 

The EUSA Database includes 27 datasets on the Commission state aid cases (2000-2020) and state aid awards granted to firms by government agencies in member states (2016-2020), including data on the universe of infringement cases and decisions made by the Commission in state aid cases. The three main datasets are `cases`, `decisions`, and `awards`. The database also includes time-series, cross-sectional, directed dyad-year, and network data on cases and decisions. 

The `cases` dataset includes all state aid cases that the Commission has opened in response to member states notifying state aid measures under [Article 108(3) TFEU](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:12008E108) from 2000 through 2020. The unit of observation is a case. The source of the raw data is the Commission's [state aid cases database](https://ec.europa.eu/competition/elojade/isef/).

The `decisions` dataset includes all decisions made in all state aid cases under [Article 108(2) TFEU](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:12008E108) and [Council Regulation (EU) 2015/1589](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=celex:32015R1589) over the same period. The unit of observation is a decision. The source of the raw data is the Commission's [state aid cases database](https://ec.europa.eu/competition/elojade/isef/).

The `awards` dataset includs all awards granted by member states as part of authorized state aid measures from 2016 through 2020. These awards are reported under transparency requirements introduced by the Commission's [State Aid Modernisation (SAM) programme](https://eur-lex.europa.eu/legal-content/EN/ALL/?uri=CELEX:52012DC0209) and [Commission Regulation (EU) No 651/2014](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32014R0651). The unit of observation is an individual award. The source of the raw data is the Commission's [state aid transparency database](https://webgate.ec.europa.eu/competition/transparency/public?lang=en).

## Installation

You can install the latest development version of the `eusa` package from GitHub:

```r
# install.packages("devtools")
devtools::install_github("jfjelstul/eusa")
```

## Documentation

The codebook for the database is included as a `tibble` in the `R` package: `eusa::codebook`. The same information is also available in the `R` documentation for each dataset. For example, you can see the codebook for the `eusa::cases` dataset by running `?eusa::cases`. You can also read the documentation on the [package website](https://jfjelstul.github.io/eusa/).

## Citation

If you use data from the `eusa` package in a project or paper, please cite the `R` package:

> Joshua Fjelstul (2021). eusa: The European Union State Aid (EUSA) Database. R package version 0.1.0.9000.

The `BibTeX` entry for the package is:

```
@Manual{,
  title = {ecio: The European Union State Aid (EUSA) Database},
  author = {Joshua Fjelstul},
  year = {2021},
  note = {R package version 0.1.0.9000},
}
```

## Problems

If you notice an error in the data or a bug in the `R` package, please report it [here](https://github.com/jfjelstul/eusa/issues).
