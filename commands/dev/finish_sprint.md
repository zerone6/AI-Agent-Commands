---
agent: agent
description: "Sprint 종료 시 문서 정리 및 아카이브"
---

Sprint의 모든 작업이 완료된 후 문서를 정리하고 아카이브하여 다음 Sprint를 준비합니다.

## 목적

Sprint 동안 생성된 모든 문서를 체계적으로 정리하고 아카이브하여 프로젝트의 변경 이력을 추적 가능하게 만들며, 다음 Sprint를 위한 깨끗한 작업 환경을 준비합니다.

## 트리거

- Sprint의 모든 PLAN이 완료되었을 때
- 사용자가 Sprint 종료를 요청할 때
- 주요 마일스톤 완료 후 문서 정리가 필요할 때

## 결과물

### 파일 경로
```text
/docs/sprints/sprintMMDDNN.md
```

| 요소 | 설명                   |
| ---- | ---------------------- |
| MM   | 월 (01-12)             |
| DD   | 일 (01-31)             |
| NN   | 당일 순번 (01부터)     |
| 시간대 | Asia/Tokyo           |
| 예시 | `sprint013001.md`      |

> `/docs/sprints/sprintN/` 폴더에 이전 Sprint 문서들이 이동됩니다.

### 파일 형식
```markdown
# Sprint N 요약

## 기본 정보
- Sprint 번호: N
- 기간: YYYY-MM-DD ~ YYYY-MM-DD
- 시간대: Asia/Tokyo

## 주요 성과

- 성과 1
- 성과 2
- 성과 3

## 완료된 PLAN

| 파일          | 제목 | 요약     |
| ------------- | ---- | -------- |
| planMMDDNN.md | 제목 | 1줄 요약 |

## 변경된 주요 파일

- /path/to/file1
- /path/to/file2

## 기술적 개선사항

- 개선사항 1
- 개선사항 2

## 다음 Sprint 계획

- 계획 1
- 계획 2

## 잔여 이슈 (Technical Debt)

- 이슈 1
- 이슈 2
```

## 실행 순서

### Phase 1: 사전 확인
1. main 브랜치에 모든 변경사항 머지 완료 여부 확인
2. 잔여 feature 브랜치 확인
3. 전체 테스트 통과 여부 확인
4. 사용자에게 사전 확인 체크리스트 제시

### Phase 2: Sprint 번호 결정
1. `/docs/sprints/` 폴더의 기존 sprint 폴더 확인
2. 가장 최신 Sprint 번호 파악
3. 신규 Sprint 번호 결정 (N+1)

```bash
ls /docs/sprints/
# sprint1, sprint2 존재 -> 신규: sprint3
```

### Phase 3: Sprint 요약 문서 생성
1. 현재 날짜(Asia/Tokyo) 확인
2. Sprint 요약 문서 작성
3. `/docs/current_sprint/`의 모든 PLAN 파일 분석
4. 주요 성과, 변경 파일, 기술적 개선사항 정리
5. `/docs/sprints/sprintMMDDNN.md` 생성

### Phase 4: 문서 아카이브
1. 신규 Sprint 폴더 생성

```bash
mkdir -p /docs/sprints/sprintN
```

2. current_sprint 문서 이동

```bash
# PLAN 파일 이동
mv /docs/current_sprint/plan*.md /docs/sprints/sprintN/

# saveTemp 파일 이동
mv /docs/current_sprint/saveTemp*.md /docs/sprints/sprintN/

# security 파일 이동 (해당 시)
mv /docs/current_sprint/security*.md /docs/sprints/sprintN/

# refactoring 파일 이동 (해당 시)
mv /docs/current_sprint/refactoring*.md /docs/sprints/sprintN/
```

3. planning 폴더 문서 이동 (해당 시)

```bash
mv /docs/planning/*.md /docs/sprints/sprintN/
```

### Phase 5: 프로젝트 문서 업데이트
1. **README.md** 업데이트
   - Sprint 정보 추가
   - 문서 링크 및 요약 작성
   - `init_readme.md` 참고

2. **TODO.md** 정리
   - 완료 항목(`[x]`) 제거
   - 신규 Technical Debt 추가
   - 우선순위 재조정

3. **ARCHITECTURE.md** 확인
   - 구조 변경사항 반영 여부 확인
   - 필요 시 업데이트

4. **STRUCTURE 문서** 최종 확인
   - `/docs/BACKEND_STRUCTURE.md` (해당 시)
   - `/docs/FRONTEND_STRUCTURE.md` (해당 시)
   - taskLog의 커밋 로그 기반 변경사항 반영

### Phase 6: 커밋 및 머지
1. 변경사항 스테이징

```bash
git add .
```

2. 커밋 생성

```bash
git commit -m "docs: close Sprint N"
```

3. 커밋 로그 작성 (`/docs/taskLog/commitMMDDNN.md`)
4. main 브랜치에 머지 (필요 시)

### Phase 7: 검증 및 보고
1. `/docs/current_sprint/` 폴더 비어있는지 확인
2. Sprint 폴더 구조 확인
3. 사용자에게 결과 보고

## 주의사항

- 파일 이동 전 반드시 사전 확인 체크리스트를 완료합니다
- 잔여 feature 브랜치가 있으면 사용자에게 확인을 요청합니다
- 테스트가 실패한 경우 Sprint 종료를 진행하지 않습니다
- 문서 이동 시 파일이 누락되지 않도록 주의합니다
- Sprint 요약 문서는 반드시 `sprintMMDDNN.md` 형식을 따릅니다
- main 브랜치 머지는 사용자 확인 후 진행합니다

## 사전 확인 체크리스트

```markdown
- [ ] main 브랜치에 모든 변경사항 머지 완료
- [ ] 잔여 feature 브랜치 없음
- [ ] 전체 테스트 통과
- [ ] 모든 PLAN 작업 완료
- [ ] 문서 업데이트 완료
```

## 최종 구조

Sprint 종료 후 디렉토리 구조:

```text
docs/
├── current_sprint/          # 비어있음 (다음 Sprint 준비 완료)
├── taskLog/
│   └── commit*.md           # 커밋 로그 유지
└── sprints/
    ├── sprintN/
    │   ├── plan*.md
    │   ├── saveTemp*.md
    │   ├── security*.md
    │   └── refactoring*.md
    └── sprintMMDDNN.md      # Sprint 요약 문서
```

## 참고

- [AGENTS Rules](../CLAUDE.md) - 전체 규칙 문서
- [Sprint Structure](../CLAUDE.md#5-sprint-structure)
- [문서 구조](../CLAUDE.md#2-문서-구조)
