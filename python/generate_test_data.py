import numpy as np


np.random.seed(42)


# ------------------------------------------------
# Configuration
# ------------------------------------------------

NUM_NORMAL = 100
NUM_ANOMALY = 100

REFERENCE = np.array(
    [100, 200, 300, 400],
    dtype=np.int32
)

NORMAL_NOISE = 5


# ------------------------------------------------
# Generate normal sensor data
# ------------------------------------------------

normal_data = []

for _ in range(NUM_NORMAL):

    noise = np.random.randint(
        -NORMAL_NOISE,
        NORMAL_NOISE + 1,
        size=4
    )

    sample = REFERENCE + noise

    normal_data.append(sample)


# ------------------------------------------------
# Generate anomalous sensor data
# ------------------------------------------------

anomaly_data = []

for _ in range(NUM_ANOMALY):

    sample = np.random.randint(
        0,
        1000,
        size=4
    )

    anomaly_data.append(sample)


normal_data = np.array(
    normal_data,
    dtype=np.int32
)

anomaly_data = np.array(
    anomaly_data,
    dtype=np.int32
)


# ------------------------------------------------
# Save datasets
# ------------------------------------------------

np.savetxt(
    "normal_samples.csv",
    normal_data,
    fmt="%d",
    delimiter=",",
    header="sensor0,sensor1,sensor2,sensor3",
    comments=""
)

np.savetxt(
    "anomaly_samples.csv",
    anomaly_data,
    fmt="%d",
    delimiter=",",
    header="sensor0,sensor1,sensor2,sensor3",
    comments=""
)


# ------------------------------------------------
# Display summary
# ------------------------------------------------

print("===================================")
print("AI TEST DATA GENERATOR")
print("===================================")

print("Reference:", REFERENCE)

print()
print("Normal samples :", len(normal_data))
print("Anomaly samples:", len(anomaly_data))

print()
print("Example normal sample:")
print(normal_data[0])

print()
print("Example anomaly sample:")
print(anomaly_data[0])

print()
print("Datasets generated successfully.")
