using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Portal : MonoBehaviour
{
	public Transform linkTo = null;
	public bool teleport = false;
	private Dictionary<Transform, Transform> objects = new Dictionary<Transform, Transform>();

	void Start () 
	{
	}

	void Update () 
	{
		// foreach(KeyValuePair<Transform, Transform> entry in objects)
		// {
		// 	recomputePosition(entry.Value, entry.Key);
		// }
		updateCamera();
	}

	void OnTriggerEnter(Collider obj)
	{
		if(linkTo != null && teleport)
		{
			// Transform clone = Instantiate(obj.transform) as Transform;
			// objects.Add(obj.transform, clone);

			Transform car = obj.transform;
			Vector3 localPosition = transform.InverseTransformPoint(car.position);
			localPosition = new Vector3(-localPosition.x,localPosition.y,localPosition.z);
			car.position = linkTo.TransformPoint(localPosition);

			car.rotation = car.rotation * Quaternion.Inverse(transform.rotation) * linkTo.rotation * Quaternion.AngleAxis(180, Vector3.up);
			car.rigidbody.velocity = Quaternion.Inverse(transform.rotation) * linkTo.rotation * Quaternion.AngleAxis(180, Vector3.up) * car.rigidbody.velocity;

			if(linkTo.Find("camera").GetComponent<Skybox>())
				Camera.main.GetComponent<Skybox>().material = linkTo.Find("camera").GetComponent<Skybox>().material;
			// Quaternion localDirection = car.rotation - transform.rotation;
			// localPosition = new Vector3(-localPosition.x,localPosition.y,localPosition.z);
			// car.rotation = localDirection + linkTo.rotation;
		}
	}

	void OnTriggerLeave(Collider other)
	{
	}

	void recomputePosition(Transform obj, Transform clone)
	{
		Vector3 pos = transform.InverseTransformPoint(obj.position);
		clone.parent = linkTo;
		clone.localPosition = pos * -1;
	}

	void updateCamera()
	{
	// 	if(linkTo != null)
	// 	{
	// 		var camera = linkTo.Find("camera");
	// 		camera.rotation = Quaternion.Inverse(Camera.main.transform.rotation * transform.rotation * linkTo.rotation);
	// 	}
	}
}
