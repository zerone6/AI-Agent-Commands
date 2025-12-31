---
agent: agent
description: "작업 중단 시 상태 보존"
---

작업을 중단하고 나중에 재개하기 위해 현재 상태를 저장한다.

## 파일 경로

```text
/docs/current_sprint/SAVETEMP_MMDDNN.md
```

- MMDD: 월일 (Asia/Tokyo 기준)
- NN: 당일 순번 (01부터)
- 예: `SAVETEMP_121901.md`

## 저장 순서

### 1. 상태 파일 생성

아래 템플릿에 따라 현재 상태를 기록한다:

```markdown
# 작업 중단 기록

## 기본 정보
- 일시: YYYY-MM-DD HH:MM (Asia/Tokyo)
- PLAN 파일: /docs/current_sprint/planMMDDNN.md
- 브랜치: feature/xxx
- 마지막 커밋: <commit-id>

## 진행 상황
- 완료된 Phase: Phase 1, 2
- 진행 중인 Phase: Phase 3
- 진행률: 3/5 Phase (60%)

## 마지막 작업 내용
(구체적으로 무엇을 했는지)

## 다음 작업
(재개 시 이어서 해야 할 작업)

## 미해결 이슈
(블로커, 질문 사항 등)

## 변경된 파일 (미커밋)
- path/to/file1.ts
- path/to/file2.ts
```

### 2. 커밋

중간 저장 시점의 모든 변경사항을 커밋한다:

```bash
git add .
git commit -m "wip: <PLAN 제목> - Phase N 진행 중"
```

### 3. 커밋 로그 작성

`/docs/taskLog/commitMMDDNN.md`에 커밋 로그 작성

## 재개 방법

별도 RESUME 커맨드 없이, 다음 순서로 재개한다:

1. 해당 PLAN 파일과 SAVETEMP 파일을 함께 execute_plan
2. SAVETEMP 파일의 "다음 작업" 항목부터 진행

> SAVETEMP 파일은 삭제하지 않고 유지한다. Sprint 종료 시 별도 정리 프로세스에서 처리된다.
