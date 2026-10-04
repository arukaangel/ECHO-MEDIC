# Model and evaluation

## Simulator boundary

32 panels form four rows of eight. Every panel has a hidden defect class, normalised severity, isolation state and optional load reduction. A seeded PRNG generates Gaussian measurement noise. The model is a surrogate, not a vibration PDE/finite-element simulation. Material properties, real modal frequencies, pressure, thermal dynamics, vacuum acoustics, collision forces and flightworthiness are not modelled. The audio and displayed impulse response are illustrations synthesised from measured features.

The hidden world is a private Mission field. Policy receives only an observation `{panel, features, noise, at, robot}`. It never receives the defect configuration. Before reveal, JSON exports redact the defect list. This is an experiment-design boundary, not cryptographic protection in a client application.

## Inference

Four states: healthy, loose fastener, delamination, microcrack. Prior probabilities: 0.79 / 0.07 / 0.07 / 0.07. Defective states have severity hypotheses 0.25, 0.45, 0.65, 0.85, 1.0. The likelihood is a diagonal Gaussian over enabled features using the assumed signature and `(configured noise + 0.06)` as standard deviation. Log likelihoods are normalised with a max subtraction. The last four readings at a panel are used to limit stale evidence. No temporal filter is fitted. Diagnosis probabilities are conditional on these assumptions and are not calibrated confidence for real materials.

Active inspection is a heuristic balancing unexplored panels, posterior entropy, uncertain anomaly probability and neighbouring anomalies. Sequential inspection visits panels in row-major order and repeats that order. Both use the same classifier and at most four visits per panel. No global optimality or trained ML claim is made.

## Robots and energy

Two agents move on a Manhattan panel-index grid. The scheduler selects the nearest available agent, breaking ties by available energy. A measurement costs 1.6 + 0.12 × grid distance energy units and 2 + 0.3 × distance simulated seconds. Offline or low-energy robots are excluded. There is no docking/recharging or continuous manipulator simulation. A robot requires at least 4 energy units to measure and 20 to begin an intervention safely.

## Damage and repair

Each automated inspection step increases unisolated damage by 0.0025 (1.5 times faster for cracks). A manually applied thermal cycle increases severity by 0.09 and elapsed time by 30 simulated seconds. A reduced-load panel grows at 40% of its previous rate. Isolation stops growth without healing. A correctly matched repair succeeds with probability 0.82; if successful, severity falls to 12% of its prior value, and sufficiently small defects are treated as repaired. A failed or mismatched repair only reduces severity by 4%. These parameters are demonstrative assumptions.

Repair costs 9 energy units and 12 seconds, then clears prior evidence and obtains three new readings. Verification consumes extra measurements outside the inspection budget and normal sensor energy. Anomaly posterior below 0.35 is labelled verification passed. Otherwise the residual anomaly is reported. Re-inspect collects one extra reading without repairing. Forecasts use the inferred severity and assumed growth, with ±0.14 scenario bands; the bands are illustrative, not statistical confidence intervals.

## Evaluation

Predicted anomaly threshold: posterior > 0.65. Ground truth anomaly: nonhealthy type with severity > 0.12. Current-mission metrics reflect the world at reveal, after any repairs. Benchmark scenarios contain two distinct random defect panels, random types and severities 0.45–0.95. Both policies use the same per-scenario seed, maximum measurements and noise. Growth is frozen and there are no repairs. Measurement order changes which panel receives each PRNG noise draw; this is controlled reproducibility, not identical per-panel noise pairing.

Report true positives, false positives, false negatives, recall, energy, time and coverage. Never replace a losing comparison with a hard-coded improvement. The included 40-scenario default test is an illustration, not an independent scientific validation set; generator and classifier share model assumptions.

## Validation performed

Node engine tests cover reproducibility, hidden-state separation, resource constraints, robot failure, repair verification, sensor outages and benchmark parity. A DOM smoke harness tested page wiring, single-step inspection, targeted measurement, repairs, crew toggles, thermal cycles, benchmarking, truth reveal and reset. Full WebGL browser rendering and browser-native WebMCP validation were unavailable in the build environment. Test on the actual presentation laptop before the event.

## Design reference

https://reallygooddesigns.com/web-design-trends-2026/

Direction informed by its interactive 3D, dynamic typography and exploratory layout examples. The original layout and images are not copied. Typography: Cormorant Garamond display + Manrope UI. All site assets are bundled locally.
