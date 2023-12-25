FROM public.ecr.aws/lambda/python:3.11

COPY requirements.txt ${LAMBDA_TASK_ROOT}

COPY lambda_function.py ${LAMBDA_TASK_ROOT}

RUN pip install -r requirements.txt

CMD [ "lambda_function.lambda_handler" ]

# docker build --platform linux/amd64 -t lab3-rest-lambda-image:latest .
# docker tag lab3-rest-lambda-image:latest public.ecr.aws/a4e6s6x8/lab3-rest-lambda-image:latest
# docker push public.ecr.aws/a4e6s6x8/lab3-rest-lambda-image:latest