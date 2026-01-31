---
agent: agent
description: "PLAN 완료 후 문서화 및 브랜치 정리"
---

PLAN 실행 완료 후, 문서화 및 브랜치 정리를 수행하여 작업을 종료합니다.

## 목적

execute_plan으로 구현이 완료된 후, 프로젝트 문서를 업데이트하고, TODO를 정리하며, 최종 커밋을 생성하여 작업을 마무리합니다.

## 트리거

- execute_plan 완료 후 사용자가 작업 종료를 요청할 때
- 모든 테스트(자동/수동)가 통과한 후
- 예시: "작업을 마무리해줘", "finish_plan 실행해줘"

## 결과물

### 파일 경로

다음 문서들이 업데이트됩니다:

```text
/docs/current_sprint/planMMDDNN.md  # 최종 정리
/docs/BACKEND_STRUCTURE.md           # Backend 변경 시
/docs/FRONTEND_STRUCTURE.md          # Frontend 변경 시
/docs/TODO.md                        # TODO 정리
/docs/taskLog/commitMMDDNN.md        # 커밋 로그 (자동 생성)
```

> 커밋 로그는 finish_plan 실행 시 자동으로 생성됩니다.

## 실행 순서

### Phase 1: 사전 확인

다음 항목 확인:

- [ ] 모든 Phase 구현 완료
- [ ] 자동화 테스트 전체 통과
- [ ] 사용자 수동 테스트 완료 확인
- [ ] PLAN 파일에 결과 기록 완료

### Phase 2: PLAN 파일 최종 정리

1. PLAN 파일 검토
   - 계획과 다르게 구현된 부분 확인
   - 추가/삭제된 파일 목록 확인
   - 변경된 설계 의도 확인

2. PLAN 파일 업데이트
   - "4.2 변경 파일" 섹션 실제 구현에 맞춰 수정
   - "구현 결과" 섹션 완성도 확인
   - 차이점이 있으면 명시

### Phase 3: STRUCTURE 문서 업데이트

`/docs/` 디렉토리 내 해당 파일에 변경사항 반영:

| 파일                    | 반영 내용                 |
| ----------------------- | ------------------------- |
| `BACKEND_STRUCTURE.md`  | API, 서비스, 모델 변경    |
| `FRONTEND_STRUCTURE.md` | 컴포넌트, 페이지, 훅 변경 |
| `BACKEND_API.md`        | API 엔드포인트 추가/변경  |
| `FRONTEND_ROUTES.md`    | 라우트 추가/변경          |

**반영 대상:**
- 새 파일/폴더 추가
- 파일 삭제
- 주요 함수/컴포넌트/API 추가
- 아키텍처 변경사항

### Phase 4: TODO 정리

#### 4.1 완료 항목 체크

`/docs/TODO.md`에서 이번 작업으로 완료된 항목을 `[x]`로 표시

#### 4.2 신규 항목 추가

이번 작업 중 발견된 신규 TODO를 `/docs/TODO.md`에 추가:
- 리팩토링 필요 사항
- 기술 부채
- 성능 개선 아이디어
- 추가 테스트 필요 항목

#### 4.3 PLAN 파일에 TODO 처리 내역 기록

PLAN 파일 하단에 섹션 추가:

```markdown
## TODO 처리 내역

### 완료
- [x] 항목 1
- [x] 항목 2

### TODO.md로 이동
- [ ] 신규 항목 1: 설명
- [ ] 신규 항목 2: 설명
```

### Phase 5: Git 커밋

#### 5.1 변경 파일 확인

```bash
git status
git diff
```

#### 5.2 커밋 생성

```bash
git add <files>
git commit -m "$(cat <<'EOF'
<type>: <subject>

<body>

Changes:
- <change 1>
- <change 2>

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
EOF
)"
```

**커밋 메시지 규칙:**
- Type: feat, fix, refactor, docs 등 ([CLAUDE.md 참조](../../CLAUDE.md#82-type-종류))
- Subject: 50자 이내, 동사 원형 시작
- Body: 상세 설명 (선택)
- Changes: 주요 변경 사항 목록

#### 5.3 커밋 실패 시 (pre-commit hook)

- 즉시 중단, 원인 분석
- 문제 수정 후 **새로운 커밋** 생성 (--amend 사용 금지)
- 실패 원인 사용자에게 보고

### Phase 6: 커밋 로그 작성

`/docs/taskLog/commitMMDDNN.md`에 커밋 로그 자동 작성:

1. 파일명 결정
   - 현재 날짜 기준 (Asia/Tokyo)
   - `/docs/taskLog/` 폴더 내 동일 날짜 파일 확인
   - 순번(NN) 결정

2. 커밋 로그 문서 작성
   ```markdown
   <type>: <subject>

   <body>

   Changes:
   - <change 1>
   - <change 2>

   Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
   ```

> 커밋 메시지와 동일한 내용을 문서로 저장합니다.
> 파일명 규칙: [CLAUDE.md - 파일 네이밍 규칙](../../CLAUDE.md#3-파일-네이밍-규칙)

### Phase 7: 브랜치 상태 확인

```bash
git log -1
git status
```

- 커밋 성공 확인
- 클린 상태 확인
- 사용자에게 완료 보고

## 주의사항

- **문서 우선**: 코드 변경과 문서 업데이트는 동시에 커밋
- **커밋 1회**: finish_plan에서 1회만 커밋 (WIP 커밋 제외)
- **PLAN 정확성**: PLAN은 실제 구현 결과를 정확히 반영
- **TODO 누락 방지**: 발견된 기술 부채는 반드시 TODO.md에 기록
- **Hook 실패**: pre-commit hook 실패 시 새 커밋 생성 (amend 금지)
- **민감 파일**: .env, credentials 등 커밋 금지 확인
- **커밋 로그**: Phase 6에서 자동으로 생성되므로 별도 작업 불필요

## Git 안전 규칙

[CLAUDE.md - Git 커밋 규칙](../../CLAUDE.md#8-git-커밋-규칙) 준수:
- 특정 파일만 add (git add -A 지양)
- Hook 우회 금지 (--no-verify 사용 금지)
- Force push 금지
- 파일별 add로 민감 파일 방지

## 다음 단계

finish_plan 완료 후:

1. **PR 생성** (해당 시)
   - 사용자 요청 시 PR 생성
   - PLAN 내용 기반 PR 설명 작성

2. **Sprint 계속** (추가 작업)
   - 다음 작업 진행
   - make_plan으로 새 PLAN 작성

3. **Sprint 종료** (작업 완료)
   - `finish_sprint` 커맨드로 Sprint 정리
   - 문서 아카이브

## 커밋 메시지 형식

```bash
feat: add user authentication module

Implement JWT-based authentication with login/logout functionality

Changes:
- Add AuthService with JWT token generation
- Create Login/Logout API endpoints
- Add authentication middleware
- Update user routes with auth guards

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```
