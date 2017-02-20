FROM drujensen/crystal:0.20.3

WORKDIR /app/user

ADD . /app/user

RUN crystal deps
RUN crystal build db/migrate.cr

CMD ["crystal", "spec"]
