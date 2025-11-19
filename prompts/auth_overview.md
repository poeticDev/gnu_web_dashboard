# Authentication System Overview (v2)

## 목적
한 학교 단위의 **관제 웹앱(Local Unified Control System Dashboard)** 에서
직원, 교수, 관리자가 사용하는 **로그인 / 세션 / 권한 관리 체계**를 정의한다.
모든 강의실은 `ROOMS` 테이블로 관리되며,
`room_id`는 학교 이니셜 기반 네이밍(`GNU_604`, `GHU_Studio1`)을 따른다.

---

## 구성 문서

| 문서 | 내용 |
|------|------|
| [`auth_flows.md`](./auth_flows.md) | 로그인, 세션, 권한 플로우 정의 |
| [`auth_db_schema.md`](./auth_db_schema.md) | 서버 및 앱 DB 구조 |
| [`auth_roles.md`](./auth_roles.md) | 역할 정의 및 접근 권한 정책 |
| [`auth_api.md`](./auth_api.md) | 주요 인증 관련 API 요약 |
| [`auth_checklist.md`](./auth_checklist.md) | 개발 및 테스트 항목 정리 |

---

## 핵심 요약

| 항목 | 값 |
|------|----|
| 인증 방식 | 서버 세션 + 쿠키 기반 |
| 쿠키 설정 | HttpOnly, Secure, SameSite=Lax |
| 세션 타임아웃 | Idle 30분, Absolute 8시간 |
| 동시 접속 제한 | 전역 + 사용자별 (자동 kick 정책) |
| Role 구조 | viewer / operator / admin |
| 강의실 구분 | ROOMS 테이블, ID = 학교코드_호수 |
| 앱 연동 방식 | 서버 ↔ Drift(Local DB) 동기화 |
