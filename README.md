# London Marathon

Two data sets scraped from Wikipedia (1 November 2022) on London Marathon winners, and general data. The two data sets can be joined by `Year`.

## `winners.csv`

|Column       |Class      |Description                |Example              |
|:------------|:----------|:--------------------------|:--------------------|
|Category     |character  |Category of race           |Men                  |
|Year         |integer    |Year                       |1981                 |
|Athlete      |character  |Name of the winner         |Dick Beardsley (Tie) |
|Nationality  |character  |Nationality of the winner  |United States        |
|Time         |character  |Winning timee              |02:11:48             |


## `london_marathon.csv`

|Column           |Class      |Description                                 |Example              |
|:----------------|:----------|:-------------------------------------------|:--------------------|
|Date             |character  |Date of the race                            |1981-03-29           |
|Year             |integer    |Year                                        |1981                 |
|Applicants       |integer    |Number of people who applied                |20000                |
|Accepted         |integer    |Number of people accepted                   |7747                 |
|Starters         |integer    |Number of people who started                |7055                 |
|Finishers        |integer    |Number of people who finsihed               |6255                 |
|Raised           |integer    |Amount raised for charity (£ millions)      |46.5                 |
|Official.charity |character  |Official charity                            |SportsAid            |

