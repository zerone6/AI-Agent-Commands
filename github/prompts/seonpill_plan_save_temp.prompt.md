---
agent: agent
description: "작업 도중 다음에 계속 작업하기 위해 상황을 보존한다."
---

다음과 같이 상태 저장 파일을 생성한다.

▼구체적인 순서

1. 현재까지 진행된 current_sprint의 내용을 중간 저장하고 다음에 이어서 작업하기 위한 이력을 남긴다.
   - 전체 내용을 확인해서 단계별로 상세히 남긴다.
2. 파일명은 /docs/current_sprint/SAVETEMPMMDDNNcommit_log_MMDDNN.md(NN은 당일의 작업번호를 리니어하게 증가시킨다. ex : SAVETEMP121901.md)
3. current_sprint아래의 파일들을 전체점검해서 다음 내용을 기록한다. 순서를 지켜라
   - 다음에 다시 시작할때 진행해야할 내용의 리스트
   - 현재까지 작업 진행 내용 요약 (디테일한 작업 내용은 ORDER 파일에 갱신해왔으므로, 제목과 간단한 설명을 나열한다.)
3. 위 내용을 확인해서 커밋 로그를 생성한다.
4. 직접 커밋하지 않고, /commit_log_MMDDNN.log의 파일명으로 작성한다. (NN은 당일의 작업번호를 리니어하게 증가시킨다. ex : commit_log_121501.log)