---
agent: agent
description: "OWASP Top 10 기반 보안 취약점 검토 및 수정"
---

릴리즈 전 또는 Sprint 종료 전 보안 취약점을 검토하고 수정합니다.

## 목적

프로덕션 환경에 배포하기 전 OWASP Top 10 기반의 보안 취약점을 식별하고 수정하여 시스템의 보안성을 확보합니다.

## 트리거

- 사용자가 보안 검토를 요청할 때
- Sprint 종료 전 보안 점검이 필요할 때
- 릴리즈 준비 단계
- 인증/권한 관련 코드 변경 후
- 민감한 데이터를 처리하는 기능 구현 후

## 결과물

### 파일 경로

```text
/docs/current_sprint/securityMMDDNN.md
```

> 폴더가 없으면 자동 생성합니다.

### 파일 형식

```markdown
# 보안 검토 결과

## 검토 일시
YYYY-MM-DD HH:MM (Asia/Tokyo)

## 검토 범위
- 검토한 파일/모듈 목록

## 발견된 취약점

| 심각도 | 유형 | 위치 | 설명 | 상태 |
|--------|------|------|------|------|
| HIGH | SQL Injection | /api/user.ts:42 | ... | 수정완료 |
| MEDIUM | XSS | /components/Comment.tsx:15 | ... | 수정완료 |

## 수정 내역
- 수정한 파일 목록
- 적용한 보안 조치

## 잔여 이슈
- 추가 검토 필요 항목
- 다음 Sprint로 이관 항목

## 권장 사항
- 추가 보안 강화 제안
```

## 실행 순서

### Phase 1: 정적 분석

1. 코드 내 하드코딩된 시크릿 검색
   - API 키, 비밀번호, 토큰 등
   - `.env` 파일 사용 여부 확인
2. SQL/명령어 인젝션 패턴 검색
   - 동적 쿼리 구성 확인
   - Parameterized query 사용 확인
3. 위험한 함수 사용 확인
   - `eval`, `innerHTML`, `exec` 등
4. 취약점 목록 작성

### Phase 2: 인증/권한 검토

1. 인증 로직 검토
   - 비밀번호 해싱 알고리즘 (bcrypt, argon2)
   - JWT 토큰 만료 시간 설정
2. 세션 관리 검토
   - 세션 토큰 엔트로피
   - 로그아웃 시 서버 측 세션 무효화
3. 권한 검증 누락 확인
   - 모든 엔드포인트 권한 체크
   - IDOR 취약점 확인
4. 수정 필요 항목 목록화

### Phase 3: 입력/출력 검토

1. 사용자 입력 처리 로직 검토
   - 입력 검증 및 sanitization
   - 화이트리스트 기반 검증
2. 데이터 출력 시 인코딩 확인
   - XSS 방지를 위한 출력 인코딩
   - CSP 헤더 설정
3. 파일 업로드 검증 확인
   - 파일 타입 및 크기 제한
   - 파일명 sanitization
4. API 응답 데이터 검토
   - 민감 정보 노출 여부

### Phase 4: 설정 검토

1. 보안 헤더 설정 확인

   | 헤더 | 권장값 |
   |------|--------|
   | X-Frame-Options | DENY 또는 SAMEORIGIN |
   | X-Content-Type-Options | nosniff |
   | Strict-Transport-Security | max-age=31536000 |

2. CORS 설정 검토
   - 허용 도메인 명시적 지정
   - 와일드카드 사용 금지
3. 환경별 설정 분리 확인
   - 개발/스테이징/프로덕션 환경 분리
4. 에러 핸들링 검토
   - 프로덕션 환경에서 스택 트레이스 노출 금지
   - 민감 정보 마스킹

### Phase 5: 의존성 검토

1. 의존성 취약점 스캔 실행
   ```bash
   npm audit
   # 또는
   pip-audit
   ```
2. 취약점 있는 패키지 업데이트
3. 미사용 패키지 제거
4. 버전 고정 확인 (package-lock.json)

### Phase 6: 보고서 작성 및 수정

1. 발견된 취약점 심각도 분류
2. 보안 검토 결과 문서 작성
3. CRITICAL/HIGH 심각도 취약점 즉시 수정
4. MEDIUM/LOW 심각도 항목 수정 또는 TODO 등록

## 보안 체크리스트

### 1. 인증 및 세션 관리

| 항목 | 체크 |
|------|------|
| 비밀번호 해싱 | bcrypt, argon2 등 안전한 알고리즘 사용 |
| 세션 토큰 | 충분한 엔트로피, 안전한 저장 |
| JWT | 만료 시간 설정, 서명 검증 |
| 로그아웃 | 서버 측 세션 무효화 |
| 비밀번호 정책 | 최소 길이, 복잡도 요구 |

### 2. 입력 검증 (OWASP Top 10)

| 취약점 | 점검 내용 |
|--------|----------|
| SQL Injection | Parameterized query 사용, ORM 활용 |
| XSS | 출력 인코딩, CSP 헤더, sanitize |
| Command Injection | 사용자 입력 명령어 실행 금지 |
| Path Traversal | 파일 경로 검증, 화이트리스트 |
| SSRF | URL 검증, 내부망 접근 차단 |

### 3. 민감 데이터 보호

| 항목 | 체크 |
|------|------|
| API 키/시크릿 | 환경변수 사용, 코드 내 하드코딩 금지 |
| .env 파일 | .gitignore 포함 확인 |
| 로그 | 민감 정보 마스킹 (비밀번호, 카드번호 등) |
| 에러 메시지 | 스택 트레이스 노출 금지 (프로덕션) |
| 개인정보 | 암호화 저장, 최소 수집 원칙 |

### 4. 접근 제어

| 항목 | 체크 |
|------|------|
| 권한 검증 | 모든 엔드포인트에 권한 체크 |
| IDOR | 리소스 접근 시 소유권 확인 |
| 역할 기반 | RBAC/ABAC 적용 여부 |
| API 인증 | 모든 API에 인증 필수 (공개 API 제외) |

## 심각도 기준

| 심각도 | 기준 | 대응 |
|--------|------|------|
| CRITICAL | 즉시 악용 가능, 데이터 유출 위험 | 즉시 수정, 배포 중단 |
| HIGH | 악용 가능성 높음 | 당일 수정 |
| MEDIUM | 조건부 악용 가능 | 이번 Sprint 내 수정 |
| LOW | 악용 어려움, 모범 사례 위반 | 백로그 등록 |

## 주의사항

- 발견된 취약점은 공개 채널에 공유 금지
- CRITICAL/HIGH는 즉시 사용자에게 보고
- 수정 후 반드시 재검증
- 보안 수정은 별도 커밋으로 분리
- 관련 문서: [CLAUDE.md](../../CLAUDE.md)

## 커밋 메시지 형식

```bash
security: <수정 내용>

# 예시
security: fix SQL injection in user query
security: add input validation for file upload
security: remove hardcoded API keys
```
