# Authentication Flows

## 로그인

1. 사용자 입력 → `/api/login` 호출
2. 서버: 사용자 검증 → 세션 생성 → sid 쿠키 발급
3. 클라이언트: 쿠키 자동 저장, 이후 요청마다 sid 포함
4. 서버: 쿠키 인증 미들웨어에서 세션 유효성 검증

## 세션 유지

- Idle Timeout: 30분
- Absolute Timeout: 8시간
- 비활성 세션은 자동 종료 (`terminated_reason = timeout`)
- `last_seen_at`은 요청마다 갱신

## 권한 체크

- `/api/rooms/:id/state` → `viewer` 이상
- `/api/rooms/:id/control` → `operator` 이상
- `/api/admin/**` → `admin` 전용

    ## 로그아웃

    - `/api/logout` 호출 시:
    - `SESSIONS.is_active = false`
    - `terminated_reason = user_logout`
