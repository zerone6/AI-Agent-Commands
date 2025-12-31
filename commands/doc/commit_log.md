---
agent: agent
description: "commit log 작성 순서에 따라서 작성합니다."
---

다음과 같이 커밋 로그를 작성한다.

▼구체적인 순서

---

## 1. 커밋 로그 작성

### 1.1 트리거

사용자가 커밋 로그 작성을 요청할 때

### 1.2 작성 절차

1. `git diff --staged` 및 변경 파일 내용 검토
2. 아래 경로에 커밋 로그 파일 작성

### 1.3 파일 경로

```
/docs/taskLog/commitMMDDNN.md
```

| 요소 | 설명 |
|------|------|
| MMDD | 월일 (Asia/Tokyo 기준) |
| NN | 당일 순번 (01부터) |
| 예시 | `commit121401.md` |

> 폴더가 없으면 생성한다.

### 1.4 로그 형식

```
<type>: <subject>

<body>

Changes:
- <change 1>
- <change 2>
```

**Type 종류:** `feat`, `fix`, `refactor`, `docs`, `style`, `test`, `chore`, `wip`

---
