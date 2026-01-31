---
agent: agent
description: "프로젝트 README.md 생성"
---

프로젝트의 개요, 아키텍처, 실행 방법을 담은 전문적인 README.md 파일을 생성합니다.

## 목적

GitHub 리포지토리 방문자가 프로젝트의 구조와 실행 방법을 직관적으로 이해할 수 있도록 가독성이 뛰어나고 실용적인 문서를 제공합니다. 프로젝트의 첫인상을 결정하는 핵심 문서로서, 개발자 온보딩과 협업을 용이하게 합니다.

## 트리거

- 새로운 프로젝트 초기화 시 사용자가 README 생성을 요청할 때
- 기존 README 업데이트가 필요할 때
- Sprint 완료 후 프로젝트 변경사항을 반영할 때

## 결과물

### 파일 경로
```text
/README.md
```

> 프로젝트 루트에 생성됩니다.

### 파일 형식

README.md는 다음 섹션들로 구성됩니다.

```markdown
# [프로젝트 이름]

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Build](https://img.shields.io/badge/build-passing-brightgreen.svg)
![Tech Stack](https://img.shields.io/badge/stack-Node.js%20%7C%20React-blue.svg)

[프로젝트 한 줄 소개]

## Overview

[프로젝트의 목적과 해결하려는 문제]

### 주요 기능
- 기능 1
- 기능 2
- 기능 3

![Dashboard Screenshot](path/to/image.png)

## System Architecture

\```mermaid
graph LR
    A[User] --> B[Nginx]
    B --> C[Auth Service]
    C --> D[Database]
    B --> E[API Gateway]
    E --> F[Microservice 1]
    E --> G[Microservice 2]
\```

## Tech Stack

| 구성요소 | 기술 | 버전 |
|---------|------|------|
| Frontend | React | 18.x |
| Backend | Node.js | 20.x |
| Database | PostgreSQL | 15.x |
| Infrastructure | Docker | 24.x |

## Prerequisites

- Node.js 20.x or higher
- Docker 24.x or higher
- npm or yarn

## Quick Start

\```bash
# 1. Clone repository
git clone https://github.com/username/project.git
cd project

# 2. Environment setup
cp .env.example .env
# Edit .env file with your configuration

# 3. Install dependencies
npm install

# 4. Run application
npm start
\```

## Environment Variables

| 변수명 | 설명 | 필수 | 기본값 |
|--------|------|------|--------|
| DATABASE_URL | Database connection string | Yes | - |
| JWT_SECRET | JWT signing secret | Yes | - |
| PORT | Server port | No | 3000 |

## Tips & Utilities

### 유용한 명령어

\```bash
# Database migration
npm run db:migrate

# Seed data
npm run db:seed

# Run tests
npm test

# Build for production
npm run build

# Docker compose
docker-compose up -d
\```

## Project Structure

\```text
project/
├── src/
│   ├── controllers/    # Request handlers
│   ├── models/         # Data models
│   ├── routes/         # API routes
│   └── utils/          # Utility functions
├── tests/              # Test files
├── docs/               # Documentation
│   ├── current_sprint/ # Current sprint docs
│   ├── sprints/        # Sprint archives
│   └── taskLog/        # Commit logs
├── .env.example        # Environment template
└── README.md           # This file
\```

## API Documentation

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/users | Get all users |
| POST | /api/users | Create user |
| GET | /api/users/:id | Get user by ID |

## Troubleshooting

### Issue 1: Connection refused
- 원인: Database가 실행되지 않음
- 해결: `docker-compose up -d` 실행

### Issue 2: Port already in use
- 원인: 다른 프로세스가 포트 사용 중
- 해결: .env에서 PORT 변경 또는 기존 프로세스 종료

## Sprint 정보

- [Sprint 1](./docs/sprints/sprint011501.md) - 초기 프로젝트 설정
- [Sprint 2](./docs/sprints/sprint013001.md) - 사용자 인증 구현

## License

MIT License
\```
```

## 실행 순서

### Phase 1: 프로젝트 정보 수집
1. 프로젝트 루트 디렉토리 확인
2. `package.json`, `pom.xml`, `requirements.txt` 등에서 기술 스택 파악
3. 디렉토리 구조 분석
4. `.env.example` 또는 설정 파일에서 환경 변수 확인
5. 기존 문서(`/docs/ARCHITECTURE.md`, `/docs/TODO.md` 등) 참조

### Phase 2: 사용자 입력 수집
사용자에게 다음 정보를 요청합니다.

```markdown
다음 정보를 입력해주세요:

1. 프로젝트 이름: [입력]
2. 프로젝트 한 줄 소개: [입력]
3. 주요 기능 (3-4개): [입력]
4. 아키텍처 특징: [입력]
5. 라이선스: [입력, 기본값: MIT]
```

사용자가 정보를 제공하지 않으면 분석 결과를 바탕으로 자동 추론합니다.

### Phase 3: 섹션별 작성
1. **Header & Badges**
   - Shields.io 배지 3개 이상 생성
   - 프로젝트 제목 및 한 줄 소개

2. **Overview**
   - 프로젝트 목적 서술
   - 주요 기능 불렛 포인트 정리
   - 스크린샷 플레이스홀더 포함

3. **System Architecture**
   - Mermaid.js 다이어그램 작성
   - 데이터 흐름 시각화

4. **Tech Stack**
   - 기술 스택 표 작성
   - 버전 정보 포함

5. **Prerequisites**
   - 필수 설치 도구 명시

6. **Quick Start**
   - 단계별 실행 명령어 작성

7. **Environment Variables**
   - 환경 변수 표 작성

8. **Tips & Utilities**
   - 프로젝트 특성에 맞는 유용한 명령어 추론 및 추가
   - 예: DB 시딩, 마이그레이션, 보안 키 생성 등

9. **Project Structure**
   - 폴더 구조 tree 형식 작성

10. **API Documentation**
    - 주요 API 엔드포인트 요약 표

11. **Troubleshooting**
    - 자주 발생하는 에러 2가지 이상 및 해결책

12. **Sprint 정보**
    - `/docs/sprints/` 폴더의 Sprint 문서 링크 추가
    - 초기 생성 시 공란 허용

13. **License**
    - 라이선스 정보

### Phase 4: 검증 및 생성
1. Markdown 문법 검증
2. 링크 유효성 확인
3. `/README.md` 파일 생성
4. 사용자에게 결과 보고

### Phase 5: 후속 작업 (선택)
1. 스크린샷 경로 업데이트 요청
2. 배지 URL 커스터마이징 제안
3. API 문서 상세화 제안

## 주의사항

- README.md에는 상세 구현 내용을 포함하지 않습니다 (링크만 사용)
- 같은 내용을 여러 섹션에 반복하지 않습니다
- 파일 경로는 상대 경로를 사용합니다
- Mermaid.js 다이어그램은 반드시 포함합니다
- Tips & Utilities 섹션에 프로젝트 특성에 맞는 명령어를 추론하여 추가합니다
- 이모지는 사용하지 않습니다
- 언어: 한국어 (코드는 영어 유지)

## Tips & Utilities 예시

프로젝트 유형별 유용한 명령어 예시:

### 보안 관련 프로젝트
```bash
# Generate secret key
openssl rand -base64 32

# Generate JWT secret
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
```

### Database 관련 프로젝트
```bash
# Run migrations
npm run migrate

# Seed database
npm run seed

# Reset database
npm run db:reset
```

### Docker 프로젝트
```bash
# View container logs
docker-compose logs -f

# Clean up volumes
docker-compose down -v

# Rebuild containers
docker-compose up -d --build
```

## 참고

- [AGENTS Rules](../../CLAUDE.md) - 전체 규칙 문서
- [문서 구조](../../CLAUDE.md#2-문서-구조)
- [Markdown 규칙](../../CLAUDE.md#7-작성-스타일-가이드)
