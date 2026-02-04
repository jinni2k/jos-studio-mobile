# jOS Studio Mobile

**ESP32용 모바일 개발 도구**

jOS 디바이스를 휴대폰에서 직접 제어하고 모니터링합니다.

## 주요 기능

- **USB OTG 연결**: Android에서 ESP32에 직접 연결
- **WiFi WebSocket**: 무선으로 디바이스 연결
- **jShell 터미널**: 명령어 직접 입력
- **DataTable 뷰어**: 실시간 데이터 모니터링
- **다중 디바이스 관리**: 여러 ESP32 관리

## 기술 스택

- Flutter 3.24+
- USB Serial (usb_serial)
- WebSocket (web_socket_channel)
- Provider (상태 관리)

## 빌드

```bash
# 의존성 설치
flutter pub get

# Android APK 빌드
flutter build apk --release
```

## 연결 방식

| 방식 | 플랫폼 | 상태 |
|------|--------|------|
| USB OTG | Android | ✅ 지원 |
| WiFi WebSocket | Android/iOS | ✅ 지원 |
| BLE | - | ❌ jOS에서 제거됨 |

## jShell 명령어

jOS-Studio Desktop과 동일한 명령어 체계를 사용합니다:

```
sys         # 시스템 정보
ps          # 프로세스 목록
wifi info   # WiFi 상태
lora 0 status  # LoRa 상태
reboot      # 재부팅
```

## 라이선스

MIT License

## 관련 프로젝트

- [jOS](../jOS/) - ESP32 프레임워크
- [jOS-Studio](../jOS-Studio/) - 데스크톱 IDE
