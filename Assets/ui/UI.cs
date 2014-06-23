using UnityEngine;
using System.Collections;

public class UI : MonoBehaviour
{
	public GUIText speed;
	public GUIText chrono;
	public GUIText bestLap;
	public Rigidbody car;

	private float clock;
	private float bestlapclock = Mathf.Infinity;

	void Start ()
	{
		bestLap.text = "Best Lap :\n--:--:--";
	}
	
	void Update ()
	{
		clock += Time.deltaTime;
		speed.text = (int) (car.velocity.magnitude * 5) + " km/h";

		int v1 = (int) (clock/60);
		int v2 = (int) (clock%60);
		int v3 = (int) ((clock*100)%100);
		chrono.text = v1.ToString().PadLeft(2, '0')+":"+v2.ToString().PadLeft(2, '0')+":"+v3.ToString().PadLeft(2, '0');

		if(Input.GetKeyDown("r"))
			Application.LoadLevel(Application.loadedLevel);
	}

	public void CountLap()
	{
		if(clock < bestlapclock)
		{
			bestLap.text = "Best Lap :\n"+chrono.text;
			bestlapclock = clock;
		}
		clock = 0f;
	}
}
