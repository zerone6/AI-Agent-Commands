---
agent: agent
description: "빌드 및 배포 프로세스 실행"
---

애플리케이션 빌드 및 배포를 수행한다. 테스트, 빌드, 배포, 검증의 전체 프로세스를 관리하며 배포 결과를 문서화한다.

## 목적

프로젝트의 안정적인 배포를 보장하고 배포 과정을 표준화한다. 환경별(Development, Staging, Production) 배포 절차를 관리하며, 배포 후 검증 및 롤백 절차를 제공한다.

## 트리거

- Sprint 완료 후 릴리즈
- 사용자가 배포를 요청할 때
- 스테이징/프로덕션 배포 필요 시
- CI/CD 파이프라인에서 자동 트리거

## 결과물

### 파일 경로

```text
/docs/taskLog/deployMMDDNN.md
```

> 폴더가 없으면 자동 생성합니다.

### 파일 형식

```markdown
# 배포 결과 보고서

## 배포 정보
- 배포 일시: YYYY-MM-DD HH:MM (Asia/Tokyo)
- 환경: Production / Staging / Development
- 버전: v1.2.3
- 배포자: (사용자명)

## 변경 사항
- 이전 버전: v1.2.2
- 주요 변경: (변경 내용 요약)
- 관련 PLAN: planMMDDNN.md

## 빌드 정보
| 항목 | 값 |
|------|---|
| 빌드 시간 | N초 |
| 번들 크기 | N MB |
| 커밋 해시 | abc1234 |

## 배포 상태
| 단계 | 상태 |
|------|------|
| 빌드 | 성공/실패 |
| 배포 | 성공/실패 |
| 헬스 체크 | 정상/이상 |
| 스모크 테스트 | 통과/실패 |

## 배포 URL
- Production: https://your-domain.com
- Staging: https://staging.your-domain.com

## 모니터링
- Dashboard: [링크]
- Logs: [링크]

## 롤백 정보 (필요 시)
- 롤백 명령어: `vercel rollback` 또는 `git revert <commit>`
- 이전 버전: v1.2.2
```

## 실행 순서

### Phase 1: 사전 검증

1. 배포 전 체크리스트 확인
   - 모든 테스트 통과 여부
   - 코드 리뷰 완료 여부
   - 보안 검토 완료 여부
   - main 브랜치 최신 상태 확인

2. 현재 브랜치 및 상태 확인

```bash
git status
git branch
```

3. main 브랜치 최신화

```bash
git checkout main
git pull origin main
```

4. 테스트 실행

```bash
npm run test
```

5. 빌드 테스트

```bash
npm run build
```

### Phase 2: 버전 관리

1. 현재 버전 확인

```bash
cat package.json | grep version
```

2. 버전 결정 (Semantic Versioning)

| 변경 유형 | 버전 증가 | 예시 |
|----------|----------|------|
| 호환되지 않는 변경 | Major | 1.0.0 → 2.0.0 |
| 새 기능 (하위 호환) | Minor | 1.0.0 → 1.1.0 |
| 버그 수정 | Patch | 1.0.0 → 1.0.1 |

3. 버전 업데이트 (사용자 확인 후)

```bash
npm version <major|minor|patch>
```

### Phase 3: 빌드

1. 프로덕션 빌드 실행

```bash
npm run build:prod
# 또는
npm run build -- --mode production
```

2. 빌드 결과물 확인
   - 번들 크기 확인
   - 소스맵 생성 여부
   - 환경별 설정 적용 확인

3. 빌드 아티팩트 검증

```bash
ls -la dist/
# 또는
ls -la build/
```

### Phase 4: 배포 (환경별)

#### Development 배포

```bash
npm run deploy:dev
```

#### Staging 배포

```bash
npm run deploy:staging
# 또는
vercel --env preview
```

#### Production 배포

```bash
# 사용자 최종 확인 필수
npm run deploy:prod
# 또는
vercel --prod
```

### Phase 5: 배포 후 검증

1. 헬스 체크

```bash
curl https://your-domain.com/health
```

2. 스모크 테스트
   - 주요 페이지 접근 가능 여부
   - 핵심 기능 동작 확인
   - API 엔드포인트 응답 확인

3. 모니터링 확인
   - 에러 로그 급증 여부
   - 성능 메트릭 이상 여부

### Phase 6: 배포 결과 문서화

1. 배포 결과 보고서 작성

```text
/docs/taskLog/deployMMDDNN.md
```

2. 배포 정보 기록
   - 배포 일시, 환경, 버전
   - 빌드 정보 (시간, 번들 크기, 커밋 해시)
   - 배포 상태 (각 단계별 성공/실패)
   - 배포 URL 및 모니터링 링크

3. 문제 발생 시 롤백 정보 포함

## 배포 환경 구성

### 배포 환경별 특징

| 환경 | 용도 | 트리거 | 환경 변수 |
|------|------|--------|----------|
| Development | 개발 테스트 | 수동 | API_URL, NODE_ENV |
| Staging | QA/통합 테스트 | PR 병합 시 | STAGING_DB_URL, STAGING_API_KEY |
| Production | 실서비스 | 릴리즈 태그 | PROD_DB_URL, PROD_API_KEY, SENTRY_DSN |

### 배포 플랫폼별 설정

| 플랫폼 | 설정 파일 | 비고 |
|--------|----------|------|
| Vercel | vercel.json | serverless |
| AWS | buildspec.yml | CodePipeline |
| Docker | Dockerfile, docker-compose.yml | 컨테이너 |
| GitHub Actions | .github/workflows/*.yml | CI/CD |

## 롤백 절차

배포 후 문제 발생 시:

### 즉시 롤백

1. 이전 버전으로 롤백

```bash
# Vercel
vercel rollback

# Docker
docker-compose down
docker-compose up -d --build <previous-image>

# Git 기반
git revert HEAD
git push origin main
```

2. 롤백 확인
   - 서비스 정상 동작 확인
   - 모니터링 지표 확인

3. 롤백 보고서 작성
   - 롤백 사유
   - 롤백 방법
   - 재배포 계획

## 주의사항

- 프로덕션 배포는 반드시 사용자 최종 확인 후 진행
- 배포 전 백업 상태 확인 (DB, 설정 등)
- 배포 후 최소 30분간 모니터링
- 문제 발생 시 즉시 롤백, 원인 분석은 이후
- 배포 시간은 트래픽이 적은 시간대 권장
- 환경 변수 설정 확인 필수
- 의존성 버전 고정 (lock 파일) 확인

## 커밋 메시지 형식

```bash
chore: deploy v1.2.3 to production
```

## 참조

- [CLAUDE.md](../../CLAUDE.md) - 전체 규칙
- [release_note.md](./release_note.md) - 릴리즈 노트 생성
- [hotfix.md](./hotfix.md) - 긴급 버그 수정
