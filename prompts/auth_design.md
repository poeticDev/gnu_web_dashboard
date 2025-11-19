# MDK 관제 웹앱 로그인 및 인증 설계 문서

## 0. 목적
이 문서는 MDK에서 개발 중인 **관제 웹앱(Local Unified Control System Dashboard)** 의 인증, 세션, 권한 구조를 정의한다.  
학교별 망 환경(공인 IP / 사설 IP / 내부망 / 포트포워딩)에 상관없이 **공통적인 앱 레벨 설계**를 유지하기 위한 기준이다.

---

## 1. 인증 및 세션 관리 방식

### 1.1. 기본 원칙
- **세션 + 쿠키 기반 로그인 방식**
- 서버에서 `sessionId`를 관리하고, 브라우저에는 `HttpOnly + Secure + SameSite=Lax` 쿠키로 전달
- Flutter Web은 쿠키를 자동으로 포함해 요청

### 1.2. 로그인 플로우
1. 클라이언트가 `/api/login`으로 `username`, `password` 제출
2. 서버에서 비밀번호 검증 후:
    - 전체 활성 세션 수 확인
    - 사용자별 세션 수 확인
    - 조건에 맞지 않으면 로그인 거부 또는 기존 세션 종료(단,'admin' 권한 계정의 경우 항상 로그인 가능)
3. 세션 생성 후 `sid` 쿠키 발급
4. 이후 요청마다 쿠키를 포함해 인증

### 1.3. 세션 정책
- **Idle Timeout:** 30분 미사용 시 자동 로그아웃
- **Absolute Timeout:** 생성 후 8시간
- **동시 접속 제한:**
    - `MAX_GLOBAL_SESSIONS`: 전체 n명 제한
    - `MAX_SESSIONS_PER_USER`: 1~2개 제한 (기존 세션 자동 종료)
- **로그아웃 시나리오:**
    - 수동 로그아웃
    - Idle Timeout
    - Absolute Timeout
    - 새로운 로그인 발생 시 이전 세션 종료

---

## 2. 권한(Role) 구조

| 역할 | 설명 |
|------|------|
| `viewer` | 모니터링 전용 (장비 제어 불가) |
| `operator` | 일반 장비 제어 가능 |
| `admin` | 사용자 관리 및 시스템 설정 가능 |

- `requireRole()` 미들웨어로 접근 제어
- 역할별 UI 표시/숨김 제어

---

## 3. DB 스키마 설계

### 3.1. users
| 필드 | 타입 | 설명 |
|------|------|------|
| id | PK | 고유 ID |
| username | string | 로그인 ID |
| password_hash | string | bcrypt 해시 |
| display_name | string | 사용자명 |
| email | string | 선택 |
| is_active | bool | 활성 상태 |
| last_login_at | datetime | 마지막 로그인 시간 |
| auth_type | enum(local/sso/ldap) | 인증 방식 |
| tenant_id | string | 학교 구분용 (선택) |

### 3.2. roles / user_roles
| 테이블 | 필드 | 설명 |
|--------|-------|------|
| roles | name | viewer / operator / admin |
| user_roles | user_id, role_id | 다대다 관계 |

또는 단순히 `users.role` 컬럼으로 관리 가능.

### 3.3. sessions
| 필드 | 타입 | 설명 |
|------|------|------|
| id | string | sessionId (랜덤 토큰) |
| user_id | FK | users.id |
| created_at | datetime | 세션 생성 시각 |
| last_seen_at | datetime | 마지막 활동 시각 |
| expires_at | datetime | 절대 만료 시각 |
| ip_address | string | 접속 IP |
| user_agent | string | 브라우저 정보 |
| is_active | bool | 활성 여부 |
| terminated_reason | string | 종료 이유 |

### 3.4. audit_logs
| 필드 | 타입 | 설명 |
|------|------|------|
| id | PK | 로그 ID |
| user_id | FK | users.id (nullable) |
| action | string | LOGIN, LOGOUT, DEVICE_ON, etc |
| target | string | 장비 또는 리소스 식별자 |
| meta | json | 추가 정보 |
| ip_address | string | 요청 IP |
| created_at | datetime | 생성 시각 |

---

## 4. API 엔드포인트 설계

| 메서드 | 경로 | 설명 |
|--------|------|------|
| `POST /api/login` | 로그인 시도, 세션 생성 |
| `POST /api/logout` | 세션 종료 |
| `GET /api/me` | 현재 세션의 사용자 정보 |
| `GET /api/my-sessions` | 자신의 활성 세션 목록 (선택) |
| `DELETE /api/my-sessions/:id` | 다른 세션 강제 로그아웃 (선택) |
| `GET /api/admin/sessions` | (관리자) 전체 세션 모니터링 |

### 미들웨어
- 모든 `/api/**` 요청은 `sid` 쿠키 기반 인증 수행
- 세션 유효성 검사 후 `req.user`에 사용자 정보 바인딩
- 역할 확인 미들웨어(`requireRole`)로 접근 제어

---

## 5. Flutter Web 구조 개요

### 5.1. 상태 관리
- `AuthRepository`
    - `login(username, password)`
    - `logout()`
    - `fetchMe()`
- `AuthController` (Riverpod Notifier)
    - `state` → `user`, `roles`, `isLoggedIn`
    - 앱 시작 시 `/api/me` 호출로 로그인 복구

### 5.2. 라우터 가드
| 구분 | 설명 |
|------|------|
| `AuthGuard` | 로그인하지 않으면 `/login` 리다이렉트 |
| `AdminGuard` | `admin` 역할만 접근 가능 |

### 5.3. Idle Timeout UX
- 마지막 사용자 입력시간 로컬로 추적
- 25분째에 “곧 로그아웃됩니다” 모달 표시
- `연장` 클릭 시 `/api/me` 호출로 세션 갱신
- 실제 만료 시 서버에서 401 응답 → 로그인 화면 이동

---

## 6. 네트워크/배포 시 고려사항 (요약)

| 환경 | 대응 방안 |
|------|-----------|
| 내부망 전용 | 방화벽 차단, HTTPS 권장, 로그인 필수 |
| 포트포워딩(외부 접근 허용) | HTTPS + 방화벽(IP 제한) + VPN/Proxy 권장 |
| 공인IP / 도메인 보유 | Reverse Proxy(WAF) + SSO 연동 고려 |
| 멀티 캠퍼스 배포 | 공통 코드 유지, `config.{school}.yaml`로 설정 분리 |

---

## 7. 개발 단계 요약

1. **Auth DB 테이블 구성**  
   (`users`, `roles`, `sessions`, `audit_logs`)
2. **Auth API 구현**  
   (`/login`, `/logout`, `/me` 등)
3. **미들웨어 구현**
    - 세션 유효성 검사
    - Idle Timeout 관리
    - Role 기반 접근 제어
4. **Flutter Auth Layer 구축**
    - Riverpod Provider
    - Router Guard
    - Idle UX
5. **테스트 시나리오 작성**
    - 동시 접속 제한 테스트 (전역/유저별)
    - Timeout/만료 테스트
    - 권한별 접근 제한 검증

---

## 8. 확장 계획

| 단계 | 기능 |
|------|------|
| Phase 1 | 세션 + 쿠키 기반 로그인 (현재 설계) |
| Phase 2 | 학교별 SSO(OIDC/SAML) 연동 |
| Phase 3 | 관리자 MFA(2FA) 적용 |
| Phase 4 | 세션 클러스터링 / Redis 공유 세션 |
| Phase 5 | 감사 로그 분석 및 대시보드 시각화 |

---

## 9. 핵심 설계 요약

- **인증 구조:** 서버 세션 + 쿠키 기반
- **권한 분리:** viewer / operator / admin
- **보안 정책:** 30분 Idle, 8시간 절대 만료
- **동시 접속 제한:** 전역 + 사용자별
- **네트워크 환경:** 내부망/외부망 모두 대응 가능한 구조
- **확장성:** 학교별 설정 분리 및 SSO 연동 가능

---

**파일명 제안:** `auth_design.md`  
**작성일:** 2025-11-04  
**작성자:** 김휴고 / ChatGPT 협업 설계
