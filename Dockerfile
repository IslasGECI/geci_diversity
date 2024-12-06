FROM rocker/tidyverse:4
COPY . /workdir

RUN apt update && apt full-upgrade --yes && apt install --yes \
    texlive-full

RUN Rscript -e "install.packages(c('covr', 'DT', 'lintr', 'styler'), repos='http://cran.rstudio.com')"
RUN R -e "remotes::install_github(c('IslasGECI/testtools', 'IslasGECI/optparse'))"
RUN Rscript -e "install.packages(c('reshape2', 'vegan', 'rjson'), repos='http://cran.rstudio.com')"

WORKDIR /workdir/
