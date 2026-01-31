---
agent: agent
description: "작업 중단 시 상태 보존"
---

작업을 중단하고 나중에 재개하기 위해 현재 상태를 저장합니다.

## 목적

execute_plan 실행 중 작업을 중단해야 할 때, 현재 진행 상황과 컨텍스트를 저장하여 나중에 동일한 지점에서 재개할 수 있도록 합니다.

## 트리거

- 작업 중 예상치 못한 중단이 필요할 때
- 다른 긴급 작업을 우선 처리해야 할 때
- 작업 시간이 예상보다 길어져 중간 저장이 필요할 때
- 사용자가 명시적으로 중단을 요청할 때

## 결과물

### 파일 경로

```text
/docs/current_sprint/saveTempMMDDNN.md
/docs/taskLog/commitMMDDNN.md (WIP 커밋 로그)
```

> 파일명 규칙: `saveTemp` + `월(MM)` + `일(DD)` + `순번(NN)` + `.md`
> 참고: [CLAUDE.md - 파일 네이밍 규칙](../../CLAUDE.md#3-파일-네이밍-규칙)

### 파일 형식

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
(블로커, 질문 사항, 기술적 문제 등)

## 변경된 파일 (미커밋)
- path/to/file1.ts: 변경 내용
- path/to/file2.ts: 변경 내용

## 컨텍스트 정보
- 참고한 문서: ...
- 관련 이슈: ...
- 기술적 선택 사항: ...
```

## 실행 순서

### Phase 1: 상태 파일 생성

1. 파일명 결정
   - 현재 날짜 기준 (Asia/Tokyo)
   - `/docs/current_sprint/` 폴더 내 동일 날짜 파일 확인
   - 순번(NN) 결정

2. 현재 상태 분석
   - 진행 중인 PLAN 파일 확인
   - 완료된 Phase 파악
   - 현재 Phase 진행 상황 파악

3. 상태 파일 작성
   - 템플릿에 따라 현재 상태 기록
   - 구체적이고 상세하게 작성
   - 재개 시 필요한 모든 정보 포함

### Phase 2: WIP 커밋 생성

1. 변경 파일 확인
   ```bash
   git status
   git diff
   ```

2. 모든 변경사항 커밋
   ```bash
   git add .
   git commit -m "wip: <PLAN 제목> - Phase N 진행 중"
   ```

   **WIP 커밋 메시지 형식:**
   ```text
   wip: <PLAN의 주요 기능 요약> - Phase N 진행 중

   현재 진행 상황:
   - 완료: Phase 1, 2
   - 진행 중: Phase 3 (XX% 완료)

   다음 작업:
   - ...
   ```

3. 커밋 ID 저장
   ```bash
   git log -1 --oneline
   ```
   - 커밋 ID를 상태 파일에 기록

### Phase 3: 커밋 로그 작성

`/docs/taskLog/commitMMDDNN.md`에 WIP 커밋 로그 작성:

```markdown
wip: user authentication - Phase 2 진행 중

현재 진행 상황:
- 완료: Phase 1 (AuthService 기본 구조)
- 진행 중: Phase 2 (JWT 토큰 생성 로직)

다음 작업:
- JWT 토큰 검증 로직 구현
- 미들웨어 작성

Changes:
- Add AuthService.ts skeleton
- Implement JWT token generation (partial)
- Add test cases for token generation
```

### Phase 4: PLAN 파일 업데이트

PLAN 파일에 중단 정보 추가:

```markdown
## 작업 중단 기록

- 중단 일시: YYYY-MM-DD HH:MM
- 상태 파일: /docs/current_sprint/saveTempMMDDNN.md
- 진행률: 60%
```

### Phase 5: 사용자 보고

1. 중단 완료 알림
2. 재개 방법 안내
3. 다음 작업 내용 요약

## 재개 방법

작업 재개 시:

1. **상태 파일 확인**
   ```bash
   cat /docs/current_sprint/saveTempMMDDNN.md
   ```

2. **PLAN 파일과 함께 execute_plan 실행**
   - "saveTemp 파일의 다음 작업부터 진행해줘"
   - AI가 상태 파일을 읽고 컨텍스트 파악

3. **진행 중이던 Phase부터 계속**
   - 상태 파일의 "다음 작업" 항목부터 진행
   - 미해결 이슈 우선 처리

> **주의**: SAVETEMP 파일은 삭제하지 않고 유지합니다.
> Sprint 종료 시 `finish_sprint`에서 아카이브 처리됩니다.

## 주의사항

- **상세 기록**: 재개 시 필요한 모든 컨텍스트를 상세히 기록
- **커밋 필수**: 변경사항이 있으면 반드시 WIP 커밋 생성
- **파일 유지**: SAVETEMP 파일은 삭제하지 않음 (Sprint 종료 시 정리)
- **PLAN 연결**: 어떤 PLAN의 어떤 Phase를 진행 중이었는지 명확히 기록
- **이슈 기록**: 블로커, 미해결 질문 등을 상세히 기록

## WIP 커밋 vs 정식 커밋

| 항목         | WIP 커밋                  | 정식 커밋 (finish_plan)  |
| ------------ | ------------------------- | ------------------------ |
| 목적         | 중간 저장                 | 작업 완료                |
| 메시지 타입  | wip                       | feat, fix 등             |
| 테스트       | 불완전 허용               | 전체 통과 필수           |
| 문서 업데이트| 불필요                    | 필수                     |
| 사용 시점    | save_temp                 | finish_plan              |
| 커밋 로그    | 자동 생성                 | 자동 생성                |

## 다음 단계

save_temp 완료 후:

1. **작업 재개** (나중에)
   - SAVETEMP 파일 읽기
   - execute_plan으로 계속 진행

2. **다른 작업 우선** (긴급 건)
   - 새로운 PLAN 작성 및 실행
   - 완료 후 다시 돌아오기

## 예시 시나리오

```text
상황: Phase 3 진행 중 긴급 버그 수정 요청 발생

1. save_temp 실행
2. WIP 커밋 생성
3. saveTempMMDDNN.md 파일 작성
4. 긴급 버그 수정 작업 (hotfix)
5. 버그 수정 완료 후
6. saveTempMMDDNN.md 읽고 execute_plan 재개
7. Phase 3부터 계속 진행
```
