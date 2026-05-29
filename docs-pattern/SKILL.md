---
name: docs-pattern
description: "Bootstrap and maintain the personal project-docs pattern under docs/: current_status.md (where things stand right now), history.md (what changed over time), issues.md (numbered technical issues + resolution), todo.md (categorized checklist), and optionally research_method.md (versioned methodology spec). Use when the user wants to initialize this pattern in a new project ('docs 패턴 깔아줘', 'docs init', 'set up project docs', 'init docs-pattern'), or wants to update any of those files after doing work ('current_status 업데이트', 'history에 추가', '이슈 등록해줘', 'todo 정리', 'mark X done', 'log session', 'project status update'). Skill enforces which file gets which kind of information."
metadata:
  version: "1.0"
  status: active
---

# docs-pattern

프로젝트 루트에 `docs/` 폴더를 만들고, 그 안에 **5개의 정해진 .md 파일**을 사용자 규율대로 유지하는 스킬. 사용자가 EEG-WM-JEPA·Agentic_tree_search·icml2026-gwm-nuclear-rag·JPTAKU·openpencil-server 등에서 일관되게 써 온 패턴을 코드화한 것.

**철학**: planning-with-files처럼 hook으로 자동 주입하지 않음. 컨텍스트 윈도우는 깨끗하게 두고, **필요할 때만 사용자가/Claude가 명시적으로 읽고 업데이트**한다.

---

## 파일별 역할

| 파일 | 무엇을 적나 | 언제 업데이트 |
|---|---|---|
| `current_status.md` | **지금 이 순간** 프로젝트가 어디까지 와 있는지. 서버/환경 상태, 직전 세션 작업, 즉시 다음 할 일. 최신 세션이 **맨 위**. | 작업 세션을 시작·전환·종료할 때 |
| `history.md` | **방법론·아키텍처·중요 의사결정의 변경 이력**. 날짜·단계(Phase)별로 그룹핑. 시간 순(예전 게 위). | 의미 있는 방법론 변경이 생겼을 때 |
| `issues.md` | **기술적 이슈 + 해결 방법**. `Issue #N` 번호 매김, `상태: ✅ 해결됨` / `🔄 진행 중` / `⏸️ 보류` 표기. 문제 → 원인 → 해결 방법 구조. | 새 이슈 발견 시 / 해결 시 |
| `todo.md` | **카테고리별 체크리스트**. `## 1. 카테고리` 아래에 `- [x] 항목 (YYYY-MM-DD)` 또는 `- [ ] 항목`. 완료 시 날짜 기록. | 작업 추가·완료 시 |
| `research_method.md` (선택) | **방법론 스펙**. 버전 번호 명시(`v2.0`). 파이프라인 단계별 상세. | 방법론 자체가 바뀔 때 |

`research_method.md`는 리서치/실험 프로젝트에만 만들고, 일반 소프트웨어 프로젝트(예: `openpencil-server`)는 생략한다.

---

## 초기화 (`init`)

새 프로젝트에서 패턴을 처음 깔 때:

```bash
# 풀 init (research_method.md 포함, 기본)
bash ${CLAUDE_PLUGIN_ROOT}/scripts/init-docs.sh

# 리서치 파일 빼고 4개만
bash ${CLAUDE_PLUGIN_ROOT}/scripts/init-docs.sh --no-research
```

또는 스킬 디렉토리를 모르면, Claude가 `templates/` 안 5개 파일을 프로젝트의 `docs/`로 그대로 복사하면 된다. 이미 존재하는 파일은 **덮어쓰지 않는다**.

---

## 업데이트 규율

### `current_status.md`

- 헤더 바로 아래 `> 최종 업데이트: YYYY-MM-DD (한 줄 요약)`을 갱신.
- 새 세션은 `## Session YYYY-MM-DD — 제목` 헤딩으로 **파일 상단**(헤더 바로 아래)에 prepend.
- 서버/하드웨어 환경이 의미 있으면 `**서버**: ...` 한 줄로 명시.
- 표·체크리스트 적극 사용. 산문은 핵심만.

### `history.md`

- 시간 순 (예전 게 위). 가장 최근은 맨 아래에 append.
- `## YYYY-MM-DD ~ MM-DD: 제목` 또는 `## YYYY-MM-DD: Phase N — 제목`.
- **의사결정의 *이유***를 적는다 — "무엇을 했다"가 아니라 "왜 그 방향으로 갔다".

### `issues.md`

- `## Issue #N: 제목` + `**상태: ✅ 해결됨 (YYYY-MM-DD)**` / `🔄 진행 중` / `⏸️ 보류`.
- 안쪽 구조: `### 문제` → `### 원인` (선택) → `### 해결 방법` → `### 향후 고려사항` (선택).
- 번호는 절대 재사용 안 함 — 해결되거나 무효화돼도 그대로 두고 상태만 바꿈.

### `todo.md`

- `## N. 카테고리` 헤딩 아래 체크박스 리스트.
- 완료: `- [x] 내용 (YYYY-MM-DD)` — 날짜 필수.
- 미완료: `- [ ] 내용`.
- 하위 항목은 `  - [ ] ...` 들여쓰기.
- 완료된 항목을 삭제하지 않음 — 작업 이력으로 남김.

### `research_method.md`

- 헤더 아래 `> 최종 업데이트: YYYY-MM-DD` + `> 버전: vX.Y (한 줄 요약)`.
- 구조 자체를 바꿀 때 버전 올림 (`v2.0` → `v3.0`).
- 세부만 바뀌면 마이너 (`v2.1` → `v2.2`).

---

## 트리거 예시

| 사용자 발화 | Claude가 할 일 |
|---|---|
| "이 프로젝트에 docs 패턴 깔아줘" | `docs/` + 5개 파일 생성 (이미 있으면 스킵) |
| "오늘 한 거 current_status에 정리해줘" | `current_status.md` 상단에 새 Session 블록 prepend |
| "Issue #N 해결됐어, 마크해줘" | `issues.md`에서 해당 Issue 상태를 `✅ 해결됨 (오늘 날짜)`로 변경 |
| "todo에서 X 끝남" | `todo.md`에서 해당 줄을 `- [x] X (오늘 날짜)`로 변경 |
| "방법론 v3로 올라간 거 반영" | `research_method.md`의 버전·요약 줄 갱신 + 변경 내용 본문 반영 |
| "지금 프로젝트 상태 어떻게 돼?" | `current_status.md` + 최근 `history.md` 5줄 + 미해결 `issues.md` + 미체크 `todo.md` 묶어서 요약 출력 |

---

## 안티패턴

| 하지 말 것 | 대신 |
|---|---|
| `current_status.md`를 무한히 늘리기 | 4개 세션 넘으면 오래된 세션을 `history.md`로 이동 |
| 이미 닫은 Issue를 다시 열기 | 새 Issue 번호로 등록하고 `(연관: Issue #N)`로 표기 |
| `todo.md`에서 완료 항목 삭제 | 체크 + 날짜만, 작업 이력으로 남김 |
| `history.md`를 "무엇을 했다" 로그로 사용 | 그건 `current_status.md`/`progress`. history는 **방향성 변경 이유** |
| 리서치 아닌 프로젝트에 `research_method.md` 강제 | 옵션. `--no-research` 또는 그냥 생략 |
| 모든 파일을 매 응답마다 자동 읽기 | 사용자가 요청하거나 명시적으로 필요할 때만 |
