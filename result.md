# Commands 검토 보고서

## 1. 각 명령어 검토 (적절성 및 개선 의견)

### 1.1 plan/ 카테고리 (계획)

#### make_plan.md

| 항목 | 평가 |
|------|------|
| 적절성 | 양호 - ORDER 문서 구조가 포괄적임 |
| 장점 | 상세한 템플릿, 명확한 Phase 구조, 테스트 섹션 분리 |
| 문제점 | ~~description 메타데이터가 잘못됨~~ ✅ 수정 완료 |
| 개선안 | 의존성 확인 섹션 추가 (예: 필요한 패키지) |

#### review_order.md

| 항목 | 평가 |
|------|------|
| 적절성 | 양호 - 외부 문서 분석 후 ORDER 생성 |
| 장점 | 아키텍처 문서 참조, 폴더 구조 고려 |
| 문제점 | ~~make_plan.md와 목적 중복~~ ✅ 역할 분리 완료 |
| 개선안 | - |

> **역할 정의**: 외부 문서(Jira, 기획서, 슬랙 등) → 분석 → make_plan 형식 ORDER 생성

### 1.2 dev/ 카테고리 (개발 실행) - plan/에서 분리됨

#### execute_plan.md

| 항목 | 평가 |
|------|------|
| 적절성 | 우수 - 명확한 실행 흐름 |
| 장점 | 사전 확인, 실행 모드, 실패 처리 |
| 문제점 | ~~description 메타데이터가 잘못됨~~ ✅ 수정 완료 |
| 개선안 | 롤백 절차 참조 추가 |

#### save_temp.md

| 항목 | 평가 |
|------|------|
| 적절성 | 우수 - 장기 작업에 필수적 |
| 장점 | 상세한 상태 캡처, 명확한 재개 프로세스 |
| 문제점 | 특별한 문제 없음 |
| 개선안 | 중단 전 브랜치 push 옵션 추가 (백업용) |

#### finish_order.md

| 항목 | 평가 |
|------|------|
| 적절성 | 우수 - 포괄적인 완료 프로세스 |
| 장점 | STRUCTURE 업데이트, TODO 관리, 커밋 절차 |
| 문제점 | 특별한 문제 없음 |
| 개선안 | 직접 머지 대신 PR 생성 옵션 추가 |

### 1.3 doc/ 카테고리 (문서화)

#### commit_log.md

| 항목 | 평가 |
|------|------|
| 적절성 | 양호 - 표준화된 커밋 문서화 |
| 장점 | 명확한 형식, conventional commit 타입 |
| 문제점 | 실제 git commit 동작과 분리되어 있음 |
| 개선안 | git commit 명령과 통합 고려, breaking change 표기법 추가 |

#### finish_sprint.md

| 항목 | 평가 |
|------|------|
| 적절성 | 우수 - 완전한 Sprint 종료 프로세스 |
| 장점 | 아카이브 구조, 요약 템플릿, 체크리스트 |
| 문제점 | 특별한 문제 없음 |
| 개선안 | Sprint 회고(Retrospective) 섹션 템플릿 추가 |

### 1.4 quality/ 카테고리 (품질 보증) - release/에서 이름 변경됨

#### l10n.md

| 항목 | 평가 |
|------|------|
| 적절성 | 양호 - 포괄적인 i18n 체크리스트 |
| 장점 | 명확한 대상/제외 대상, 네이밍 규칙 |
| 문제점 | ~~카테고리 부적합~~ ✅ quality/로 이동 완료 |
| 개선안 | 누락된 번역 탐지 명령어 예시 추가 |

#### refactor.md

| 항목 | 평가 |
|------|------|
| 적절성 | 양호 - 상세한 리팩토링 가이드라인 |
| 장점 | 구체적인 기준 (300/500줄), 품질 체크리스트 |
| 문제점 | ~~카테고리 부적합~~ ✅ quality/로 이동 완료 |
| 개선안 | 자동화 도구 권장 추가 (ESLint, dead code 탐지) |

---

## 2. 카테고리 분류 검토

### ✅ 적용된 구조

```text
commands/
├── plan/           # 계획
│   ├── make_plan.md
│   └── review_order.md
│
├── dev/            # 개발 실행 (plan/에서 분리)
│   ├── execute_plan.md
│   ├── save_temp.md
│   └── finish_order.md
│
├── quality/        # 품질 보증 (release/에서 변경)
│   ├── refactor.md
│   └── l10n.md
│
└── doc/            # 문서화
    ├── commit_log.md
    └── finish_sprint.md
```

### 해결된 문제점

1. ~~**plan/이 과부하됨**~~: ✅ dev/ 폴더로 실행 명령어 분리 완료
2. ~~**release/ 이름이 부적절함**~~: ✅ quality/로 이름 변경 완료
3. **누락된 카테고리**: 추후 code_review, test_coverage 등 추가 가능

### 향후 확장 가능 구조

```text
commands/
└── release/        # 실제 릴리즈 작업 (추후 추가 가능)
    ├── changelog.md
    ├── version_bump.md
    └── deploy.md
```

---

## 3. README.md 초안 (Commands 섹션)

### 초안 내용

```markdown
## Commands

개발 워크플로우 단계별로 구성된 AI Agent 명령어입니다.

### 디렉토리 구조

| 폴더 | 목적 | 사용 시점 |
|------|------|----------|
| `plan/` | 작업 계획 | ORDER 생성 및 검토 |
| `dev/` | 개발 실행 | ORDER 실행, 중단, 완료 |
| `quality/` | 품질 보증 | 리팩토링, 다국어 지원 |
| `doc/` | 문서화 | 커밋 로그, Sprint 요약 |

### 명령어 참조

#### plan/ - 계획

| 명령어 | 트리거 | 설명 |
|--------|--------|------|
| `make_plan` | 신규 기능 요청 | 구현 계획이 포함된 ORDER 문서 작성 |
| `review_order` | 외부 ORDER 존재 | 기존 ORDER 초안 검토 및 정제 |

#### dev/ - 개발 실행

| 명령어 | 트리거 | 설명 |
|--------|--------|------|
| `execute_plan` | ORDER 승인됨 | ORDER Phase에 따라 구현 |
| `save_temp` | 작업 중단 | 나중에 재개를 위해 현재 상태 저장 |
| `finish_order` | 구현 완료 | 문서화 완료 및 머지 |

#### quality/ - 품질 보증

| 명령어 | 트리거 | 설명 |
|--------|--------|------|
| `refactor` | 코드 정리 필요 | 미사용 코드 제거, 구조 최적화 |
| `l10n` | i18n 점검 필요 | UI 텍스트에 다국어 지원 적용 |

#### doc/ - 문서화

| 명령어 | 트리거 | 설명 |
|--------|--------|------|
| `commit_log` | 커밋 전 | 표준화된 커밋 메시지 생성 |
| `finish_sprint` | Sprint 종료 | Sprint 문서 아카이브 및 요약 생성 |

### 워크플로우 다이어그램

\`\`\`text
[계획 단계]
  plan:make_plan / plan:review_order
         |
         v
[개발 단계]
  dev:execute_plan <---> dev:save_temp (중단 시)
         |
         v
[완료 단계]
  dev:finish_order --> doc:commit_log
         |
         v
[품질 단계]
  quality:refactor / quality:l10n
         |
         v
[Sprint 종료]
  doc:finish_sprint
\`\`\`

### 사용 예시

\`\`\`bash
# 신규 ORDER 생성
/plan:make_plan

# 승인된 ORDER 실행
/dev:execute_plan

# 작업 저장 및 중단
/dev:save_temp

# ORDER 완료
/dev:finish_order

# 리팩토링
/quality:refactor

# 커밋 로그 생성
/doc:commit_log

# Sprint 종료
/doc:finish_sprint
\`\`\`
```

---

## 4. 권장 사항 요약

### 높은 우선순위 ✅ 완료

1. ~~**metadata description 수정**: make_plan.md, execute_plan.md~~ ✅ 완료
2. ~~**make_plan vs review_order 사용 구분 명확화**~~ ✅ 완료
3. ~~**release/를 quality/로 이름 변경**~~ ✅ 완료
4. ~~**plan/에서 dev/ 분리**~~ ✅ 완료

### 중간 우선순위

1. finish_order.md에 PR 생성 워크플로우 추가
2. finish_sprint.md에 Sprint 회고 템플릿 추가
3. refactor.md에 자동화 도구 예시 추가

### 낮은 우선순위 (미래)

1. 실제 릴리즈 명령어 생성 (changelog, version_bump, deploy)
2. code_review 명령어 추가
3. test_coverage 명령어 추가
