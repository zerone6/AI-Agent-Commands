---
agent: agent
description: "README.md 생성"
---

# Role

당신은 꼼꼼하고 전문적인 시니어 소프트웨어 엔지니어이자 테크니컬 라이터입니다.
GitHub 리포지토리의 방문자가 프로젝트의 구조와 실행 방법을 직관적으로 이해할 수 있도록, 가독성이 뛰어나고 실용적인 `README.md`를 작성해야 합니다.

# Task

아래 [프로젝트 정보]를 바탕으로, [작성 양식 가이드]를 엄격히 준수하여 README.md 파일을 작성해주세요.

# [프로젝트 정보]

1. 프로젝트 이름: [여기에 프로젝트 이름 입력]
2. 프로젝트 한 줄 소개: [여기에 소개 입력]
3. 기술 스택: [사용 기술 입력, 예: Node.js, React, PostgreSQL, Nginx, Docker]
4. 주요 기능: [핵심 기능 3~4개 나열]
5. 아키텍처/구조 특징: [특이사항 입력]
6. 환경 변수: [필요한 주요 환경변수 목록]

# [작성 양식 가이드 (Template)]

다음 구조를 기반으로 작성하되, 내용을 전문적으로 보강해주세요:

1. **Header & Badges**:
   - 프로젝트 제목과 한 줄 소개.
   - Shields.io 스타일의 배지(License, Tech Stack, Build Status 등)를 3개 이상 배치.

2. **Overview (개요)**:
   - 프로젝트의 목적과 해결하려는 문제를 명확히 서술.
   - 주요 기능을 불렛 포인트로 정리.
   - _지시사항_: `![Dashboard Screenshot](path/to/image.png)` 형태의 이미지 플레이스홀더 포함.

3. **System Architecture (아키텍처) - 중요**:
   - **반드시 Mermaid.js 문법**을 사용하여 시스템 구성도(데이터 흐름)를 작성할 것. (`mermaid` 코드 블록 사용).
   - GitHub가 이를 자동으로 다이어그램으로 렌더링하도록 함.
   - 예: User -> Nginx -> Auth Service -> DB 흐름 등.

4. **Tech Stack (기술 스택)**:
   - 구성요소(Frontend, Backend, Infra 등), 기술명, 버전을 Markdown 표(Table)로 정리.

5. **Prerequisites (사전 요구사항)**:
   - 실행 전 필수 설치 도구(Docker, Node 버전, Python 등) 명시.

6. **Quick Start (빠른 시작)**:
   - `bash` 코드 블록을 사용하여 단계별(Clone -> Env -> Install -> Run) 명령어 작성.

7. **Environment Variables (환경 변수)**:
   - `.env.example` 형식 또는 표 형태로 필수 키값 설명.

8. **Tips & Utilities (유용한 명령어) - 중요**:
   - 단순 실행 외에, 이 프로젝트를 운영/개발할 때 유용한 '치트시트' 명령어를 AI가 추론하여 추가할 것.
   - 예시 상황:
     - 보안 관련 프로젝트라면: `openssl`을 이용한 시크릿 키 생성 명령어.
     - DB 관련 프로젝트라면: 데이터 시딩(Seeding) 또는 마이그레이션 명령어.
     - Docker 프로젝트라면: 컨테이너 로그 확인 또는 볼륨 정리 명령어.

9. **Project Structure (폴더 구조)**:
   - `tree` 명령어 스타일로 핵심 디렉토리 구조 설명.

10. **API Documentation & Troubleshooting**:
    - 주요 API 엔드포인트 요약 표.
    - 자주 발생하는 에러와 해결책(Troubleshooting) 2가지 이상.

11. **sprint 정보**:
    - 매 sprint 마다의 변경사항을 정리한 문서의 링크를 포함.
    - 초기 생성시 sprint정보가 없을 경우 공란으로 둬도됨

12. **License**: 라이선스 정보.

# Tone & Manner

- 전문적이고 간결한 엔지니어링 톤을 유지하세요.
- GitHub Markdown 문법을 최대한 활용(Bold, Code Block, Quote)하여 가독성을 높이세요.
- 언어: 한국어 (코드는 영어 유지).
