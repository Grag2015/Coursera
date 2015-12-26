
```{r}
library(ggplot2)
```


```{r}
data(mtcars)
```
```{r}
head(mtcars)
summary(mtcars)
str(mtcars)
```

Пользовательские функции доступны в исходном коде проекта по [ссылке](test)
```{r echo=FALSE, results='hide'}
# my functions
# пользовательская ф-я для вывода параметров регрессионной модели
printlm <- function(model){
  tempsum <- summary(model)
  cat("Residual standard error:", format(signif(tempsum$sigma, 
                                                4)), "on", tempsum$df[2L], "degrees of freedom")
  cat("\n")
  cat("Multiple R-squared:  ", round(tempsum$r.squared, digits=4),	"Adjusted R-squared:  ",
      round(tempsum$adj.r.squared, digits=4))
  cat("\n")
  cat("F-statistic: ", round(tempsum$fstatistic[1],2), "on", round(tempsum$fstatistic[2],0), 
      "and", round(tempsum$fstatistic[3],0), "DF,  p-value:",
      format.pval(pf(tempsum$fstatistic[1L],tempsum$fstatistic[2L], 
                     tempsum$fstatistic[3L], lower.tail = FALSE)))
}
# пользовательские функции для график попарных корреляций
    panel.density <- function(x, ...) {
        n.groups <-  1
        adjust <-  1
        groups = NULL
        if (n.groups > 1) {
            levs <- levels(groups)
            for (i in 1:n.groups) {
                xx <- x[levs[i] == groups]
                dens.x <- try(density(xx, adjust = adjust, na.rm = TRUE), 
                  silent = TRUE)
                if (!inherits(dens.x, "try-error")) {
                  lines(dens.x$x, min(x, na.rm = TRUE) + dens.x$y * 
                    diff(range(x, na.rm = TRUE))/diff(range(dens.x$y, 
                    na.rm = TRUE)), col = col[i])
                }
                else warning("cannot estimate density for group ", 
                  levs[i], "\n", dens.x, "\n")
                rug(xx, col = col[i])
            }
        }
        else {
            dens.x <- density(x, adjust = adjust, na.rm = TRUE)
            lines(dens.x$x, min(x, na.rm = TRUE) + dens.x$y * 
                diff(range(x, na.rm = TRUE))/diff(range(dens.x$y, 
                na.rm = TRUE)))
            rug(x)
        }
#         if (do.legend) 
#             legendPlot(position = if (is.null(legend.pos)) 
#                 "topright"
#             else legend.pos)
#         do.legend <<- FALSE
    }
panel.cor <- function(x, y, digits=2, prefix="", cex.cor, ...)
{
    usr <- par("usr"); on.exit(par(usr))
    par(usr = c(0, 1, 0, 1))
    r <- cor(x[!is.na(x*y)], y[!is.na(x*y)])
    txt <- format(c(r, 0.123456789), digits=digits)[1]
    txt <- paste(prefix, txt, sep="")
    if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
    text(0.5, 0.5, txt, cex = cex.cor * max(abs(r), 0.25))
}

panel.smooth2 <- function(x, y){
panel.smooth(x, y,iter = 1)
}
```


мы видим, что `am` факторная переменная с двумя уровнями - (0 = automatic, 1 = manual)
```{r}
table(mtcars$am)
```


```{r}
ggplot(data=mtcars, aes(x=am, y=mpg))+geom_boxplot()
```

мы видим, что значения mpg значительно различаются для различных типов коробок передач
```{r}
t.test(x=mtcars[mtcars$am=="manual","mpg"], y=mtcars[mtcars$am=="automat","mpg"], var.equal = F)
```

We see that p-value = 0.001374, so we have статистические значимые различия между группами


```{r}
fit <- lm(data = mtcars, mpg ~ am)
```
```{r echo=FALSE, results='hold'}
printlm(fit)
```
```{r results='asis',  echo=FALSE}
xt <- xtable(summary(fit))
print(xt, type="html")
```

т.о. я построил простую модель, в которой для разных типов коробок передач в 
качестве оценки mpg мы берем среднее в группе. Аналитически это можно записать так:
`mpg = 17.147 + am*7.24`
при этом доверительный интервал для каждой оценки - 

Также следует заметить, что данная модель объясняет только 34% дисперсии, мы можем предположить, что на расход должны также влиять переменные Weight, Gross horsepower, Number of cylinders. Попробуем добавить в нашу модель еще одну переменную

```{r  fig.width=6,  fig.height=4}
# -c("qsec", "gear", "carb")
    pairs(mtcars[,c(1:6,8:9)], diag.panel=panel.density, upper.panel=panel.cor, lower.panel=panel.smooth2)

```

Мы видим, что существует много переменных, которые сильно коррелируют с `mpg`, все они кандидаты для добавления в модель. При этом надо учитывать, что новая переменная не должна сильно коррелировать с переменной `am` (которая уже есть в нашей модели). Подходящей переменной будет 'hp'.

Построим модель
```{r}
fit <- lm(data = mtcars, mpg ~ am+hp)
summary(fit)
ggplot(data = mtcars, aes(x=am, y=mpg, size=hp))+geom_point()
```
Мы видим, что доля объясненной дисперсии составила уже 77% - it's good result

