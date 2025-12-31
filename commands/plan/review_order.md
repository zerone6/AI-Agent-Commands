---
agent: agent
description: "외부 문서를 분석하여 make_plan 형식의 PLAN 작성"
---

첨부된 외부 문서(기획서, 티켓, 요구사항 등)를 분석하여 PLAN을 작성한다.

## 목적

외부에서 전달받은 자료(ORDER)를 해석하고, `make_plan` 형식에 맞는 PLAN 문서를 생성한다.

## 트리거

- 외부 기획서, 요구사항 문서가 첨부되었을 때
- Jira/GitHub Issue 내용을 PLAN으로 변환할 때
- 슬랙/이메일 요청을 정식 PLAN으로 작성할 때

## 지원 입력 형식

| 유형 | 예시 |
|------|------|
| 이슈 트래커 | Jira 티켓, GitHub Issue, Linear |
| 문서 | 기획서 (PDF, Markdown, Notion) |
| 메시지 | 슬랙 스레드, 이메일 요청 |
| 회의록 | 미팅 노트, 요구사항 정리 |

## 실행 순서

### Phase 1: 외부 문서 분석

1. 첨부된 문서 또는 열려있는 파일 내용 확인
2. 핵심 요구사항 추출
3. 불명확한 부분 식별 및 질문 목록 작성

### Phase 2: 프로젝트 컨텍스트 확인

다음 문서를 참고하여 기존 시스템 구조 파악:

- `/docs/ARCHITECTURE.md`
- `/docs/FRONTEND_STRUCTURE.md`
- `/docs/BACKEND_STRUCTURE.md`
- `/docs/FRONTEND_ROUTES.md`
- `/docs/BACKEND_API.md`

확인 사항:

- 기존 폴더 구조 및 역할 준수
- 불필요한 중복 방지
- 확장성 고려

### Phase 3: PLAN 작성 (make_plan 형식)

추출된 요구사항을 기반으로 `make_plan` 형식의 PLAN 작성:

```text
/docs/current_sprint/planMMDDNN.md
```

PLAN 포함 내용:

1. **작업 개요**: 외부 문서에서 파악한 요구사항 요약
2. **목표**: 달성해야 할 결과물
3. **작업 계획 (Phase별)**: 구현 단계
4. **구현 체크리스트**: 세부 작업 항목
5. **테스트 시나리오**: 검증 방법
6. **원본 참조**: 외부 문서 원문 (하단에 보존)

### Phase 4: 사용자 확인

1. 작성된 PLAN 내용 검토 요청
2. 불명확한 부분에 대한 질문
3. 승인 후 `execute_plan` 진행 가능

## make_plan과의 관계

```text
[ORDER: 외부 문서] --> review_order --> [PLAN 문서] --> execute_plan
                           |
                           v
                   (make_plan 형식 적용)
```

| 명령어 | 입력 | 출력 |
|--------|------|------|
| `make_plan` | 사용자 직접 요청 (ORDER) | PLAN 문서 |
| `review_order` | 외부 첨부 문서 (ORDER) | PLAN 문서 |

## 주의사항

- 원본 외부 문서는 PLAN 하단에 보존
- 해석이 불명확한 부분은 반드시 사용자에게 확인
- 기존 프로젝트 구조와 일관성 유지
