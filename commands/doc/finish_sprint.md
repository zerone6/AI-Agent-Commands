---
agent: agent
description: "Sprint 종료 시 문서 정리 및 아카이브"
---

Sprint의 모든 PLAN이 완료된 후, 문서 정리 및 아카이브를 수행한다.

## 사전 확인

- [ ] main 브랜치에 모든 변경사항 머지 완료
- [ ] 잔여 feature 브랜치 없음
- [ ] 전체 테스트 통과

## 종료 순서

### 1. Sprint 번호 결정

`/docs/sprints/` 폴더의 기존 sprint 폴더 확인 후 +1:

```bash
ls /docs/sprints/
# sprint1, sprint2 존재 -> 신규: sprint3
```

### 2. Sprint 요약 문서 생성

파일 경로:

```text
/docs/sprints/SPRINT_YYYY_MM_DD.md
```

템플릿:

```markdown
# Sprint N 요약

## 기간
YYYY-MM-DD ~ YYYY-MM-DD

## 주요 성과
- 성과 1
- 성과 2

## 완료된 PLAN
| 파일 | 제목 | 요약 |
|------|------|------|
| planMMDDNN.md | 제목 | 1줄 요약 |

## 변경된 주요 파일
- /path/to/file1
- /path/to/file2

## 다음 Sprint 계획
- 계획 1
- 계획 2

## 잔여 이슈
- 이슈 1
```

### 3. 파일 이동

current_sprint의 완료된 파일을 sprint 폴더로 이동:

```bash
# Sprint 폴더 생성
mkdir -p /docs/sprints/sprint{N}

# PLAN 파일 이동
mv /docs/current_sprint/plan*.md /docs/sprints/sprint{N}/

# SAVETEMP 파일 이동
mv /docs/current_sprint/SAVETEMP_*.md /docs/sprints/sprint{N}/

# REFACTORING 파일 이동 (해당 시)
mv /docs/current_sprint/REFACTORING*.md /docs/sprints/sprint{N}/
```

이동 후 `/docs/current_sprint/`는 비어있는 상태가 된다.

### 4. 문서 업데이트

#### 4.1 README.md

README.md 파일에 구조나, 소개등의 주요 변경점이 있을 경우 수정한다. 
- 예 : 기능이 추가된경우, 변경된 경우, 구조가 바뀐 경우
- README.md에는 변경이력은 기록하지 않는다. 현재의 상태를 기입한다.

"최근 Sprint" 섹션에 추가:

```markdown
- [Sprint N](docs/sprints/SPRINT_YYYY_MM_DD.md): 주요 성과 1줄 요약
```

#### 4.2 TODO.md

- 완료 항목(`[x]`) 제거
- 신규 Technical Debt 추가

#### 4.3 STRUCTURE 문서 최종 확인

- `/docs/structure/BACKEND_STRUCTURE.md`
- `/docs/structure/FRONTEND_STRUCTURE.md`

### 5. 커밋

```bash
git add .
git commit -m "docs: close Sprint N"
```

커밋 로그 작성: `/docs/taskLog/commitMMDDNN.md`

## 결과물

Sprint 종료 후 구조:

```text
docs/
├── current_sprint/          # 비어있음 (다음 Sprint 준비 완료)
└── sprints/
    ├── sprint{N}/
    │   ├── plan*.md
    │   ├── SAVETEMP_*.md
    │   └── REFACTORING*.md
    └── SPRINT_YYYY_MM_DD.md
```
