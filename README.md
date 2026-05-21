# ASCVD Risk Calculator

This ASCVD Risk calculator is used to study the risk prediction for cardiovascular disease (CVD).

This calculator uses the Pooled Cohort risk prediction equations to predict 10-year atherosclerotic cardiovascular disease risk. More information about the predictor equation can be found here https://github.com/bcjaeger/PooledCohort/tree/master

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


