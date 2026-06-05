FROM rocker/tidyverse:4
COPY . /workdir

RUN Rscript -e "install.packages(c('covr', 'DT', 'lintr', 'styler'), repos='http://cran.rstudio.com')"

WORKDIR /workdir/

RUN make install
