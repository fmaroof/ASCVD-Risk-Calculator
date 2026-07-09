# ASCVD Risk Calculator

This ASCVD Risk calculator is used to study the risk prediction for cardiovascular disease (CVD).

This calculator uses the Pooled Cohort risk prediction equations to predict 10-year atherosclerotic cardiovascular disease risk. More information about the predictor equation can be found here: <https://github.com/bcjaeger/PooledCohort/tree/master>

## Changes in this fork

This repository is forked from [bcbi/ASCVD-Risk-Calculator](https://github.com/bcbi/ASCVD-Risk-Calculator) and introduces the following changes:

- **Configuration via `.env`** — R paths (`R_HOME`, `R_USER`) and FHIR credentials are now read from the `.env` file instead of being hardcoded in `src/app.py`. A `.env.example` template is included; the real `.env` is gitignored.
- **Blood pressure fetched from BP panel** — `get_blood_pressure()` queries the FHIR blood pressure panel (LOINC `85354-9`) and extracts systolic/diastolic values from its components. The original fetched `8480-6` and `8462-4` as standalone observations.
- **Input validation on risk calculation** — `/calculate_risk` now validates form inputs and renders a friendly error banner listing the required fields if any are missing or non-numeric, instead of crashing with `ValueError` on `'Not Found'` values.
- **`FHIR_PORT` is configurable** — Defaults to `5002` if not set in `.env`, but can be customized to prevent port collisions on shared servers.
- **Unified Codebase / Multiple Environments** — Includes dedicated setup scripts (`setup_local.sh` and `setup_oscar.sh`) to allow the same Python code to run seamlessly on both personal laptops and the Oscar supercomputing cluster.
- **Dependencies** — `pandas` added to `requirements.txt`; the setup scripts now install the R `PooledCohort` package automatically.
- **Gitignore hygiene** — `.env` and `.DS_Store` are gitignored.

---

# Steps to run the ASCVD Risk Calculator

## 1. Clone the repo

```bash
git clone https://github.com/fmaroof/ASCVD-Risk-Calculator.git
cd ASCVD-Risk-Calculator
```

## 2. Configure the `.env` file

Copy the template file to create your active, hidden configuration file:

```bash
cp .env.example .env
```

Open `.env` and configure your settings. Pay special attention to the following:

- **`FHIR_PORT`**: If you are running this on a shared node (like Oscar), every student must use a unique port number (e.g., `5001`, `5002`, `5050`) to avoid an "Address already in use" crash.
- **`R_HOME` and `R_USER`**:
  - **If on Oscar:** Leave these entirely blank! Conda handles the R routing automatically.
  - **If on a local Mac/Laptop:** You must fill these in with your local system paths. You can find them by running the following in your terminal:

    ```bash
    Rscript -e 'cat("R.home():\n"); print(R.home()); cat("\n.libPaths():\n"); print(.libPaths())'
    ```

## 3. Setup and Run the App

Choose the set of instructions below that matches the computer you are currently using.

### Option A: Running Locally (Personal Mac/Laptop)

1. **Check your installations:** Ensure you have Python and R installed locally by running `python3 --version` and `R --version`.

2. **Run the local setup script:**

   ```bash
   ./setup_local.sh
   ```

3. **Activate the virtual environment:**

   ```bash
   source venv/bin/activate
   ```

4. **Run the Flask app:**

   ```bash
   python src/app.py
   ```

### Option B: Running on Oscar (Supercomputer Cluster)

1. **Run the Oscar setup script:** (Note: You must use the `source` command here so Conda can initialize properly.)

   ```bash
   source ./setup_oscar.sh
   ```

   This script installs Python packages from `requirements.txt` but filters out `rpy2` so that the Conda environment's R-backed `rpy2` package is used instead of pip building it.

2. **Verify Activation:** The environment `fhir-r-env` will activate automatically at the end of the script.

3. **Run the Flask app:**

   ```bash
   python src/app.py
   ```

## Accessing the App

Once the app is running, it will host on `http://localhost:FHIR_PORT` (replace `FHIR_PORT` with the actual port number you assigned in your `.env` file). The exact URL can also be found in your terminal output.

> **Note:** If using VS Code on Oscar, VS Code will automatically detect the active port and forward it securely to your local browser.

## Notes

`get_blood_pressure()` in `src/app.py` selects the most recent BP panel using `effectiveDateTime`. This assumes every returned entry includes that field. If the FHIR server ever returns a BP observation without `effectiveDateTime`, the lookup will raise `KeyError`. If that becomes a problem, change `e['resource']['effectiveDateTime']` to `e['resource'].get('effectiveDateTime', '')` in the `max()` key.