# MSI-DTAN
 
![Stars](https://img.shields.io/github/stars/Smokey95/MSI-DTAN?style=social)
![RepoSize](https://img.shields.io/github/repo-size/Smokey95/MSI-DTAN)
![Forks](https://img.shields.io/github/forks/Smokey95/MSI-DTAN?style=social)
![Watcher](https://img.shields.io/github/watchers/Smokey95/MSI-DTAN?style=social)

---

📄 This repository is intended for the lecture **Data Analysis**

🗺️ The lecture is part of the study program MSI (Master of Informatics=) at University of Applied Sciences (HTWG) Konstanz.

---

## Requirements
When using the official R-Studio most code should run without any problems. The required packages are listed in the `requirements.R` file. You can install them by running the following command in R:

```R
source("requirements.R")
```

When using VS Code you need to install the R extension and the required packages. You can install the packages by running the same command as above in the R terminal.

- [Quarto](https://quarto.org/docs/get-started/) is required to render the R Markdown files. You can install it by following the instructions on the Quarto website.
  - [Quarto VS Code Extension](https://marketplace.visualstudio.com/items?itemName=quarto.quarto) is required to render the R Markdown files in VS Code. You can install it by following the instructions on the Quarto website.
- [Pandoc](https://pandoc.org/installing.html) is required to render the R Markdown files. You can install it by following the instructions on the Pandoc website.

### pdf rendering
To render the `.qmd` files to pdf a LaTeX distribution is required.

Rendering will place relevant information like name and study-id to the pdf file which are not included in the `.qmd` file or the `.html` file. Therefore a `<name>.yml` file is required storing the information in the following format:

```yaml
author: "John Doe (123456)"
```

The `.qmd` file header then needs to include the following line to use the information from the `.yml` file:

```
format:
  html:
    author: ""
  pdf: default

metadata-files:
  - ../../.private.yml
```

## Content

