# Project Context: Car Evaluation Assistant (testcar)

## Project Overview
**Name:** Car Evaluation Assistant (購車評估助手)
**Description:** A Flutter application designed to help users evaluate and compare vehicles based on price, specifications, fuel consumption, and ownership costs (including Taiwan-specific tax calculations).

## Tech Stack
*   **Framework:** Flutter (Dart)
*   **State Management:** Provider (`provider` package)
*   **Scripting:** Python (for data simulation/scraping)
*   **Linting:** `flutter_lints`

## Directory Structure
*   `lib/`
    *   `main.dart`: Application entry point. Sets up `MultiProvider` and routing.
    *   `models/`: Data models.
        *   `vehicle_model.dart`: Core vehicle model including logic for Taiwan License/Fuel tax calculation.
    *   `providers/`: State management logic (`AuthProvider`, `EvaluationProvider`, `VehicleProvider`).
    *   `screens/`: UI Screens (`LoginScreen`, `HomeScreen`, etc.).
*   `scripts/`
    *   `update_prices.py`: A Python script that simulates scraping car prices (Toyota, Ford, Honda) and generates a `vehicles.json` data file.

## Setup & Development

### Prerequisites
*   Flutter SDK
*   Python 3.x

### Running the Application
1.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```
2.  **Run the App:**
    ```bash
    flutter run
    ```

### Updating Data
The vehicle data is managed/simulated via a Python script. To update the underlying data (mock scraping):
```bash
python scripts/update_prices.py
```
This will generate/update `vehicles.json`.

## Key Features
*   **Tax Calculation:** Automatic calculation of Taiwan's License and Fuel taxes based on engine displacement (cc) in `Vehicle.licenseTax` and `Vehicle.fuelTax`.
*   **Cost Analysis:** Includes maintenance costs (0-60k km) and parts prices for comparison.
*   **Authentication:** Basic auth flow (Login/Home) handled via `AuthProvider`.

## Development Conventions
*   Follow standard Flutter coding guidelines.
*   Linting is enforced via `analysis_options.yaml` (default `flutter_lints`).
*   Logic for specific calculations (like taxes) resides in the Model class (`Vehicle`).
