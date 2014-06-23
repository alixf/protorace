using UnityEngine;
using System.Collections;

public class Car : MonoBehaviour
{
	public float acceleration;
	public Transform[] turningWheels;
	public WheelCollider[] driveWheels;
	public float turningAngle = 5f;
	public float turningSpeed = 100f;
	public float wheelAngle = 0f;

	void Start()
	{
		rigidbody.centerOfMass = Vector3.zero;
	}
	
	void Update()
	{
		float driveFactor = 0f;
		foreach(WheelCollider wheel in driveWheels)
		{
			if(wheel.isGrounded)
				driveFactor += 1f / driveWheels.Length;
		}

		if(Input.GetKey("z"))
			rigidbody.AddForce(acceleration * transform.forward * Time.deltaTime * driveFactor);
		if(Input.GetKey("s"))
			rigidbody.AddForce(acceleration * -transform.forward * Time.deltaTime * driveFactor);

		if(Input.GetKey("q"))
		{
			if(wheelAngle > -turningAngle)
			{
				wheelAngle += -turningSpeed * Time.deltaTime;
				if(wheelAngle < -turningAngle)
					wheelAngle = -turningAngle;
			}
		}
		else if(Input.GetKey("d"))
		{
			if(wheelAngle < turningAngle)
			{
				wheelAngle += turningSpeed * Time.deltaTime;
				if(wheelAngle > turningAngle)
					wheelAngle = turningAngle;
			}
		}
		else
		{
			if(wheelAngle < 0f)
			{
				wheelAngle += turningSpeed * Time.deltaTime;
				if(wheelAngle > 0f)
					wheelAngle = 0f;
			}
			else if(wheelAngle > 0f)
			{
				wheelAngle -= turningSpeed * Time.deltaTime;
				if(wheelAngle < 0f)
					wheelAngle = 0f;
			}		
		}

		foreach(Transform wheel in turningWheels)
			wheel.localEulerAngles = new Vector3(wheel.localEulerAngles.x, wheelAngle, wheel.localEulerAngles.z);
	}
}
