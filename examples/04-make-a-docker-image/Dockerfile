FROM python:3.10-alpine
COPY requirements.txt /tmp/requirements.txt
WORKDIR /tmp/
RUN pip install -r requirements.txt
COPY --chmod=0777 get-services.py /app/get-services.py
WORKDIR /app/
CMD ["/app/get-services.py"]
