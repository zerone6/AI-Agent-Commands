# AGENTS Rules

Gemini를 위한 프로젝트 규칙 문서

---

## 0. Hybrid Workflow (System Artifacts + AGENTS Rules)

AI 어시스턴트는 시스템 고유의 기능(Artifacts)과 이 프로젝트의 문서 규칙(AGENTS Rules)을 다음과 같은 순서로 결합하여 사용한다.

### 0.1 단계별 작업 지침

| 단계 | 활동 | 사용하는 도구/문서 | 비고 |
| :--- | :--- | :--- | :--- |
| **0. ORDER** | 요청 접수 및 공식화 | 채팅 요청 ->  docs/current_sprint/planMMDDNN.md  | 초기 요청 사항 기록 |
| **2. PLANNING** | 가계획 제안 및 승인 | 아티팩트 implementation_plan.md | 피드백 수렴용 (Interactive) |
| **3. DESIGN** | 공식 계획 확정 | docs/current_sprint/planMMDDNN.md | 승인된 내용을 문서화, 업데이트 |
| **4. EXECUTION** | 실시간 보도 및 구현 | 아티팩트 task.md & Task View UI | **주의**: TODO.md는 수정 금지, execute_plan.md를 지킨다. |
| **5. VERIFY** | 최종 검증 및 보고 | 아티팩트 walkthrough.md | 시각적 증빙 포함 |
| **6. FINISH** | 완료 기록 및 아카이브 | docs/taskLog/commitMMDDNN.md | 최종 이력 저장 |
| | | docs/current_sprint/planMMDDNN.md | 완료 항목체크 |
| **7. BACKLOG** | 잔여 작업 정리 | docs/TODO.md | 작업 중 발견된 미루어진 과제 기록 |
| | | docs/current_sprint/planMMDDNN.md | 미완료 항목 TODO.md에 기입 |

### 7.2 주요 원칙
- **실시간 효율성**: 진행 중인 상세 체크리스트는 task.md와 Task View UI가 담당하며, TODO.md는 오직 '미루어진 작업(Backlog)' 관리용으로만 사용한다.
- **문서의 영속성**: 브라우저나 채팅 내용이 사라져도 docs/ 내의 문서(order, plan, commitLog)를 통해 프로젝트의 히스토리를 완벽히 복구할 수 있어야 한다.
- **Feedback Loop**: implementation_plan을 통해 사용자 승인을 얻기 전까지는 코드를 대량으로 수정하지 않는다.
