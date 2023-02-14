FROM python:3.10
LABEL maintainer="chernenko.kostua@gmail.com"
COPY app.py test.py /app/
WORKDIR /app
RUN pip install flask pytest flake8 # This downloads all the dependencies
CMD ["python", "app.py"]