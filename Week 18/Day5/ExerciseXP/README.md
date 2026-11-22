# Tableau Calculated Fields & Data Visualization

**Developers Institute — Data Analytics Bootcamp**  
**Week 18: Tableau Exercises**

## Project Overview

This project explores video game sales data using Tableau Public Desktop. The objective is to practice creating bins, calculated fields, table calculations, and visualizations to analyze sales performance, profitability, annual growth, and market share.

**Dataset:** Video Game Sales (vgsales.csv)

## Exercise 1: EU Sales Bins

**Objective:** Group European video game sales into intervals.

**Method:**
- Created bins using the EU Sales field.
- Set the bin size to 5 million units.
- Created a histogram showing the number of games in each bin.

**Finding:** Approximately 99.8% of games fall into the first bin (0–5 million units), demonstrating that relatively few games achieve exceptionally high European sales.

## Exercise 2: Profitability Index

**Objective:** Estimate game profitability using hypothetical production costs of 30% of global sales.

**Calculated Field:**
```
IF [Global Sales] != 0 THEN
    ([Global Sales] - ([Global Sales] * 0.30))
    / [Global Sales]
END
```

**Visualization:** Horizontal bar chart of the 10 bestselling games.

**Finding:** All games with nonzero global sales have a profitability index of 70%, since the calculation assumes identical proportional costs. This illustrates a limitation of using fixed cost assumptions when comparing profitability.

## Exercise 3: Sales Performance Index

**Objective:** Compare game sales rankings with their original dataset ranks.

**Calculated Field:**
```
RANK(SUM([Global Sales]), 'desc')
```

**Visualization:** Scatter plot comparing average original rank against total global sales, with the calculated sales rank displayed in the tooltip.

**Finding:** Games with higher global sales generally have better rankings. Differences between original and calculated ranks can occur when multiple records share the same game title.

## Exercise 4: Year-on-Year Growth Rate

**Objective:** Analyze changes in global video game sales over time.

**Calculated Field:**
```
(SUM([Global Sales]) -
LOOKUP(SUM([Global Sales]), -1))
/
LOOKUP(SUM([Global Sales]), -1)
```

**Visualization:** Line chart showing annual percentage growth.

**Finding:** Global sales fluctuate significantly across years. The chart shows considerable volatility in earlier periods and more moderate changes in later years.

**Limitation:** The dataset may contain incomplete sales information for recent years, which can affect the interpretation of declining sales.

## Exercise 5: Genre Dominance Ratio

**Objective:** Determine each genre's percentage contribution to global video game sales.

**Calculated Field:**
```
SUM([Global Sales]) /
TOTAL(SUM([Global Sales]))
```

**Visualization:** Horizontal bar chart ranking genres by market share.

**Key Findings:**
- Action: Approximately 17.5%
- Sports: Approximately 14.9%
- Shooter: Approximately 11.6%
- Role-Playing: Approximately 10.4%
- Platform: Approximately 9.3%

Action games account for the largest proportion of global sales in the dataset.

## Exercise 6: North American Sales Contribution

**Research Question:** What percentage of each game's global sales comes from North America?

**Calculated Field:**
```
IF SUM([Global Sales]) != 0 THEN
    SUM([NA Sales]) / SUM([Global Sales])
END
```

**Visualization:** Horizontal bar chart displaying the 20 bestselling games, with percentage labels indicating North American sales contribution.

**Key Findings:**
- Duck Hunt: 95.13%
- Tetris: 73.02%
- Wii Sports: 50.15%
- Pokémon Red/Blue: 35.93%

**Conclusion:** The bestselling video games differ significantly in their dependence on North American sales. Some games rely heavily on North America, while others have more geographically diversified sales.

## Tools and Skills Demonstrated

- Tableau Public Desktop
- Data visualization and exploratory analysis
- Bins and histograms
- Calculated fields
- Table calculations using RANK, LOOKUP, and TOTAL
- Percentage formatting
- Scatter plots, line charts, and bar charts
- Data interpretation and communication

## Overall Conclusion

This project demonstrates how Tableau's calculated fields and visualization capabilities can be used to explore video game sales trends. The exercises highlight differences in regional sales, game rankings, genre popularity, and annual sales performance.

The analysis also illustrates the importance of understanding calculation assumptions, data aggregation, and dataset limitations when interpreting results.
