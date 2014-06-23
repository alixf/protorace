using UnityEngine;
using System.Collections;

public class CountLap : MonoBehaviour
{
	public UI ui;

	void OnTriggerEnter(Collider obj)
	{
		ui.CountLap();
	}
}
