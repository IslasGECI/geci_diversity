FROM rocker/tidyverse:4
COPY . /workdir

RUN apt update && apt full-upgrade --yes && apt install --yes \
    texlive-full

RUN Rscript -e "install.packages(c('covr', 'DT', 'lintr', 'styler'), repos='http://cran.rstudio.com')"
RUN Rscript -e "install.packages(c('rshape2', 'vegan'), repos='http://cran.rstudio.com')"

WORKDIR /workdir/
