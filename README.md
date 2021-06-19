# Hypotension-Prediction-Project
환자의 저혈압 발생 여부를 예측하는 프로젝트입니다.

## Data
[순천향대학교 빅데이터센터](http://aibig.sch.ac.kr/main.do)에서 제공하는 혈압 관련 데이터입니다. 해당 데이터는 MIT-BIH 데이터로 수면중 측정한 데이터입니다. 따라서 깨어있을때 보다 저혈압의 기준이 낮은 것이 특징입니다.

## Pre-Processing
- 관찰기간을 1분 단위로 측정을 합니다.
- 최소값이 50이하일때를 저혈압 발생으로 정의합니다.

## Data singularity

### 클래스 불균형
<img width="500" height="300" alt="스크린샷 2021-06-13 오후 6 35 41" src="https://user-images.githubusercontent.com/55734436/122632210-4e653380-d10c-11eb-85e5-9276ffedb3fb.png">
- 0은 정상혈압, 1은 저혈압을 의미합니다. 클래스 비율을 보면 매우 불균형한 형태로 분포하고 있습니다.

## Feature Extraction

### Statistical Features
통계 특징을 사용하여 추출한 변수입니다. 사용한 특징들은 다음과 같습니다.
- 평균, 최소, 최대, 표준편차, 왜도, 첨도, rms, rss, 사분위, 첨도, 범위를 사용하였습니다.

### Peak Features
<img width="500" height="300" alt="스크린샷 2021-06-13 오후 6 35 41" src="https://user-images.githubusercontent.com/55734436/122632752-d13bbd80-d10f-11eb-91bf-415a525491d4.png">

피크 특징에 사용되는 findpeaks 함수에서는 피크 기준값을 설정하는 옵션이 있습니다. 랜덤으로 그래프를 그려본 후 기준값을 120이상으로 설정하였습니다. 사용한 특징들은 다음과 같습니다.
- 피크 수, 피크 발생 간격의 평균, 피크 발생 간격의 표준편차, 피크의 (평균, 최대, 최소, 표준편차), 피크 발생 바로 이전값의 (평균, 최대, 최소, 표준편차), 피가 발생 바로 이후값의 (평균, 최대, 최소, 표준편차)

### ChangePoint Features
<img width="500" height="300" alt="스크린샷 2021-06-13 오후 6 35 41" src="https://user-images.githubusercontent.com/55734436/122632877-7e163a80-d110-11eb-8613-7dc511edc70e.png">

변화 분석을 사용하여 추출한 변수입니다. 사용한 특징들은 다음과 같습니다.
- 평균이 변화한 수, 분산이 변화한 수, 평균과 분산이 변화한 수

## Modeling Method
### 학습 방법
- 통계, 피크, 변화 분석으로 추출한 모든 변수를 사용하여 분석을 진행하였습니다.
- Train, Test를 7:3으로 분리하여 분석을 진행하였습니다.

### 모델 평가 기준
클래스의 불균형과 의료 데이터임을 고려하여 다음과 같이 모델 평가 기준을 설정하였습니다.

**1)Balanced accuracy**
- Balanced accuracy란 각 클래스 재현율의 산술 평균입니다.(1에 가까울수록 좋음) 클래스 불균형 특징으로 일반적인 Accuracy가 아닌 Balanced Accuracy를 기준으로 모델을 평가합니다.

**2)NPV**
- 클래스의 불균형으로 정상과 저혈압을 각각 얼마나 예측했는지 파악하는 것이 중요합니다. 따라서 NPV(Negative Prediction Value)의 값이 어느정도 나온 모델을 선정해야 합니다.

### 사용 모델
- NaiveBayes 
- Decision Tree(rpart)
- RandomForest

## Result

### NaiveBayes 
<img width="450" height="400" alt="스크린샷 2021-06-13 오후 6 35 41" src="https://user-images.githubusercontent.com/55734436/122633703-da7b5900-d114-11eb-9931-a86acd5d4322.png">

### Decision Tree(rpart)
<img width="450" height="400" alt="스크린샷 2021-06-13 오후 6 35 41" src="https://user-images.githubusercontent.com/55734436/122633744-17475000-d115-11eb-8663-7d055f0a89f8.png">

### RandomForest
<img width="450" height="400" alt="스크린샷 2021-06-13 오후 6 35 41" src="https://user-images.githubusercontent.com/55734436/122633777-452c9480-d115-11eb-9fa0-ce8a787eaabe.png">

- Decision Tree와 RandomForest는 클래스 불균형 문제로 인해 모든 값을 정상혈압으로 예측하였습니다. 물론, 정확도는 높지만 좋은 모델이라고 할 수 없습니다.
- NaiveBayes는 저혈압 데이터 15개에서 11개를 예측하였습니다. 정상 데이터의 예측값은 조금 떨어졌지만 클래스 불균형과 의료 데이터의 특징을 고려하여 NaiveBayes를 가장 좋은 모델로 선정하였습니다.
