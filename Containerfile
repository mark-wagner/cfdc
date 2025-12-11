FROM python:3
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && \
  pip uninstall --yes urllib3 && \
  pip install urllib3
COPY cfdc .
CMD [ "python", "/cfdc" ]
