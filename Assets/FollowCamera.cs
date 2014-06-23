using UnityEngine;
using System.Collections;

public class FollowCamera : MonoBehaviour
{
	public Transform follow;

	private Quaternion referenceRotation;
	public float distance;
	public float angularVelocity;
	public float AngleFromGround = 20f;
	private float rotation = 0f;
	public float maxAngleDistance = 30f;

	void Start()
	{
		rotation = follow.eulerAngles.y;
	}
	
	void Update()
	{
		float velocity = 0f;
		float angleDistance = Mathf.Abs(Mathf.DeltaAngle(rotation, follow.eulerAngles.y));

		velocity = angularVelocity;
		if(angleDistance > maxAngleDistance)
			velocity = (angleDistance-maxAngleDistance) / Time.deltaTime;

		rotation = Mathf.MoveTowardsAngle(rotation, follow.eulerAngles.y, Time.deltaTime * velocity);
		Quaternion cameraAxis = Quaternion.AngleAxis(rotation, Vector3.up) * Quaternion.AngleAxis(AngleFromGround, Vector3.right);
		transform.position = follow.position + cameraAxis * (-Vector3.forward * distance);
		transform.LookAt(follow);
	}
}

// using UnityEngine;
// using System.Collections;

// public class FollowCamera : MonoBehaviour
// {
// 	public Transform follow;

// 	private Quaternion referenceRotation;
// 	private float distance;
// 	public float angularVelocity = 360;

// 	void Start()
// 	{
// 		referenceRotation = Quaternion.Inverse(Quaternion.FromToRotation(Vector3.forward, follow.position - transform.position));
// 		distance = (transform.position-follow.position).magnitude;
// 	}
	
// 	void Update()
// 	{
// 		// Soft position
// 		Quaternion r1 = Quaternion.FromToRotation(Vector3.forward, transform.position - follow.position);
// 		// Rigid position
// 		Quaternion r2 = Quaternion.FromToRotation(Vector3.forward, follow.rotation * referenceRotation * (Vector3.forward * distance));
// 		// Interpolate
// 		Quaternion res = Quaternion.RotateTowards(r1, r2, angularVelocity * Time.deltaTime);

// 		transform.position = follow.position + (res * Vector3.forward) * distance;
// 		transform.LookAt(follow);
// 		Debug.DrawLine(follow.position, follow.position + (r1 * Vector3.forward) * distance, Color.red);
// 		Debug.DrawLine(follow.position, follow.position + (r2 * Vector3.forward) * distance, Color.blue);
// 		Debug.DrawLine(follow.position, follow.position + (res * Vector3.forward) * distance, Color.green);
// 	}
// }
