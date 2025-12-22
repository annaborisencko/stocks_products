FROM python:3.9-alpine
RUN apk add --no-cache gcc musl-dev linux-headers

WORKDIR /backend

COPY ./requirements.txt ./requirements.txt
RUN pip3 install -r requirements.txt

COPY . .
COPY entrypoint.sh /backend/entrypoint.sh
RUN chmod +x /backend/entrypoint.sh

EXPOSE 5000

ENTRYPOINT ["/backend/entrypoint.sh"]
CMD ["python3", "-u", "manage.py", "runserver", "0.0.0.0:5000"]
