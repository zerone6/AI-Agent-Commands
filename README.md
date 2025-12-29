# Claude / Copilot Commands – Central Repository

이 레포지토리는 **Claude와 GitHub Copilot에서 공통으로 사용할 프롬프트(commands)와 에이전트 규칙을 중앙에서 관리**하기 위한 저장소입니다.

- Claude: 전역 설정 (`~/.claude`)
- GitHub Copilot: 레포지토리 단위 설정 (`.github/`)

이 저장소 하나를 기준으로, **여러 프로젝트에 동일한 Copilot 규칙을 심볼릭 링크로 배포**할 수 있습니다.

---

## Repository Structure

```
ClaudeCommands/
├─ CLAUDE.md                   # Claude 전역 Agent / Rule (원본)
├─ commands/                   # 프롬프트 원본
│  ├─ plan/
│  │  ├─ execute_order.md      # sprint에 위치하는 최신 order파일을 실행
│  │  ├─ finish_order.md       # 단일 order 파일의 종료 문서 정리하고, TODO에 과제 기록
│  │  ├─ review_order.md       # 외부에서 가지고온 order 문서를 리뷰함. Plugin의 AI는 질의를 하면서 order파일을 만들어달라고 오더하면 Agent파일의 내용에 따라서 오더 파일 생성
│  │  └─ save_temp.md          # 오더 파일 작업중 완료되지 못하고 중단 할때 상황을 저장하기 위한 커맨드
│  ├─ release/
│  │  ├─ refactor.md           # 프로젝트 구조를 리팩터링 하기 위한 커맨드
│  │  └─ release.md            # 프로젝트를 실서비스에 릴리즈할때의 커맨드
│  └─ doc/
│     ├─ commit_log.md         # 단일 커밋 로그 작성
│     └─ finishi_sprint        # 하나의 sprint 완료
├─ install_command.sh          # Copilot 설정 배포 스크립트
├─ CLAUDE.md                   # Claude 전역 Agent 파일
└─ README.md
```

### 원칙
- **원본(Source of Truth)**은 이 레포에만 존재
- 각 프로젝트에는 **파일을 복사하지 않고 심볼릭 링크만 생성**
- Copilot 규칙은 **프로젝트 레포 기준**으로 적용

---

## 적용 대상

### Claude
- `CLAUDE.md`
- `commands/**`

→ 전역 경로 `~/.claude` 에서 인식

### GitHub Copilot
- `.github/copilot-instructions.md`
- `.github/prompts/*.prompt.md`

→ **각 프로젝트 레포 단위로 인식**

---

## 사용 방법

### 1. 중앙 레포 클론
```bash
git clone git@github.com:YOUR_ID/ClaudeCommands.git ~/Github/ClaudeCommands
cd ~/Github/ClaudeCommands
chmod +x install_command.sh
```

---

### 2. 특정 프로젝트에 Copilot 규칙 적용
```bash
./install_command.sh ~/GitHub/your_project
```

또는 어디서든:
```bash
bash ~/Github/ClaudeCommands/install_command.sh ~/GitHub/your_project
```

---

### 3. 생성되는 결과 예시

```
your_project/
└─ .github/
   ├─ copilot-instructions.md
   │   └─ (symlink → ClaudeCommands/CLAUDE.md)
   └─ prompts/
      ├─ plan__review.prompt.md
      │   └─ (symlink → ClaudeCommands/commands/plan/review.md)
      ├─ release__deploy.prompt.md
      └─ doc__design.prompt.md
```

- **폴더명 + 파일명**을 조합한 형태로 Copilot 프롬프트 생성
- Copilot이 요구하는 flat 구조를 자동으로 만족

---

## 스크립트 옵션

### --force
기존 파일/심볼릭 링크가 있어도 **강제로 덮어쓰기**
```bash
./install_command.sh --force ~/GitHub/your_project
```

### --prune
원본 파일이 삭제되어 **깨진 Copilot 프롬프트 링크를 정리**
```bash
./install_command.sh --prune ~/GitHub/your_project
```

### 조합 사용
```bash
./install_command.sh --force --prune ~/GitHub/your_project
```

---

## 프롬프트 추가 / 변경 워크플로우

1. `ClaudeCommands/commands/` 아래에 `.md` 파일 추가 또는 수정
2. 커밋
3. 각 프로젝트에서 다시 실행

```bash
./install_command.sh ~/GitHub/your_project
```

→ 새 프롬프트만 자동으로 링크 추가됨  
→ 기존 링크는 기본적으로 유지

---

## 주의사항

- 대상 프로젝트 경로는 반드시 **Git repository 루트**여야 합니다.
- `.github/` 디렉터리는 Git에 포함되므로 팀 프로젝트라면 동료에게도 동일 규칙이 적용됩니다.
- 이 레포에는 **비밀 값(API Key, Token 등)을 절대 포함하지 마세요.**

---

## 요약

- 프롬프트/Agent는 **이 레포에서만 관리**
- 프로젝트에는 **심볼릭 링크만 배포**
- Claude / Copilot을 동시에 만족하는 구조
- 새 PC / 새 프로젝트에서도 재현성 보장

---

## One-liner

```bash
bash ~/Github/ClaudeCommands/install_command.sh ~/GitHub/your_project
```
