FROM python:alpine3.17

LABEL maintainer="Dzmitry Senko"

RUN apk update && \
    apk add --no-cache bash && \
    apk add --no-cache tree

# Install pylint (-U, --upgrade)
RUN pip install -U setuptools
RUN pip install -U pylint

WORKDIR /app

COPY . .

# For app 
RUN pip install -r requirements.txt

ENV TZ=Europe/Minsk

ENTRYPOINT ["python"]

CMD ["GeometryCalcWeb.py"]