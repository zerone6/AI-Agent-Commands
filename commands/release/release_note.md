---
agent: agent
description: "릴리즈 노트 생성"
---

버전 릴리즈 시 변경 사항을 정리한 릴리즈 노트를 생성한다. Git 커밋 로그와 PLAN 문서를 분석하여 체계적인 릴리즈 문서를 작성한다.

## 목적

새 버전의 변경 사항을 사용자가 이해하기 쉽게 문서화한다. 기능 추가, 버그 수정, Breaking Changes 등을 분류하여 제공하며, 업그레이드 가이드를 포함한다.

## 트리거

- 새 버전 배포 전
- Sprint 종료 시 릴리즈
- 사용자가 릴리즈 노트 작성을 요청할 때
- GitHub Release 생성 전

## 결과물

### 파일 경로

```text
/docs/releases/releaseMMDDNN.md
```

| 요소 | 설명                   |
| ---- | ---------------------- |
| MM   | 월 (01-12)             |
| DD   | 일 (01-31)             |
| NN   | 당일 순번 (01부터)     |
| 예시 | `release013001.md`     |

> `/docs/releases/` 폴더가 없으면 자동 생성합니다.

### 파일 형식

```markdown
# Release v1.2.3

> 릴리즈 일자: YYYY-MM-DD

## 개요

(이번 릴리즈의 주요 변경 사항 1-2문장 요약)

## Breaking Changes

> 이전 버전과 호환되지 않는 변경 사항

- (해당 시 작성)

## New Features

- **기능명**: 기능 설명 (#이슈번호)
  - 세부 내용 1
  - 세부 내용 2

## Bug Fixes

- **수정 내용**: 문제 및 해결 방법 (#이슈번호)

## Performance Improvements

- **개선 내용**: 개선 효과

## Code Refactoring

- **리팩토링 내용**: 변경 이유

## Security

- **보안 패치**: 수정 내용

## Documentation

- 문서 업데이트 내용

## Maintenance

- 유지보수 작업 내용

---

## 업그레이드 가이드

### 필수 조치

(Breaking Changes가 있는 경우 마이그레이션 방법)

```bash
# 예시: 의존성 업데이트
npm install
```

### 환경 변수 변경

| 변수명 | 변경 내용 |
|--------|----------|
| (해당 시 작성) | |

---

## 관련 링크

- [전체 변경 로그](https://github.com/org/repo/compare/v1.2.2...v1.2.3)
- [관련 Sprint](../sprints/sprintMMDDNN.md)
- [마일스톤](https://github.com/org/repo/milestone/N)

---

## 기여자

(이번 릴리즈에 기여한 사람들)
```

## 실행 순서

### Phase 1: 변경 사항 수집

1. 이전 릴리즈 태그 확인

```bash
git describe --tags --abbrev=0
```

2. 커밋 로그 수집

```bash
git log <previous-tag>..HEAD --oneline
```

3. 관련 PLAN 파일 확인
   - `/docs/sprints/` 완료된 PLAN
   - `/docs/taskLog/` 커밋 로그

4. 변경 파일 목록

```bash
git diff --name-only <previous-tag>..HEAD
```

### Phase 2: 변경 사항 분류

커밋 메시지 타입별 분류:

| 타입 | 섹션명 | 설명 |
|------|--------|------|
| feat | New Features | 새로운 기능 추가 |
| fix | Bug Fixes | 버그 수정 |
| perf | Performance Improvements | 성능 개선 |
| refactor | Code Refactoring | 코드 리팩토링 |
| docs | Documentation | 문서 변경 |
| style | Styling | 코드 스타일 변경 |
| test | Tests | 테스트 추가/수정 |
| chore | Maintenance | 유지보수 작업 |
| security | Security | 보안 관련 수정 |
| breaking | Breaking Changes | 호환성 깨지는 변경 |

### Phase 3: 릴리즈 노트 작성

1. 파일 생성

```text
/docs/releases/releaseMMDDNN.md
```

2. 개요 작성
   - 이번 릴리즈의 핵심 변경 사항 1-2문장 요약
   - 릴리즈 일자 명시

3. Breaking Changes 우선 기술 (있는 경우)
   - 호환성을 깨뜨리는 변경 사항
   - 업그레이드 시 필수 조치 사항

4. 변경 사항 분류별 작성
   - 각 섹션별로 커밋 로그 및 PLAN 내용 정리
   - 이슈/PR 번호 링크 포함
   - 사용자 관점에서 이해하기 쉽게 작성

5. 업그레이드 가이드 작성
   - Breaking Changes가 있는 경우 마이그레이션 방법
   - 환경 변수 변경 사항
   - 의존성 업데이트 방법

6. 관련 링크 추가
   - GitHub 비교 링크
   - 관련 Sprint 문서
   - 마일스톤 링크

### Phase 4: 검증 및 확정

1. 내용 검토
   - 모든 주요 변경 사항 포함 여부
   - Breaking Changes 누락 없는지
   - 이슈/PR 번호 정확성

2. 사용자 확인 요청
   - 릴리즈 노트 초안 공유
   - 피드백 반영

3. 최종 확정 후 파일 저장

### Phase 5: GitHub Release 생성 (선택)

GitHub Release 생성 시:

1. 태그 생성

```bash
git tag -a v1.2.3 -m "Release v1.2.3"
git push origin v1.2.3
```

2. GitHub Release 페이지에서 릴리즈 생성
   - 릴리즈 노트 내용 복사
   - 빌드 아티팩트 첨부 (해당 시)

## 버전 넘버링 (Semantic Versioning)

```text
MAJOR.MINOR.PATCH

MAJOR: 호환되지 않는 API 변경
MINOR: 하위 호환되는 기능 추가
PATCH: 하위 호환되는 버그 수정
```

### 버전 결정 기준

| 변경 내용 | 버전 | 예시 |
|----------|------|------|
| Breaking Changes 있음 | MAJOR | 1.2.3 → 2.0.0 |
| 새 기능 추가 | MINOR | 1.2.3 → 1.3.0 |
| 버그 수정만 | PATCH | 1.2.3 → 1.2.4 |
| 문서/스타일만 | PATCH | 1.2.3 → 1.2.4 |

## 릴리즈 노트 작성 가이드

### 좋은 릴리즈 노트의 특징

| 항목 | 설명 |
|------|------|
| 명확성 | 기술적 배경 없이도 이해 가능 |
| 완전성 | 모든 주요 변경 사항 포함 |
| 구조화 | 일관된 형식과 분류 |
| 실용성 | 업그레이드에 필요한 정보 포함 |

### 작성 시 주의사항

- 사용자 관점에서 작성 (내부 구현 상세 X)
- Breaking Changes는 반드시 명시
- 관련 이슈/PR 링크 포함
- 업그레이드 방법 명확히 안내
- 기술 용어는 영어 원문 유지
- 문서는 한글로 작성

## 주의사항

- 릴리즈 노트는 배포 전 작성 완료
- Breaking Changes는 반드시 별도 섹션으로 강조
- 내부 이슈 번호는 공개 릴리즈에서 제외
- 파일명 형식: `releaseMMDDNN.md` (MMDDNN 형식 사용)
- 모든 주요 변경 사항은 관련 이슈/PR과 연결
- 사용자가 이해하기 쉬운 언어로 작성

## 커밋 메시지 형식

```bash
docs: add release notes for v1.2.3
```

## 참조

- [CLAUDE.md](../../CLAUDE.md) - 전체 규칙
- [deploy.md](./deploy.md) - 빌드 및 배포
- [hotfix.md](./hotfix.md) - 긴급 버그 수정
