## Global Rule

Antigravity는 ~/.gemini/commands/ 아래에 있는 각각의 명령을 상황에 맞게 수행하라.

## Workflow Reference

### Sprint Structure

```text
[ORDER] -> SPRINT {
  반복: ORDER -> PLAN -> dev/execute_plan -> dev/finish_order
} -> quality/* -> doc/finish_sprint
```

- **ORDER**: 사용자 요청 (입력)
- **PLAN**: AI가 작성한 작업 계획서 (`/docs/current_sprint/planMMDDNN.md`)
- **Sprint**: 여러 PLAN을 포함하는 작업 주기 (작업량 기반)

### Commands Reference

| Category | Command | Purpose |
|----------|---------|---------|
| `plan/` | make_plan | ORDER 분석 -> PLAN 작성 |
| `plan/` | review_order | 외부 문서(Jira, 기획서) -> PLAN 변환 |
| `dev/` | execute_plan | PLAN Phase별 구현 |
| `dev/` | save_temp | 작업 중단 시 상태 저장 |
| `dev/` | finish_order | 구현 완료 후 정리 |
| `quality/` | security | OWASP Top 10 보안 검토 |
| `quality/` | refactor | 코드 품질 개선 |
| `quality/` | l10n | 다국어 지원 점검 |
| `doc/` | commit_log | Conventional Commit 로그 작성 |
| `doc/` | finish_sprint | Sprint 종료 및 아카이브 |
