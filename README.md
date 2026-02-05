# URL Shortener — Clean Architecture + Hexagonal

📌 **Goal**: Build a decoupled, scalable, testable, and maintainable solution without over‑engineering the challenge scope.

---

## 📐 Solution Overview

This project was designed with architectural clarity and intentional technical decisions. The approach focuses on:

- **Decoupled layers** with clear responsibilities
- **Framework independence** for core logic
- **Testability** as a first‑class concern
- **Scalability** without unnecessary complexity

---

## 🧠 Thought Process

### 1) Understanding the Challenge

Before writing code, the focus was to **fully understand the problem** and expected behaviors.
Only after the requirements were clear did the implementation begin.

### 2) Technical Planning

**URL Validation**
- Should it be strict or flexible?
- What formats should be accepted?

✅ **Decision**: Validate essential correctness only, keeping it flexible for future changes.

**Data Duplication**
- Should duplicate URLs be blocked?

✅ **Decision**: No duplication rule for now (no explicit requirement). The architecture allows adding this later.

**Architecture**
Considered: Clean, Hexagonal, MVVM, BLoC, ChangeNotifier, RxDart + Streams.

✅ **Decision**: **Clean Architecture + Hexagonal thinking**, using RxDart for state streams.

### 3) Presentation Layer (VIEW)

**RxDart + Streams** with explicit controller state:
- Low coupling with UI
- Easy to test
- Scales well

### 4) System Design

**Atomic Design** for UI components:
- Atoms → Molecules → Templates
- High reuse and consistency

### 5) Infrastructure & HTTP

✅ **Decision**: Keep HTTP integration simple for single API usage.

Even with simplified infra:
- New APIs can be added easily
- A more generic REST layer can be introduced later

---

## 🧱 Architecture Overview

<img width="1238" height="286" alt="image" src="https://github.com/user-attachments/assets/0160a5d6-24ba-4aed-89e0-4b95132b6b3a" />
<img width="1239" height="287" alt="image" src="https://github.com/user-attachments/assets/59402f06-0489-4169-a620-85a767089539" />
<img width="1238" height="288" alt="image" src="https://github.com/user-attachments/assets/f3e5414e-61a4-47ec-a381-bff2858730ec" />
<img width="1238" height="368" alt="image" src="https://github.com/user-attachments/assets/16f9208f-c566-4c44-ac14-f7f525965896" />

<img width="1018" height="742" alt="image" src="https://github.com/user-attachments/assets/ee1e4ea6-9c4a-40e2-a8fa-a46b0a091b34" />
<img width="1037" height="792" alt="image" src="https://github.com/user-attachments/assets/1dd44d93-48f2-40be-aacb-fd0d2f316a5e" />

---

## 🗂️ Project Structure (Simplified)

```
lib/
├── app/
│   ├── core/
│   ├── common/
│   └── feature/
│       └── shortened_url/
│           ├── data/
│           ├── domain/
│           ├── application/
│           └── presentation/
├── app_module.dart
└── main.dart

test/
├── unit/
└── widget/

integration_test/
└── success_flow.dart
```

---

## 🧪 Testing Strategy

**Priority Over Coverage**

Focus on **high‑value tests**:
- Error scenarios
- Invalid inputs
- Critical behaviors

### ✅ Unit & Widget Tests
Run all unit and widget tests:

```
flutter test
```

### ✅ Integration Tests
Run end‑to‑end tests (real API calls):

```
flutter drive --driver=test_driver/integration_test_driver.dart --target=integration_test/success_flow.dart -d windows
```

---

## 🔌 Real API Used

```
POST https://url-shortener-server.onrender.com/api/alias
```

---

## ✅ Example: Presentation Flow

**Controller emits state changes:**

```dart
await _safeExecutor.guard(
	() async {
		emitter.emit(HomeViewModel(state: HomeLoading()));
		final result = await _shortenUrlUseCase.call(_input);
		return switch (result) {
			Success(:final data) => _feedViewModel(data),
			Failure(:final error) => emitter.emitError(error),
		};
	},
);
```

---

## ✅ Example: URL Input Validation

```dart
return AppInput(
	onSaved: (value) {
		if (value != null) {
			input?.url = URL(value);
		}
	},
	validator: (value) => URL.validate(value ?? ''),
	inputController: urlController,
	hintText: 'Type URL here',
);
```

---

## ✅ Example: Use Case

```dart
final resp = await _port.shortenUrl(input);

if (resp.isEmpty) {
	return Failure('Valores inválidos. Não adicionar na lista');
}

return Success(resp);
```

---

## ✅ Example: UI List Rendering

```dart
Expanded(
	child: recentUrls.isEmpty
			? const EmptyUrl()
			: ListView.separated(
					itemCount: recentUrls.length,
					separatorBuilder: (context, index) => const SizedBox(height: 12),
					itemBuilder: (context, index) {
						return ShortenedUrlTile(alias: recentUrls[index].alias);
					},
				),
),
```

---

## ✅ Integration Test Scenario (Success Flow)

```
1. Input a valid URL
2. Tap the submit button
3. API is called
4. Result appears in the list
```

---

## ✅ Key Decisions Summary

| Area | Decision |
|------|----------|
| Validation | Flexible, essential correctness |
| Duplicates | Not enforced (no explicit requirement) |
| Architecture | Clean + Hexagonal |
| State Mgmt | RxDart + Streams |
| UI System | Atomic Design |
| HTTP | Simple client, no over‑engineering |
| Testing | Priority over coverage |

---

## ✅ How to Run

```
flutter pub get
flutter test
flutter drive --driver=test_driver/integration_test_driver.dart --target=integration_test/success_flow.dart -d windows
```

---

## ✅ Notes

- Integration tests use **real API calls**.
- A stable internet connection is required.
- The architecture supports future expansion with minimal refactoring.

---
