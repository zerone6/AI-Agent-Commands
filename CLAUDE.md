# AGENTS Rules

CLAUDE Code를 위한 프로젝트 규칙 문서

---
# AGENTS Rules

AI 코딩 어시스턴트를 위한 프로젝트 규칙 문서

---

## 1. 기본 원칙

### 1.1 언어 규칙

| 상황 | 언어 |
|------|------|
| 기본 커뮤니케이션 | 한글 |
| 기술 용어 | 영어/외국어 원문 유지 |
| 코드 주석/문서 | 영어 (다국적 팀 협업 고려) |
| 커밋 메시지 | 영어 |

### 1.2 파일 작성 규칙

- 이모지 사용 금지
- 인코딩: UTF-8
- 개행: LF (Unix 스타일)

### 1.3 AI 행동 원칙

| 원칙 | 설명 |
|------|------|
| 사전 확인 | 작업 전 현재 상태 파악 (`git status`, 구조 확인) |
| 승인 요청 | 대규모 변경, 파일 삭제, 의존성 추가 전 사용자 확인 |
| 실패 보고 | 에러 발생 시 원인 분석 후 보고 (자동 재시도 금지) |
| 명확화 | 불확실한 요구사항은 질문으로 확인 |
| 롤백 | 직접 롤백하지 않고 방법만 보고 |

### 1.4 금지 사항

| 항목 | 설명 |
|------|------|
| README.md 상세 내용 | 상세 구현 내용 금지, 링크만 사용 |
| 중복 문서화 | 같은 내용을 여러 파일에 반복 금지 |
| 하드코딩 경로 | 파일 경로는 상대 경로 사용 |
| 오래된 날짜 | 문서 업데이트 시 날짜 갱신 필수 |
| 미완성 커밋 | 문서 업데이트 없이 코드만 커밋 금지 |

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
│   ├── SAVETEMP_MMDDNN.md   # 작업 중단 기록
│   └── REFACTORING*.md      # 리팩토링 문서 (추후 정의)
└── sprints/                 # 완료된 Sprint 아카이브
    ├── sprint1/
    │   ├── plan*.md
    │   └── SAVETEMP_*.md
    └── SPRINT_YYYY_MM_DD.md # Sprint 요약
```
- 문서 트리는 기본 틀이므로, 프로젝트에 따라서 필요없는 내용은 만들지 않아도 된다.
- 예 : Client Only Project의 경우 BACKEND관련 문서는 필요없다.

### 2.2 참조 경로

| 용도 | 경로 |
|------|------|
| 커밋 로그 | `/docs/taskLog/` |
| 작업 명령서 | `/docs/current_sprint/` |
| 프로젝트 구조 | `/docs/structure/` |
| TODO 목록 | `/docs/TODO.md` |
| Sprint 아카이브 | `/docs/sprints/` |

---

## 3. 작성 스타일 가이드

### 3.1 Markdown 규칙

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

### 3.2 코드블럭

언어를 명시한다:

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

### 3.3 표 형식

```markdown
| 컬럼1 | 컬럼2 | 컬럼3 |
|-------|-------|-------|
| 값1   | 값2   | 값3   |
```

## 4. 파일 네이밍 규칙

| 유형 | 형식 | 예시 |
|------|------|------|
| 커밋 로그 | `commitMMDDNN.md` | `commit121401.md` |
| 작업 명령서 | `orderMMDDNN.md` | `order121401.md` |
| 작업 중단 기록 | `SAVETEMP_MMDDNN.md` | `SAVETEMP_121901.md` |
| Sprint 요약 | `SPRINT_YYYY_MM_DD.md` | `SPRINT_2025_12_19.md` |

- **MM**: 월 (2자리)
- **DD**: 일 (2자리)
- **NN**: 당일 순번 (01부터)
- **시간대**: Asia/Tokyo


## 5. Sprint Structure

```text
[ORDER] -> SPRINT {
  반복: ORDER -> PLAN -> dev/execute_plan -> dev/finish_order
} -> quality/* -> doc/finish_sprint
```

- **ORDER**: 사용자 요청 (입력)
- **PLAN**: AI가 작성한 작업 계획서 (`/docs/current_sprint/planMMDDNN.md`)
- **Sprint**: 여러 PLAN을 포함하는 작업 주기 (작업량 기반)

## 6. Commands Reference

| Category | Command | Purpose |
|----------|---------|---------|
| `plan/` | make_plan | ORDER 분석 -> PLAN 작성 |
| `plan/` | review_order | 외부 문서(Jira, 기획서) -> PLAN 변환 |
| `dev/` | execute_plan | PLAN Phase별 구현 |
| `dev/` | save_temp | 작업 중단 시 상태 저장 |
| `dev/` | finish_order | 구현 완료 후 정리 |
| `quality/` | security | OWASP Top 10 보안 검토 |
| `quality/` | refactor | 코드 품질 개선 |
| `quality/` | l10n | 다국어 지원 점검 |
| `doc/` | commit_log | Conventional Commit 로그 작성 |
| `doc/` | finish_sprint | Sprint 종료 및 아카이브 |
