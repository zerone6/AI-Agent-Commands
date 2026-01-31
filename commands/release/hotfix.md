---
agent: agent
description: "긴급 버그 수정 프로세스"
---

프로덕션 환경의 긴급 버그를 신속하게 수정하고 배포한다. 최소 범위의 수정과 빠른 검증을 통해 서비스 안정성을 회복한다.

## 목적

프로덕션 장애 발생 시 신속한 대응을 통해 서비스 다운타임을 최소화한다. 일반 버그 수정과 달리 긴급도에 따라 최소한의 절차로 빠르게 수정 및 배포를 진행하며, 사후 분석을 통해 재발을 방지한다.

## 트리거

- 프로덕션 장애 발생 (P0)
- 보안 취약점 긴급 패치
- 크리티컬 버그 발견
- 사용자가 핫픽스를 요청할 때

## 결과물

### 파일 경로

```text
/docs/taskLog/hotfixMMDDNN.md
```

> 폴더가 없으면 자동 생성합니다.

### 파일 형식

```markdown
# Hotfix 보고서

## 기본 정보
- 장애 발생: YYYY-MM-DD HH:MM (Asia/Tokyo)
- 장애 해결: YYYY-MM-DD HH:MM (Asia/Tokyo)
- 총 다운타임: N분
- 버전: v1.2.3 → v1.2.4

## 장애 내용
- **현상**: (사용자에게 보이는 증상)
- **원인**: (기술적 원인)
- **영향**: (영향 받은 사용자/기능 범위)

## 타임라인
| 시간 | 내용 |
|------|------|
| HH:MM | 장애 감지 |
| HH:MM | 원인 파악 |
| HH:MM | 수정 완료 |
| HH:MM | 배포 완료 |
| HH:MM | 정상화 확인 |

## 수정 내용
- **파일**: /path/to/file.ts
- **변경**: (변경 내용)
- **커밋**: <commit-hash>

## 근본 원인 분석 (RCA)

### 직접 원인
(이 버그가 발생한 직접적인 이유)

### 근본 원인
(왜 이런 버그가 배포되었는가)

### 재발 방지책
| 항목 | 조치 | 담당 | 기한 |
|------|------|------|------|
| 테스트 강화 | 관련 테스트 케이스 추가 | - | - |
| 코드 리뷰 | 체크리스트 항목 추가 | - | - |
| 모니터링 | 알림 조건 추가 | - | - |

## 관련 문서
- 커밋: <link>
- 이슈: <link>
- 모니터링: <link>
```

## 실행 순서

### Phase 1: 상황 파악 (5분 이내)

1. 장애 현상 확인
   - 에러 로그 확인
   - 영향 범위 파악 (사용자, 기능)
   - 재현 방법 확인

2. 장애 기록 시작

```markdown
## 장애 보고
- 발생 시간: YYYY-MM-DD HH:MM (Asia/Tokyo)
- 현상: (구체적 증상)
- 영향: (사용자 영향 범위)
- 재현: (재현 방법)
```

3. 사용자에게 상황 보고
   - 장애 인지 및 대응 중 안내
   - 예상 복구 시간 공유

### Phase 2: Hotfix 브랜치 생성

1. main 브랜치에서 분기

```bash
git checkout main
git pull origin main
git checkout -b hotfix/issue-description
```

2. 현재 버전 확인

```bash
git describe --tags --abbrev=0
# 현재: v1.2.3 -> Hotfix: v1.2.4
```

### Phase 3: 버그 수정

1. 원인 분석
   - 코드 추적
   - 로그 분석
   - 관련 커밋 확인

2. 최소 범위 수정
   - 버그 원인만 수정
   - 리팩토링, 추가 개선 금지
   - 사이드 이펙트 최소화

3. 수정 내용 기록

```markdown
## 수정 내용
- 파일: /path/to/file.ts
- 원인: (버그 원인)
- 해결: (수정 방법)
```

### Phase 4: 빠른 검증

1. 직접 영향 테스트

```bash
# 관련 테스트만 실행
npm run test -- --grep "affected-module"
```

2. 빌드 확인

```bash
npm run build
```

3. 로컬 확인
   - 버그 재현 불가 확인
   - 기본 기능 동작 확인

### Phase 5: 긴급 배포

1. 커밋

```bash
git add .
git commit -m "hotfix: <버그 설명>"
```

2. main에 직접 병합 (긴급 시)

```bash
git checkout main
git merge hotfix/issue-description
```

3. 버전 태그

```bash
git tag -a v1.2.4 -m "Hotfix: <설명>"
git push origin main --tags
```

4. 배포 실행

```bash
npm run deploy:prod
```

### Phase 6: 사후 처리

1. 배포 확인
   - 장애 해결 확인
   - 모니터링 지표 정상화 확인

2. develop 브랜치 동기화

```bash
git checkout develop
git merge main
git push origin develop
```

3. Hotfix 보고서 작성

```text
/docs/taskLog/hotfixMMDDNN.md
```

4. 근본 원인 분석 (RCA) 수행
   - 직접 원인
   - 근본 원인
   - 재발 방지책 수립

## Hotfix vs 일반 버그 수정

| 항목 | Hotfix | 일반 버그 수정 |
|------|--------|---------------|
| 긴급도 | P0 (즉시) | P1-P2 |
| 브랜치 | main에서 직접 분기 | develop에서 분기 |
| 리뷰 | 최소화 (필수 항목만) | 전체 코드 리뷰 |
| 테스트 | 영향 범위만 | 전체 테스트 |
| 배포 | 즉시 | 다음 릴리즈 |

## Hotfix 판단 기준

| 긴급도 | 기준 | 대응 |
|--------|------|------|
| P0 | 서비스 불가, 데이터 손실, 보안 취약점 | 즉시 Hotfix |
| P1 | 주요 기능 장애, 사용자 영향 큼 | 당일 Hotfix 검토 |
| P2 | 일부 기능 이슈, 우회 가능 | 일반 버그 수정 |

## 롤백 절차 (수정 실패 시)

수정 배포 후에도 문제가 지속되면:

1. 즉시 롤백 결정 (5분 이내)

```bash
# Vercel
vercel rollback

# Git
git revert HEAD
git push origin main
```

2. 롤백 배포 확인
   - 서비스 정상 동작 확인
   - 모니터링 지표 확인

3. 원인 재분석 후 재수정

## 체크리스트

### 수정 전
- [ ] 장애 현상 정확히 파악
- [ ] 영향 범위 확인
- [ ] main 브랜치 최신 상태

### 수정 중
- [ ] 최소 범위만 수정
- [ ] 사이드 이펙트 없음 확인
- [ ] 관련 테스트 통과

### 수정 후
- [ ] 장애 해결 확인
- [ ] 모니터링 정상
- [ ] develop 동기화
- [ ] 보고서 작성
- [ ] RCA 수행 및 재발 방지책 수립

## 주의사항

- Hotfix는 버그 수정만, 기능 추가/개선 금지
- 모든 Hotfix는 사후 보고서 필수
- 같은 이슈 재발 방지책 반드시 수립
- 긴급 상황에서도 최소한의 테스트는 필수
- 서비스 영향이 큰 경우 사용자 공지 고려
- 배포 후 최소 30분간 모니터링

## 커밋 메시지 형식

```bash
hotfix: <버그 설명>

Fix critical bug in <module>
- Cause: <원인>
- Solution: <해결 방법>
- Impact: <영향 범위>
```

## 참조

- [CLAUDE.md](../../CLAUDE.md) - 전체 규칙
- [deploy.md](./deploy.md) - 빌드 및 배포
- [release_note.md](./release_note.md) - 릴리즈 노트 생성
