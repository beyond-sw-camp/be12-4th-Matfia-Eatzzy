<br>

<h1 align="center" style="color: #FFD675;">🍽️ Eatzzy </h1>

<div align="center">
  <img src="/public/image/logo.png" alt="eatzzy logo" width="800" height="400" />
</div>

<h4 align="center">3팀 - Team Matfia </h4>

<h4 align="center">맛집 정보, 예약 및 밀키트 주문 배송 서비스</h4>

<br>

## 🕵️ 팀원 소개

<div align="center">

| <img src="/public/image/tteok.png" width="100" height="100"/> | <img src="/public/image/icecream.png" width="100" height="100"/> | <img src="/public/image/sushi.png" width="100" height="100"/> | <img src="/public/image/ramen.png" width="100" height="100"/> |  <img src="/public/image/burger.png" width="100" height="100"/>  |
| :-----------------------------------------------------------: | :--------------------------------------------------------------: | :-----------------------------------------------------------: | :-----------------------------------------------------------: | :--------------------------------------------------------------: |
|  👻 **박세연**<br/>[@yeon7485](https://github.com/yeon7485)   |    ⚽ **안규호**<br/>[@Ahngyuho](https://github.com/Ahngyuho)    |   🤪 **오승재**<br/>[@dhtmdwo](https://github.com/dhtmdwo)    | 🐢 **유승호**<br/>[@seungho99](https://github.com/seungho99)  | 🐉 **천태훈**<br/>[@taehoon0518](https://github.com/taehoon0518) |

</div>
<br>
<br>

<h1> 🛠️ 기술 스택 </h1>

![github](https://img.shields.io/badge/github-181717.svg?style=for-the-badge&logo=github&logoColor=white)
![docker](https://img.shields.io/badge/docker-2496ED.svg?style=for-the-badge&logo=docker&logoColor=white)
![kubernetes](https://img.shields.io/badge/kubernetes-326CE5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)

![Jenkins](https://img.shields.io/badge/jenkins-D24939.svg?style=for-the-badge&logo=jenkins&logoColor=white)
![CircleCI](https://img.shields.io/badge/circleci-343434.svg?style=for-the-badge&logo=circleci&logoColor=white)
![ansible](https://img.shields.io/badge/ansible-EE0000.svg?style=for-the-badge&logo=ansible&logoColor=white)
![elasticsearch](https://img.shields.io/badge/elasticsearch-005571.svg?style=for-the-badge&logo=elasticsearch&logoColor=white)

<br>
<br>

<h1> 🌏 CI/CD 배포 방식 및 시나리오 </h1>

## 배포 방식

```
프론트엔드: Canary 방식
백엔드: Blue/Green 방식
```

### ❓왜 프론트엔드에 Canary 방식을 적용했나?

식당 예약과 상품 주문 기능을 제공하는 서비스의 특성상, 사용자 피드백을 적극 반영해 UI를 지속적으로 개선해야 한다.  
Canary 배포 방식을 활용하면 새로운 버전을 일부 사용자에게만 먼저 제공하여, 실제 사용자 반응을 기반으로 새로운 버전의 만족도를 알 수 있다.  
이를 통해 개선된 버전의 전면 배포 여부를 보다 신중하게 결정할 수 있다.

<br/>

### ❓왜 백엔드에 Blue/Green 방식을 적용했나?

백엔드는 DB, 인증, 결제 등 핵심 로직을 담당하기 때문에 안정성이 중요하다.  
Blue/Green 방식을 사용하면 장애 발생 시 즉시 전환이 가능하기 때문에 다운타임 없이 복구가 가능하고, API가 대부분 프론트엔드에 의해 호출되기 때문에 버전이 완전히 변경되어도 사용자가 직접 UI로 체감하지 않는다.  
실제 API를 전체 테스트한 후 안전하게 전환이 가능하기 때문에 Blue/Green 방식을 사용했다.

<br/>

### ❓왜 CircleCI를 사용했나?

config 파일로 파이프라인을 정의하기 떄문에 설정이 간편하고 빠르다.  
프론트엔드와 백엔드 빌드를 병렬로 빠르게 수행이 가능하다.  
젠킨스 서버가 한 대밖에 구성이 되어있지 않기 때문에 젠킨스 서버가 부하가 많이 간다.  
=> CircleCI는 클라우드 기반이기 때문에 서버 관리가 필요없다.

<br/>

## 🎬 CI/CD 시나리오

1. **개발자가 작성한 코드를 github에 push**
   - backend-main로 시작하면 CircleCI의 backend 파이프라인을 실행하고,
   - frontend-main로 시작하면 CircleCI의 frontend 파이프라인을 실행한다.

<br/>

2. **github에서 설정한 WebHook이 젠킨스 파이프라인 실행**

<br/>

3. **push가 감지된 브랜치에 맞는 젠킨스 파이프라인 동작**

   - 젠킨스 파이프라인에서 브랜치 이름이

     - backend로 시작하면 CircleCI의 backend 파이프라인을 실행하고,
     - frontend로 시작하면 CircleCI의 frontend 파이프라인을 실행한다.

   - github에서 최신 코드를 clone한 후, 클론된 코드를 기반으로 빌드 작업을 수행한다.
   - 빌드를 통해 도커 이미지를 생성하고 도커 허브에 push한다.

<br/>

4. **Elasticsearch 구성 (Ansible)**
   - Elasticsearch 설치, 설정, 클러스터 구성 자동화

<br/>

5. **K8S 배포**  
   `프론트엔드 (Canary 배포)`

   - 젠킨스 파이프라인이 새로운 버전을 배포할 때, weight값을 설정해서 일부만 새 버전으로 배포되도록 설정 (Ingress yml 파일을 ConfigMap으로 구성)

   - 초기 weight를 20%로 설정하고, 3분 동안 문제가 발생하지 않으면 [20, 50, 100]으로 점진적으로 증가시켜 더 많은 트래픽을 새로운 버전으로 전환환

   - 모든 테스트가 문제가 없다고 판단되면 최종적으로 모든 트래픽을 새로운 버전으로 전환

   `백엔드 (블루그린 배포)`

   - 각 모듈 별로 배포
     - 젠킨스가 Green 환경에 새 버전 배포
     - 서비스 변경 없이 Green에서 사전 테스트 진행
     - 이상 없으면 전환 (Blue -> Green)
     - 기존 Blue 환경은 대기 상태 (롤백 시 즉시 전환 가능)

<br/>
<br/>

## 🔍 ES(ElasticSearch) 사용 이유

우리 프로젝트는 **인기 있는 맛집을 검색하고 예약**할 수 있으며, 해당 맛집에 등록된 **밀키트 상품을 검색하고 구매**할 수 있는 기능을 제공한다.  
이러한 서비스 특성상, 다음과 같은 이유로 ES를 사용하게 되었다.

### 1.1 빠른 검색 속도

맛집과 밀키트 상품을 검색할 때, 단순한 키워드 매칭뿐만 아니라 **사용자 검색 패턴을 고려한 효율적인 검색 결과**를 제공해야 한다.  
RDBMS(MySQL, PostgreSQL 등)에서는 `LIKE` 연산을 사용하여 텍스트 검색이 가능하지만, 데이터가 많아질수록 속도가 급격히 느려진다.  
반면 ES는 **역색인(inverted index) 구조**를 사용하여 수백만 개의 문서에서도 실시간 검색이 가능하다.

### 1.2 다양한 검색 기능 지원

- **Full-Text Search**: 검색어가 정확히 일치하지 않아도 적절한 결과를 반환할 수 있음.
- **유사도 기반 검색**: 고객이 입력한 키워드와 가장 관련성이 높은 맛집 및 밀키트를 추천할 수 있음.
- **다중 필드 검색**: 맛집의 이름, 위치, 음식 종류뿐만 아니라 밀키트 상품의 설명, 리뷰 등의 다양한 정보를 검색할 수 있음.
- **자동 완성(Auto-complete) 및 오타 교정(Fuzzy Search)**: 사용자의 검색 편의성을 증가시킬 수 있음.

### 1.3 확장성과 성능 최적화

우리 프로젝트는 초기에는 데이터가 적지만, 서비스가 성장함에 따라 수많은 맛집과 밀키트 상품 데이터가 추가될 것으로 예상된다. Elasticsearch는 **수평 확장(horizontal scaling)** 을 지원하여, 데이터가 많아지더라도 노드를 추가하여 성능을 유지할 수 있다.

### 1.4 필터링과 정렬 최적화

사용자는 특정 지역, 가격대, 리뷰 평점 등을 기준으로 맛집과 밀키트 상품을 필터링하고 정렬하고자 한다. Elasticsearch는 **필터링(query DSL), 페이징, 정렬** 기능을 제공하여, 복잡한 쿼리도 빠르게 처리할 수 있다.

### 1.5 실시간 데이터 반영 가능

맛집 정보 및 밀키트 상품은 자주 변경될 수 있다. Elasticsearch는 **Near Real-Time(NRT) 처리 방식**을 지원하여, 새로운 데이터가 추가되거나 수정될 때 신속하게 검색 결과에 반영할 수 있다.

<br/>

## 🔍 ES(ElasticSearch) 노드 3대 구성 이유

우리 프로젝트에서 Elasticsearch 클러스터를 **3개 노드(서버)로 구성하는 이유**는 **성능, 고가용성(HA), 데이터 안정성** 때문이다.

### 2.1 고가용성(High Availability, HA) 보장

Elasticsearch는 기본적으로 샤드(Shard)와 복제 샤드(Replica Shard)를 사용하여 데이터를 저장한다. 단일 노드만 있을 경우, 해당 노드가 장애가 발생하면 **서비스 전체가 중단될 위험**이 있다. 하지만 3개의 노드를 운영하면 다음과 같은 이점이 있다.

- **장애 복구(Failover) 가능**: 한 개의 노드가 다운되더라도 나머지 두 개의 노드가 서비스 제공을 유지할 수 있음.
- **Replica Shard 활용**: Elasticsearch는 데이터를 복제하여 여러 노드에 분산 저장하는데, 3개 노드를 운영하면 복제 샤드를 안전하게 보관할 수 있음.

### 2.2 데이터 분산 및 부하 분산(Load Balancing)

우리 프로젝트에서는 맛집 및 밀키트 데이터를 검색하는 요청이 많아질 것으로 예상된다. 만약 한 개의 노드에서 모든 검색 요청을 처리하면 성능이 저하될 수 있다. 하지만 **3개의 데이터 노드로 검색 요청을 분산**하면 성능이 향상된다.

- **노드 간 부하 균형 유지**: 검색 요청이 여러 노드에 분산되면서 응답 속도가 빨라짐.
- **CPU 및 메모리 최적화**: 여러 노드가 검색을 분담하면서 개별 노드의 리소스 사용량이 최적화됨.

### 2.3 데이터 안정성 및 복구 용이

3개 노드를 운영하면 Elasticsearch의 **자동 복구(Auto Recovery)** 기능을 활용할 수 있다. 예를 들어, 특정 노드가 장애를 일으키면 클러스터가 자동으로 **샤드를 재분배하여 데이터 손실을 방지**한다. 또한, 새로운 노드를 추가하면 기존 샤드가 자동으로 재배치되어 **확장성**이 보장된다.

### 2.4 마스터 노드 선출 및 Voting Configuration

Elasticsearch는 클러스터 내에서 **마스터 노드**를 선출하여 클러스터 상태를 관리하는데, 클러스터 안정성을 유지하려면 **최소 3개의 마스터 후보 노드**가 필요하다. 만약 노드가 2개뿐이라면, 한 노드가 다운될 경우 **마스터 선출이 불가능하여 전체 서비스가 중단될 위험**이 있다.

- **Voting Configuration**: Elasticsearch는 `minimum_master_nodes` 설정을 사용하지 않고, 다수결 투표 방식(Voting Configuration)을 통해 마스터 노드를 선출한다. 3개 노드 환경에서는 과반(2개 이상의 노드)이 살아있으면 새로운 마스터를 선출할 수 있어 안정성을 유지할 수 있다.
- **마스터 노드 장애 발생 시**: 나머지 2개 노드가 살아있다면 새로운 마스터를 자동으로 선출하여 클러스터를 유지한다. 하지만 1개 노드만 남으면 과반수 투표가 불가능하여 클러스터가 멈출 위험이 있다.

**3개 노드 운영 시 장점**

- **노드 중 1개는 마스터 노드, 나머지 2개는 데이터 및 검색 처리 담당**
- **마스터 노드가 다운되면 다른 노드가 자동 승격(Election)되어 클러스터 유지**

**어떤 노드가 마스터 노드가 되는지**

- 최신 클러스터 상태(Cluster State, CS)를 가진 노드 : 기존 마스터가 다운되었을 경우, 가장 최신의 클러스터 상태를 가진 노드가 유리함, 데이터 손실을 방지하기 위해 클러스터 상태가 오래된 노드는 선출되지 않음.
- 가장 높은 Term(마스터 노드가 변경됐을 때 증가하는 값) 값을 가진 노드 : 더 높은 Term을 가진 노드가 우선권을 가짐.
- 위 우선순위를 고려했는데 같다면 가장 낮은 노드ID를 가진 노드 : 노드의 고유 ID 또는 이름을 기준으로 정렬하여 가장 작은 값을 가진 노드가 마스터로 선정됨.

<br>
<br>

# 📑 기능 테스트
