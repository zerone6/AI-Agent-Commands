---
agent: agent
description: "Code Refactoring을 실시한다."
---

다음 내용을 참고하여 프로젝트 전체를 리팩토링한다.
최상위 레이어는 서버와 클라이언트를 각각 최상위 레이어로 한다.

목표:
- 기능 유지
- 구조 안정화
- 변경 영향 최소화
- 테스트 가능성 확보

전제:
- 현재 코드는 바이브 코딩으로 생성되어 중복, 레이어 혼합, 책임 과다 가능성이 있음

────────────────────
1. 구조 기준 (절대 규칙)
────────────────────

최상위 레이어는 반드시 아래로 분리한다:

- interface        : 외부 입출력 (HTTP/UI/CLI/Batch)
- application      : 유스케이스 흐름
- domain            : 비즈니스 규칙
- infrastructure   : DB / 외부 시스템 구현
- shared            : 최소 공통 요소

의존성 방향:
interface → application → domain
infrastructure → application (인터페이스 통해서만)

금지:
- domain이 DB/API/프레임워크를 아는 것
- application이 HTTP status / SQL을 직접 다루는 것
- shared를 편의용 창고처럼 쓰는 것

────────────────────
2. 레이어 판별 기준
────────────────────

아래 질문으로 위치를 결정한다:

- 이 코드가 DB·API 없이도 의미가 있는가?
  → YES: domain
- 업무 시나리오를 순서대로 조율하는가?
  → YES: application
- 요청/응답 포맷, 인증, 프로토콜인가?
  → YES: interface
- 기술 스택 변경 시 가장 먼저 바뀌는가?
  → YES: infrastructure

────────────────────
3. 중복 제거 기준
────────────────────

다음은 반드시 통합한다:
- 같은 목적, 다른 이름의 함수
- 유사한 검증/계산/정책 로직
- 복붙된 도메인 규칙

방법:
- Extract Function
- Extract Module
- Strategy / Parameterize
- 공통 로직은 domain 또는 application으로 승격

────────────────────
4. 가독성 리팩터링 기준
────────────────────

함수/파일은 다음을 만족해야 한다:
- 함수 길이: 한 책임
- 조건문 깊이: 최대 2
- 흐름이 이름만으로 읽혀야 함

권장 기법:
- Guard clause (early return)
- 의미 단위별 함수 분리
- Value Object 도입 (의미 있는 파라미터 묶기)

────────────────────
5. 모델 분리 기준
────────────────────

다음은 절대 혼합하지 않는다:
- API DTO
- Domain Model
- Persistence Model

변환은 명시적으로 수행한다.

────────────────────
6. 테스트 최소 기준
────────────────────

리팩터링 후 반드시 확보:
- domain: 규칙 단위 테스트 가능
- application: 유스케이스 단위 테스트 가능
- 기존 동작 변경 시 Golden Master 유지

────────────────────
7. 리팩터링 완료 체크
────────────────────

- [ ] domain은 외부 의존성이 없다
- [ ] application은 설명서처럼 읽힌다
- [ ] interface/infrastructure는 교체 가능하다
- [ ] 중복 규칙이 단일 위치에 있다
- [ ] 테스트 없이 깨질 부분이 명확하다

주의:
- 기능 추가 금지
- 동작 변경은 의도적으로만 허용