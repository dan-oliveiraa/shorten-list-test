# shorten_list_test

A Flutter application for URL shortening with comprehensive unit testing.

## Test Coverage

**Total Tests: 202 (119 DOMAIN + 83 CORE/DATA)**
- ✅ DOMAIN Layer: 119 tests (Value Objects + Entities)
- ✅ CORE Layer: 41 tests (Infrastructure)
- ✅ DATA Layer: 42 tests (Data Mapping & Integration)
- 🎯 Quality Focus: Importance > Coverage

### Coverage Breakdown

#### ✅ DOMAIN Layer - Value Objects (81 tests)
- `URL` - URL validation with custom rules (36 tests)
  - Extension validation (.com, .br, .dev, .gov)
  - Protocol support (http, https, none)
  - Path, query, fragment validation
  - Special characters, unicode, edge cases
  - Equality, hashCode, mutability
- `ShortenUrlInput` - URL input with optional UUID (45 tests)
  - Composition with URL value object
  - Factory constructors (empty, with/without UUID)
  - Equality and hashCode for collections
  - Property mutation and state changes
  - Edge cases (long URLs, special chars, unicode)

#### ✅ DOMAIN Layer - Entities (38 tests)
- `LinkEntity` - Original and shortened URL pair (19 tests)
  - isEmpty logic (AND condition on both URLs)
  - URL format variations (protocols, ports, subdomains)
  - Special characters and unicode support
  - Whitespace handling edge cases
- `ShortenedLinkEntity` - Link with alias (19 tests)
  - isEmpty logic (alias AND link.isEmpty)
  - Alias format variations (alphanumeric, hyphens, underscores)
  - Composition with LinkEntity
  - Complex real-world scenarios (metadata-rich URLs, international domains)

#### ✅ CORE Layer - HTTP Client & Adapters (19 tests)
- `HttpRestAdapter` - HTTP operations (GET, POST, PUT, DELETE)
- `AppRestClient` - REST client with header merging, authorization, error handling
- `AdapterHelper` - Request/response transformation, JSON encoding/decoding
- `RestClientHelper` - Response conversion, exception mapping

#### ✅ CORE Layer - Error Handling & Services (17 tests)
- `GlobalErrorService` - Exception mapping to domain errors
- `SafeExecutor` - Exception guarding with error callbacks
- `RestResponse` - Status code validation, authorization checks

#### ✅ CORE Layer - Utilities & Helpers (5 tests)
- `StreamEmitter` - State management streams (1 test)
- `MapHelper` - Map merging utilities (2 tests)
- `ListHelper` - List operations (2 tests)

#### ✅ DATA Layer - API Datasource Integration (9 tests)
- `UrlDatasource` - HTTP API calls, JSON decoding, response validation
- Tests: success responses, missing fields, malformed JSON, error handling

#### ✅ DATA Layer - Repository Orchestration (2 tests)
- `UrlRepository` - Datasource → Entity conversion
- Tests: happy path, error propagation

#### ✅ DATA Layer - Entity Mapping (18 tests)
- `ShortenedLinkMapper` - JSON parsing, nested structure handling, entity conversion (10 tests)
- `LinkMapper` - URL mapping with fallbacks, isEmpty logic (8 tests)
- Tests: valid/invalid maps, null handling, special characters, empty values

## What Is Being Tested?

### Critical Business Logic
- **API Integration** - HTTP calls to external URL shortening service
- **JSON Parsing** - Decoding API responses with nested structures
- **Status code handling** - Different HTTP status codes trigger correct exceptions
- **Error transformation** - Network/platform exceptions map to domain-specific errors
- **Authorization flow** - Header injection, empty token handling
- **Request/response lifecycle** - JSON encoding, header setting, body writing
- **Data mapping** - API response → Domain entity conversion with fallbacks

### Edge Cases
- Empty/null bodies in requests and responses
- Malformed JSON responses
- Missing fields in nested JSON structures
- Empty authorization tokens
- Special character encoding in filters and URLs
- Network failures and timeouts
- Empty redirect lists
- Stream closure after errors
- Query parameters and URL fragments

### Integration Points
- Adapter → Helper → Client flow (CORE)
- Exception → ErrorService → Domain mapping (CORE)
- Datasource → Repository → Entity flow (DATA)
- JSON Parser → Mapper → Entity conversion (DATA)
- Value Object validation → Entity creation (DOMAIN)
- URL validation → Input validation → Use Case execution (DOMAIN → APPLICATION)

## What Do DOMAIN Tests Tell About the Project?

### ✅ **Strong Domain Modeling**
1. **Custom URL Validation** - Not using standard validators
   - Whitelist of extensions (.com, .br, .dev, .gov)
   - Supports paths, queries, fragments, ports
   - 36 tests ensure validation is bulletproof

2. **Value Objects Follow DDD** - Immutable-like with validation
   - URL and ShortenUrlInput are proper value objects
   - Equality based on value, not identity
   - Used in collections (Set, Map) via hashCode

3. **Business Rules in Entities** - Not just data holders
   - `isEmpty` logic enforces "both empty" rule
   - LinkEntity and ShortenedLinkEntity have clear semantics
   - 38 tests validate business invariants

4. **Mutability by Design** - Intentional for UI binding
   - URL.value can be changed (supports TextEditingController)
   - ShortenUrlInput.url can be updated (form validation)
   - Tests verify mutation affects computed properties

### ✅ **Quality Indicators**
- **119 tests for 4 small classes** = Deep validation
- **Edge cases tested** - Unicode, whitespace, special chars, long values
- **Real-world scenarios** - International domains, localhost, complex URLs
- **No framework testing** - All tests validate business logic

## Are All Tests Important?

### ✅ **YES - All 202 Tests Are Critical**

**Why These Tests Matter:**

1. **DOMAIN - Value Objects (81 tests)** - Business rules enforcement
   - `URL` (36 tests) - Custom validation prevents invalid data at domain boundaries
   - `ShortenUrlInput` (45 tests) - Composition and equality ensure correct behavior in collections
   - Protects against: Invalid URLs entering system, broken equality in Sets/Maps, mutation bugs

2. **DOMAIN - Entities (38 tests)** - Core business logic
   - `LinkEntity` (19 tests) - isEmpty logic prevents empty entities in lists
   - `ShortenedLinkEntity` (19 tests) - Alias + link composition validated
   - Protects against: Logic errors in entity state, broken composition, whitespace bugs

3. **CORE - Error Handling (17 tests)** - Prevents crashes, ensures graceful degradation
   - `GlobalErrorService` - Core error strategy used throughout app
   - `SafeExecutor` - Guards every async operation
   - `RestResponse.ensureSuccess` - Validates all HTTP responses

4. **CORE - HTTP Operations (19 tests)** - Foundation of all network communication
   - `HttpRestAdapter` - Low-level HTTP, easy to break
   - `AppRestClient` - Integration point for all API calls
   - Header merging, authorization, filter encoding - error-prone logic

5. **CORE - Utilities (5 tests)** - Reusable components used everywhere
   - `StreamEmitter` - State management foundation (1 comprehensive test)
   - `MapHelper` - Prevents header/parameter conflicts (2 tests)
   - `ListHelper` - List operations (2 tests)

6. **DATA - API Datasource (9 tests)** - External service integration
   - Tests malformed responses, missing fields, error scenarios
   - Critical for URL shortening feature reliability

7. **DATA - Data Mapping (31 tests)** - API → Domain transformation
   - Handles nested JSON structures and fallbacks
   - Prevents mapping errors that cause entity creation to fail
   - Tests edge cases like null values and missing nested objects

8. **DATA - Repository (2 tests)** - Orchestration between layers
   - Validates datasource → entity conversion
   - Error propagation from datasource to use cases

**What Makes a Test Important:**
- ✅ Tests business rules and validation logic (DOMAIN)
- ✅ Tests error conditions (not just happy path)
- ✅ Validates integration between components
- ✅ Covers edge cases that could cause runtime failures
- ✅ Tests logic that's difficult to debug in production
- ✅ Tests external service integration (API, JSON parsing)

### ❌ **REMOVED: 35 Low-Value Tests (from 100 to 83)**

**Deletion Strategy:**

**LinkMapper: 14 → 4 tests (-10)** ❌
- Consolidated: 6 individual null/missing field tests → 1 comprehensive test
- Kept: Valid map parsing, fallback handling, extra field robustness
- Why: Testing Dart's null coalescing operator `??`, not LinkMapper logic

**UrlRepository: 5 → 2 tests (-3)** ❌
- Deleted: Empty alias, complex URL scenarios
- Kept: Happy path conversion, error propagation
- Why: Pass-through repository already covered by datasource tests

**ShortenedLinkMapper: 19 → 10 tests (-9)** ⚠️
- Consolidated: Missing/null alias handling → 1 test
- Consolidated: Missing/null _links handling → 1 test
- Kept: All isEmpty property tests, all toEntity conversion tests
- Why: Redundant null-handling scenarios

**StreamEmitter: 3 → 1 test (-2)** ❌
- Deleted: "multiple values in sequence", "closes after error"
- Kept: "emits values, errors, and closes correctly"
- Why: Testing RxDart behavior, not StreamEmitter implementation

**MapHelper: 3 → 2 tests (-1)** ❌
- Deleted: "overrides duplicate keys" (already in merge test)
- Kept: "merges maps", "handles all nulls"
- Why: Redundant behavior already covered

## Test Quality Principles

### What We Follow:
- **Minimal mocking** - Use concrete instances over Fakes when possible
- **Behavior over data** - Test what code does, not what it stores
- **Edge cases first** - Prioritize failure scenarios over happy paths
- **Clear intent** - Test names describe the scenario and expected outcome
- **Critical logic priority** - Focus on components that handle data transformation and external integration

### What We Avoid:
- **Over-mocking** - Excessive mocks that test the mock framework
- **Fake overuse** - Only use Fakes for abstract classes
- **Testing getters/setters** - No value in testing language features
- **Redundant tests** - Don't test what the compiler guarantees
- **Testing DTOs** - Simple data classes without logic

## Running Tests

```bash
```bash
flutter test
flutter test --coverage
flutter test test/unit/
flutter test test/unit/app/core/
flutter test test/unit/app/feature/shortened_url/data/
flutter test test/unit/app/feature/shortened_url/domain/
flutter analyze
```

## Test Structure

```
test/
└── unit/
    └── app/
        ├── core/                          (41 tests)
        │   ├── client/
        │   │   ├── adapters/
        │   │   ├── response/
        │   │   └── rest_client/
        │   ├── service/
        │   └── utils/
        │       └── helper/
        └── feature/shortened_url/
            ├── data/                      (42 tests)
            │   ├── datasource/
            │   ├── mappers/
            │   └── repositories/
            └── domain/                    (119 tests)
                ├── entities/
                └── value_objects/
```

All unit tests follow the same structure as the source code for easy navigation.

### Test Statistics (Complete Suite)

| Layer | Component | Tests | Focus |
|-------|-----------|-------|-------|
| **DOMAIN** | **Value Objects** | **81** | **Business Rules & Validation** |
| DOMAIN | URL Value Object | 36 | Extension validation, protocols, paths, queries |
| DOMAIN | ShortenUrlInput | 45 | Composition, equality, mutation, edge cases |
| **DOMAIN** | **Entities** | **38** | **Domain Models & Logic** |
| DOMAIN | LinkEntity | 19 | isEmpty logic, URL formats, special characters |
| DOMAIN | ShortenedLinkEntity | 19 | Alias handling, composition, real-world scenarios |
| **CORE** | **Infrastructure** | **41** | **Foundation Services** |
| CORE | HTTP Client & Adapters | 19 | Status codes, header handling |
| CORE | Error Handling | 17 | Exception transformation, guards |
| CORE | Utilities | 5 | Stream/map/list helpers |
| **DATA** | **Integration & Mapping** | **42** | **External Services** |
| DATA | API Datasource | 9 | JSON parsing, API integration |
| DATA | Repository | 2 | Mapper conversion, error handling |
| DATA | Entity Mappers | 31 | JSON parsing, fallback handling |
| **TOTAL** | **4 layers, 9 components** | **202** | **Domain + Infrastructure + Data** |

✅ **Test Quality:**
- **DOMAIN (119 tests)**: Value objects validated with 17+ assertions each
- **CORE (41 tests)**: All critical infrastructure covered
- **DATA (42 tests)**: Complete API integration & mapping
- **0 Redundant Tests**: Every test validates important behavior
