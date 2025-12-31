# AI Agent Commands

AI Agent를 위한 개발 워크플로우 명령어 중앙 관리 저장소

---

## 1. 개요

### 목적

이 레포지토리는 **AI Agent (Claude, Copilot, Gemini)가 일관된 개발 워크플로우를 수행하도록 명령어를 중앙에서 관리**합니다.

### 지원 도구

| 도구 | 설정 위치 | 적용 범위 |
|------|-----------|-----------|
| Claude | `~/.claude/` | 전역 |
| Gemini | `~/.gemini/` | 전역 |
| GitHub Copilot | `.github/` | 프로젝트별 |

### 핵심 개념

| 용어 | 의미 | 예시 |
|------|------|------|
| **ORDER** | 사용자의 요청/명령 | "로그인 기능 추가해줘" |
| **PLAN** | AI가 분석한 작업 계획서 | `planMMDDNN.md` |

---

## 2. 워크플로우

### 전체 흐름

```text
                    +===============================+
                    ||          SPRINT             ||
                    +===============================+
                    |                               |
                    |  +-------------------------+  |
                    |  |  ORDER #1 -> PLAN #1    |  |
[ORDER] ──────────────>|  plan/make_plan         |  |
                    |  |  plan/review_order      |  |
                    |  +------------+------------+  |
                    |               |               |
                    |               v               |
                    |  +-------------------------+  |
                    |  |  dev/execute_plan       |  |
                    |  |  (Pause: save_temp)     |  |
                    |  +------------+------------+  |
                    |               |               |
                    |               v               |
                    |  +-------------------------+  |
                    |  |  dev/finish_order       |  |
                    |  |  doc/commit_log         |  |
                    |  +------------+------------+  |
                    |               |               |
                    |  (ORDER #2, #3... iteration)  |
                    |               |               |
                    +---------------+---------------+
                                    |
                                    v
                    +-------------------------------+
                    |  quality/security             |
                    |  quality/refactor             |
                    |  quality/l10n                 |
                    +---------------+---------------+
                                    |
                                    v
                    +-------------------------------+
                    |  doc/finish_sprint            |
                    | (PLAN Archive, Finish Sprint) |
                    +-------------------------------+
```

### 워크플로우 단계

| 단계 | 설명 | 반복 |
|------|------|------|
| **1. 계획-개발 사이클** | ORDER 접수 -> PLAN 작성 -> 구현 -> 완료 | N회 반복 |
| **2. 품질 점검** | 코드 리팩토링, 다국어 점검 | Sprint 내 필요 시 |
| **3. Sprint 종료** | 모든 PLAN 아카이브, 요약 문서 생성 | Sprint 당 1회 |

### 폴더 구조

| 폴더 | 역할 | 명령어 |
|------|------|--------|
| `plan/` | 계획 수립 | make_plan, review_order |
| `dev/` | 개발 실행 | execute_plan, save_temp, finish_order |
| `quality/` | 품질 보증 | security, refactor, l10n |
| `doc/` | 문서화 | commit_log, finish_sprint |

---

## 3. 명령어 상세

### plan/ - 계획

#### make_plan

| 항목 | 내용 |
|------|------|
| 트리거 | 사용자가 기능 구현을 요청할 때 |
| 입력 | 사용자의 요청 (ORDER) |
| 출력 | `/docs/current_sprint/planMMDDNN.md` |
| 설명 | 요청을 분석하여 Phase별 구현 계획 작성 |

#### review_order

| 항목 | 내용 |
|------|------|
| 트리거 | 외부 문서가 첨부되었을 때 |
| 입력 | Jira 티켓, 기획서, 슬랙 메시지 등 |
| 출력 | `/docs/current_sprint/planMMDDNN.md` |
| 설명 | 외부 문서를 분석하여 make_plan 형식의 PLAN 생성 |

### dev/ - 개발 실행

#### execute_plan

| 항목 | 내용 |
|------|------|
| 트리거 | PLAN이 사용자 승인된 후 |
| 입력 | 승인된 PLAN 파일 |
| 출력 | 구현된 코드, 업데이트된 PLAN |
| 설명 | Phase별로 코드 구현 수행 |

#### save_temp

| 항목 | 내용 |
|------|------|
| 트리거 | 작업 중단이 필요할 때 |
| 입력 | 현재 진행 상태 |
| 출력 | `/docs/current_sprint/SAVETEMP_MMDDNN.md` |
| 설명 | 현재 상태 저장, 나중에 재개 가능 |

#### finish_order

| 항목 | 내용 |
|------|------|
| 트리거 | 모든 Phase 구현 완료 시 |
| 입력 | 완료된 PLAN |
| 출력 | 커밋, 브랜치 머지 |
| 설명 | 문서 정리, TODO 업데이트, 브랜치 정리 |

### quality/ - 품질 보증

#### security

| 항목 | 내용 |
|------|------|
| 트리거 | 릴리즈 전, 인증/권한 코드 변경 후 |
| 출력 | `/docs/current_sprint/SECURITY_MMDDNN.md` |
| 설명 | OWASP Top 10 기반 보안 취약점 검토 및 수정 |

#### refactor

| 항목 | 내용 |
|------|------|
| 트리거 | 코드 정리가 필요할 때 |
| 설명 | 미사용 코드 제거, 파일 분리 (300줄+), 구조 최적화 |

#### l10n

| 항목 | 내용 |
|------|------|
| 트리거 | 다국어 지원 점검이 필요할 때 |
| 설명 | 하드코딩된 텍스트를 번역 키로 교체 |

### doc/ - 문서화

#### commit_log

| 항목 | 내용 |
|------|------|
| 트리거 | 커밋 전 |
| 출력 | `/docs/taskLog/commitMMDDNN.md` |
| 설명 | Conventional Commit 형식의 로그 작성 |

#### finish_sprint

| 항목 | 내용 |
|------|------|
| 트리거 | Sprint 종료 시 |
| 설명 | PLAN 파일 아카이브, Sprint 요약 문서 생성 |

---

## 4. 사용 예시

### 신규 기능 개발

```bash
# 1. 사용자: "로그인 기능을 추가해줘"
/plan:make_plan

# 2. AI가 PLAN 작성 후 사용자 검토
# 3. 승인 후 실행
/dev:execute_plan

# 4. 구현 완료 후
/dev:finish_order

# 5. 커밋
/doc:commit_log
```

### 외부 기획서로 작업

```bash
# 1. 기획서.pdf 첨부 후
/plan:review_order

# 2. 생성된 PLAN 검토 및 승인
# 3. 실행
/dev:execute_plan
```

### 작업 중단 및 재개

```bash
# 중단 시
/dev:save_temp

# 재개 시: PLAN + SAVETEMP 파일과 함께
/dev:execute_plan
```

### Sprint 종료

```bash
# 품질 점검
/quality:refactor

# Sprint 마무리
/doc:finish_sprint
```

---

## 5. 설치 및 배포

### 레포지토리 구조

```text
ClaudeCommands/
├─ AGENTS.md                       # 공통 Agent 규칙
├─ CLAUDE.origin.md                # Claude 특화 지침
├─ copilot-instructions.origin.md  # Copilot 특화 지침
├─ GEMINI.origin.md                # Gemini 특화 지침
├─ commands/                       # 명령어 원본
│  ├─ plan/
│  ├─ dev/
│  ├─ quality/
│  └─ doc/
├─ install_command.sh              # 배포 스크립트
└─ README.md
```

### 설치

```bash
git clone git@github.com:YOUR_ID/ClaudeCommands.git ~/Github/ClaudeCommands
cd ~/Github/ClaudeCommands
chmod +x install_command.sh
```

### 배포

#### 기본 (Claude + Gemini 전역 설치)

```bash
./install_command.sh
```

#### Copilot (프로젝트별)

```bash
./install_command.sh --copilot ~/GitHub/your_project
```

#### 옵션

| 옵션 | 설명 |
|------|------|
| `--force` | 기존 파일 덮어쓰기 |
| `--prune` | 깨진 심볼릭 링크 정리 |
| `--claude` | Claude만 설치 |
| `--gemini` | Gemini만 설치 |

### 배포 결과

```text
~/.claude/
├─ CLAUDE.md
└─ commands/ -> (symlink)

~/.gemini/
├─ GEMINI.md
└─ commands/ -> (symlink)

your_project/.github/
├─ copilot-instructions.md
└─ prompts/
   ├─ plan__make_plan.prompt.md
   ├─ dev__execute_plan.prompt.md
   └─ ...
```

---

## 부록: 용어 정의

| 용어 | 정의 |
|------|------|
| ORDER | 사용자의 원본 요청. 구두 명령, 외부 문서 등 |
| PLAN | AI가 ORDER를 분석하여 작성한 구조화된 작업 계획서 |
| Phase | PLAN 내의 작업 단계 |
| Sprint | 여러 PLAN을 포함하는 작업 주기 (작업량 기반, 시간 기반 아님) |
