import numpy as np


THRESHOLD = 100
SCALE = 1024


def calculate_distance(features, reference):
    """
    Calculate squared Euclidean distance.
    """

    features = np.array(features, dtype=np.int64)
    reference = np.array(reference, dtype=np.int64)

    difference = features - reference

    distance = np.sum(difference * difference)

    return int(distance)


def calculate_score(distance):
    """
    Convert distance into a hardware-friendly score.
    """

    score = distance // SCALE

    return max(0, int(score))


def classify(score):
    """
    Classify the input as normal or anomalous.
    """

    if score >= THRESHOLD:
        return "ANOMALY"

    return "NORMAL"


def run_inference(features, reference):

    distance = calculate_distance(
        features,
        reference
    )

    score = calculate_score(distance)

    result = classify(score)

    return distance, score, result


if __name__ == "__main__":

    reference = [
        100,
        200,
        300,
        400
    ]


    # -----------------------------------------------
    # Normal sample
    # -----------------------------------------------

    normal_sample = [
        102,
        201,
        299,
        405
    ]

    distance, score, result = run_inference(
        normal_sample,
        reference
    )

    print("===================================")
    print("NORMAL SAMPLE")
    print("===================================")

    print("Input        :", normal_sample)
    print("Reference    :", reference)
    print("Distance     :", distance)
    print("Score        :", score)
    print("Classification:", result)


    # -----------------------------------------------
    # Anomalous sample
    # -----------------------------------------------

    anomaly_sample = [
        500,
        20,
        800,
        100
    ]

    distance, score, result = run_inference(
        anomaly_sample,
        reference
    )

    print()
    print("===================================")
    print("ANOMALOUS SAMPLE")
    print("===================================")

    print("Input        :", anomaly_sample)
    print("Reference    :", reference)
    print("Distance     :", distance)
    print("Score        :", score)
    print("Classification:", result)


    # -----------------------------------------------
    # Verification
    # -----------------------------------------------

    normal_distance, normal_score, normal_result = run_inference(
        normal_sample,
        reference
    )

    anomaly_distance, anomaly_score, anomaly_result = run_inference(
        anomaly_sample,
        reference
    )


    assert normal_result == "NORMAL"
    assert anomaly_result == "ANOMALY"

    print()
    print("===================================")
    print("REFERENCE MODEL PASSED")
    print("===================================")
