# ASCVD Risk Calculator

This ASCVD Risk calculator is used to study the risk prediction for cardiovascular disease (CVD).

This calculator uses the Pooled Cohort risk prediction equations to predict 10-year atherosclerotic cardiovascular disease risk. More information about the predictor equation can be found here https://github.com/bcjaeger/PooledCohort/tree/master

## Changes in this fork

This repository is forked from [bcbi/ASCVD-Risk-Calculator](https://github.com/bcbi/ASCVD-Risk-Calculator) and introduces the following changes:

- **Configuration via `.env`** — R paths (`R_HOME`, `R_USER`) are now read from the `.env` file instead of being hardcoded in `src/app.py`. A `.env.example` template is included; the real `.env` is gitignored.
- **Blood pressure fetched from BP panel** — `get_blood_pressure()` queries the FHIR blood pressure panel (LOINC `85354-9`) and extracts systolic/diastolic values from its components. The original fetched `8480-6` and `8462-4` as standalone observations, which often miss data on FHIR servers that store BP as a panel.
- **Input validation on risk calculation** — `/calculate_risk` now validates form inputs and renders a friendly error banner listing the required fields if any are missing or non-numeric, instead of crashing with `ValueError` on `'Not Found'` values.
- **`FHIR_PORT` is optional** — Defaults to `5002` if not set in `.env`, instead of raising `KeyError`.
- **Dependencies** — `pandas` added to `requirements.txt`; `setup_environment.sh` now also installs the R `PooledCohort` package automatically.
- **Gitignore hygiene** — `.env` and `.DS_Store` are gitignored.

# Steps to run the ASCVD Risk Calculator

## 1. Check if R and python are installed where you are running this app.

```
python3 --version
R --version
```

## 2. Clone the repo
```
git clone https://github.com/fmaroof/ASCVD-Risk-Calculator.git

cd ASCVD-Risk-Calculator
```

## 3. Configure the .env file

Copy `.env.example` to `.env` and fill in the values. Use the port number assigned to you for `FHIR_PORT`.

```
cp .env.example .env
```

To find the R paths for `R_HOME` and `R_USER`, run:

```
Rscript -e 'cat("R.home():\n"); print(R.home()); cat("\n.libPaths():\n"); print(.libPaths())'

> R.home()
[1] "/Library/Frameworks/R.framework/Resources"
> .libPaths()
[1] "/Library/Frameworks/R.framework/Versions/4.3-arm64/Resources/library"
```

## 4. Run the setup script
```
./setup_environment.sh
```

## 5. Activate the virtual environment
```
source venv/bin/activate
```

## 6. Run the flask app
```
python src/app.py
```

This will start the app on port "FHIR_PORT". You can open your preferred browser and see the app running on `http://localhost:FHIR_PORT` replace the FHIR_PORT with the actual port number assigned to you.
The exact URL to the app can also be found on the terminal output after running the app.

## Notes

- `get_blood_pressure()` in `src/app.py` selects the most recent BP panel using `effectiveDateTime`. This assumes every returned entry includes that field. If the FHIR server ever returns a BP observation without `effectiveDateTime`, the lookup will raise `KeyError`. If that becomes a problem, change `e['resource']['effectiveDateTime']` to `e['resource'].get('effectiveDateTime', '')` in the `max()` key.


