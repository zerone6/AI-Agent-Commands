# AGENTS Rules

CLAUDE Code를 위한 프로젝트 규칙 문서

---

## 1. 기본 원칙

### 1.1 언어 규칙

| 상황               | 언어                                                                   |
| ------------------ | ---------------------------------------------------------------------- |
| 기본 커뮤니케이션  | 한글                                                                   |
| 기술 용어          | 영어/외국어 원문 유지                                                  |
| 코드 주석/문서     | 영어 (다국적 팀 협업 고려)                                             |
| 커밋 메시지        | 영어                                                                   |
| 각종 마크다운 문서 | 기본 한국어로 작성하고, 기술용어, 코드주석, 커밋메시지등은 위 설정대로 |

### 1.2 파일 작성 규칙

- 이모지 사용 금지
- 인코딩: UTF-8
- 개행: LF (Unix 스타일)

### 1.3 AI 행동 원칙

| 원칙      | 설명                                               |
| --------- | -------------------------------------------------- |
| 사전 확인 | 작업 전 현재 상태 파악 (`git status`, 구조 확인)   |
| 승인 요청 | 대규모 변경, 파일 삭제, 의존성 추가 전 사용자 확인 |
| 실패 보고 | 에러 발생 시 원인 분석 후 보고 (자동 재시도 금지)  |
| 명확화    | 불확실한 요구사항은 질문으로 확인                  |
| 롤백      | 직접 롤백하지 않고 방법만 보고                     |

### 1.4 금지 사항

| 항목                | 설명                                |
| ------------------- | ----------------------------------- |
| README.md 상세 내용 | 상세 구현 내용 금지, 링크만 사용    |
| 중복 문서화         | 같은 내용을 여러 파일에 반복 금지   |
| 하드코딩 경로       | 파일 경로는 상대 경로 사용          |
| 오래된 날짜         | 문서 업데이트 시 날짜 갱신 필수     |
| 미완성 커밋         | 문서 업데이트 없이 코드만 커밋 금지 |

---

## 2. 문서 구조

### 2.1 프로젝트 문서 트리

```text
docs/
├── BACKEND_API.md           # Backend API 명세 (지속 관리)
├── BACKEND_STRUCTURE.md     # Backend 구조 (지속 관리)
├── FRONTEND_ROUTES.md       # Frontend 라우트 (지속 관리)
├── FRONTEND_STRUCTURE.md    # Frontend 구조 (지속 관리)
├── ARCHITECTURE.md          # 전체 아키텍처 (지속 관리)
├── TODO.md                  # 미루어진 작업 (지속 관리)
├── taskLog/                 # 커밋 로그 보관
│   └── commitMMDDNN.md
├── current_sprint/          # 현재 Sprint 작업 문서
│   ├── planMMDDNN.md       # 기능 개발 문서
│   ├── saveTempMMDDNN.md    # 작업 중단 기록
│   ├── securityMMDDNN.md    # 보안 검토 결과
│   └── refactoringMMDDNN.md # 리팩토링 문서
├── planning/                # 외부 문서 기반 작업 계획
│   └── *.md                # 외부 요구사항 문서
└── sprints/                 # 완료된 Sprint 아카이브
    ├── sprint1/
    │   ├── plan*.md
    │   └── saveTemp*.md
    └── sprintMMDDNN.md     # Sprint 요약
```

- 문서 트리는 기본 틀이므로, 프로젝트에 따라서 필요없는 내용은 만들지 않아도 된다.
- 예 : Client Only Project의 경우 BACKEND관련 문서는 필요없다.

### 2.2 참조 경로

| 용도            | 경로                    |
| --------------- | ----------------------- |
| 커밋 로그       | `/docs/taskLog/`        |
| 작업 명령서     | `/docs/current_sprint/` |
| 프로젝트 구조   | `/docs/ARCHITECTURE.md` |
| TODO 목록       | `/docs/TODO.md`         |
| Sprint 아카이브 | `/docs/sprints/`        |
| 외부 기획 문서  | `/docs/planning/`       |
| 릴리즈 노트     | `/docs/releases/`       |

---

## 3. 파일 네이밍 규칙

### 3.1 날짜 기반 파일명

| 유형           | 형식                      | 경로                      | 예시                     |
| -------------- | ------------------------- | ------------------------- | ------------------------ |
| 작업 계획서    | `planMMDDNN.md`           | `/docs/current_sprint/`   | `plan121401.md`          |
| 커밋 로그      | `commitMMDDNN.md`         | `/docs/taskLog/`          | `commit121401.md`        |
| 작업 중단 기록 | `saveTempMMDDNN.md`       | `/docs/current_sprint/`   | `saveTemp121901.md`      |
| 보안 검토      | `securityMMDDNN.md`       | `/docs/current_sprint/`   | `security121901.md`      |
| 리팩토링 결과  | `refactoringMMDDNN.md`    | `/docs/current_sprint/`   | `refactoring121901.md`   |
| Sprint 요약    | `sprintMMDDNN.md`         | `/docs/sprints/`          | `sprint121901.md`        |
| 릴리즈 노트    | `releaseMMDDNN.md`        | `/docs/releases/`         | `release121901.md`       |

**네이밍 규칙:**
- **MM**: 월 (2자리, 01-12)
- **DD**: 일 (2자리, 01-31)
- **NN**: 당일 순번 (01부터 시작)
- **시간대**: Asia/Tokyo

**표기 원칙:**
- 모든 파일명은 **camelCase** 사용 (첫 단어 소문자)
- 모든 날짜는 **MMDDNN** 형식으로 통일

### 3.2 파일명 중복 방지

같은 날짜에 동일 유형의 문서가 여러 개 필요한 경우:
```text
plan121401.md  # 첫 번째 PLAN
plan121402.md  # 두 번째 PLAN (당일)
plan121501.md  # 다음 날 첫 번째 PLAN
```

---

## 4. Slash Command 문서 구조

### 4.1 표준 템플릿

모든 slash command 파일은 다음 구조를 따릅니다:

```markdown
---
agent: agent
description: "<커맨드 한 줄 설명>"
---

<커맨드 개요 1-2문장>

## 목적

<커맨드의 목적과 역할>

## 트리거

<커맨드가 실행되는 상황>

## 결과물

### 파일 경로
\```text
/docs/<경로>/<파일명>
\```

### 파일 형식
<결과물의 구조 및 형식>

## 실행 순서

### Phase 1: <단계명>
<구체적인 실행 내용>

### Phase 2: <단계명>
<구체적인 실행 내용>

## 주의사항

- <주의사항 1>
- <주의사항 2>

## 커밋 메시지 형식 (해당 시)

\```bash
<type>: <subject>
\```
```

### 4.2 필수 섹션

| 섹션          | 필수 여부 | 설명                                       |
| ------------- | --------- | ------------------------------------------ |
| frontmatter   | 필수      | agent, description 포함                    |
| 목적          | 필수      | 커맨드의 역할 명시                         |
| 트리거        | 필수      | 실행 조건                                  |
| 결과물        | 선택      | 파일 생성하는 커맨드만 필수                |
| 실행 순서     | 필수      | Phase별로 구성                             |
| 주의사항      | 권장      | 중요한 제약사항이나 경고                   |
| 커밋 메시지   | 선택      | 커밋을 생성하는 커맨드만 필수              |

### 4.3 섹션 작성 가이드

#### 트리거 섹션
- 사용자가 직접 요청하는 경우
- 특정 상황에서 자동 실행되는 경우
- 다른 커맨드 완료 후 후속 작업인 경우

#### 결과물 섹션
파일을 생성하는 커맨드의 경우 반드시 포함:
```markdown
## 결과물

### 파일 경로
\```text
/docs/current_sprint/planMMDDNN.md
\```

> 폴더가 없으면 자동 생성합니다.

### 파일 형식
\```markdown
<템플릿 예시>
\```
```

#### 실행 순서 섹션
Phase별로 명확하게 단계 구분:
```markdown
## 실행 순서

### Phase 1: 사전 준비
1. 현재 상태 확인
2. 필요 파일 읽기

### Phase 2: 메인 작업
1. 작업 실행
2. 결과 검증
```

---

## 5. Sprint Structure

```text
[ORDER] -> SPRINT {
  반복: ORDER -> PLAN -> dev/execute_plan -> dev/finish_plan
} -> quality/* -> doc/finish_sprint
```

- **ORDER**: 사용자 요청 (입력)
- **PLAN**: AI가 작성한 작업 계획서 (`/docs/current_sprint/planMMDDNN.md`)
- **Sprint**: 여러 PLAN을 포함하는 작업 주기 (작업량 기반)

---

## 6. Commands Reference

### 6.1 커맨드 카테고리

| Category   | Command       | Purpose                              |
| ---------- | ------------- | ------------------------------------ |
| `plan/`    | make_plan     | ORDER 분석 -> PLAN 작성 (Direct/Document 모드) |
| `dev/`     | execute_plan  | PLAN Phase별 구현                    |
| `dev/`     | save_temp     | 작업 중단 시 상태 저장 + WIP 커밋    |
| `dev/`     | finish_plan   | PLAN 완료 후 정리 + 최종 커밋        |
| `quality/` | security      | OWASP Top 10 보안 검토               |
| `quality/` | refactor      | 코드 품질 개선                       |
| `quality/` | l10n          | 다국어 지원 점검                     |
| `quality/` | run_test      | 자동화 테스트 실행                   |
| `doc/`     | finish_sprint | Sprint 종료 및 아카이브              |
| `doc/`     | init_readme   | README.md 생성                       |
| `release/` | deploy        | 빌드 및 배포 실행                    |
| `release/` | hotfix        | 긴급 버그 수정                       |
| `release/` | release_note  | 릴리즈 노트 생성                     |

### 6.2 커맨드 실행 흐름

```text
1. Planning Phase
   make_plan (Direct: 직접 명령 / Document: 외부 문서) -> 사용자 승인

2. Development Phase
   execute_plan -> [save_temp (중단 시)] -> finish_plan

3. Quality Phase
   run_test -> refactor -> security -> l10n

4. Documentation Phase
   finish_sprint

5. Release Phase
   deploy -> release_note -> [hotfix (긴급 시)]
```

---

## 7. 작성 스타일 가이드

### 7.1 Markdown 규칙

```markdown
# 제목: H1 (한 문서에 한 개)

## 섹션: H2

### 하위 섹션: H3

**강조**: 굵게
`코드`: 인라인 코드

- 리스트: 하이픈

1. 번호: 숫자

[링크 텍스트](URL)
```

### 7.2 코드블럭

언어를 명시합니다:

````markdown
```javascript
function example() {}
```

```bash
git status
```

```sql
SELECT * FROM table;
```
````

### 7.3 표 형식

```markdown
| 컬럼1 | 컬럼2 | 컬럼3 |
| ----- | ----- | ----- |
| 값1   | 값2   | 값3   |
```

---

## 8. Git 커밋 규칙

### 8.1 Conventional Commits

```text
<type>: <subject>

<body>

Changes:
- <change 1>
- <change 2>
```

### 8.2 Type 종류

| Type     | 설명                          | 예시                              |
| -------- | ----------------------------- | --------------------------------- |
| feat     | 새로운 기능 추가              | `feat: add user authentication`   |
| fix      | 버그 수정                     | `fix: resolve login error`        |
| refactor | 코드 리팩토링                 | `refactor: improve code structure`|
| docs     | 문서 변경                     | `docs: update README`             |
| style    | 코드 스타일 변경 (동작 무관)  | `style: format code`              |
| test     | 테스트 추가/수정              | `test: add unit tests`            |
| chore    | 빌드, 설정 등 기타 변경       | `chore: update dependencies`      |
| wip      | 작업 중 (중간 저장)           | `wip: user profile - Phase 2`     |
| security | 보안 관련 수정                | `security: fix XSS vulnerability` |
| hotfix   | 긴급 버그 수정                | `hotfix: fix critical login bug`  |

### 8.3 커밋 메시지 작성 원칙

- Subject: 50자 이내, 동사 원형으로 시작, 마침표 없음
- Body: 상세 설명 필요 시 추가
- Changes: 변경 사항 목록 (선택)

---

## 9. 에러 처리 및 보고

### 9.1 에러 발생 시 보고 형식

```markdown
## 에러 보고

### 발생 상황
- 명령어: `실행한 명령어`
- 시점: 어떤 작업 중이었는지

### 에러 내용
(에러 메시지 전문)

### 원인 분석
(추정 원인)

### 해결 방안
1. 방안 A: ...
2. 방안 B: ...

### 권장 조치
(AI 권장 사항)
```

### 9.2 롤백 필요 시

AI는 직접 롤백하지 않고 아래 내용을 보고합니다:

- 롤백이 필요한 이유
- 롤백 명령어/절차
- 영향 범위

---

## 10. 보안 규칙

| 항목 | 규칙 |
|------|------|
| API 키/시크릿 | 코드에 하드코딩 금지, 환경변수 사용 |
| 민감 정보 | 로그/커밋에 포함 금지 |
| .env 파일 | .gitignore에 포함 확인 |

---

## 11. 우선순위 정의

작업 요청 시 우선순위 표기:

| 레벨 | 의미 | 대응 시점 |
|------|------|----------|
| P0 | 긴급 (프로덕션 장애) | 즉시 |
| P1 | 높음 (기능 버그) | 당일 |
| P2 | 보통 (개선) | 이번 Sprint |
| P3 | 낮음 (희망사항) | 백로그 |

---

## 12. 날짜 및 시간 형식

### 12.1 표준 형식

| 용도 | 형식 | 예시 |
|------|------|------|
| 날짜 | YYYY-MM-DD | 2025-12-19 |
| 날짜+시간 | YYYY-MM-DD HH:MM | 2025-12-19 14:30 |
| 시간대 | Asia/Tokyo | 명시 필수 |

### 12.2 문서 내 날짜 표기

```markdown
## 기본 정보
- 일시: 2025-12-19 14:30 (Asia/Tokyo)
- 날짜: 2025-12-19
```

---

## 13. 버전 관리 (Semantic Versioning)

### 13.1 버전 형식

```text
MAJOR.MINOR.PATCH

예: v1.2.3
```

### 13.2 버전 증가 규칙

| 변경 유형 | 버전 | 예시 |
|----------|------|------|
| 호환되지 않는 변경 (Breaking Changes) | MAJOR | 1.0.0 → 2.0.0 |
| 새 기능 (하위 호환) | MINOR | 1.0.0 → 1.1.0 |
| 버그 수정 | PATCH | 1.0.0 → 1.0.1 |

---

## 14. 체크리스트 작성 원칙

문서 내 체크리스트는 다음 형식을 사용:

```markdown
## 사전 확인

- [ ] 항목 1
- [ ] 항목 2
- [x] 완료된 항목
```

---

## 15. 참조 문서 링크 규칙

### 15.1 내부 문서 링크

```markdown
- [ARCHITECTURE](./docs/ARCHITECTURE.md)
- [TODO](./docs/TODO.md)
- [PLAN](./docs/current_sprint/plan121401.md)
```

### 15.2 외부 링크

```markdown
- [GitHub](https://github.com/org/repo)
- [Documentation](https://docs.example.com)
```

---

## 부록: 변경 이력

| 날짜 | 버전 | 변경 내용 |
|------|------|----------|
| 2025-01-30 | 2.0.0 | 파일 네이밍 규칙 통일, slash command 구조 표준화 |
| 2024-12-19 | 1.0.0 | 초기 작성 |
