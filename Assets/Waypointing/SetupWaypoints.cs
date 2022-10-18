using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Doozy.Runtime.UIManager.Components;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
public class SetupWaypoints : MonoBehaviour
{
	public GameObject player;
	public GameObject waypoint_prefab;
	public GameObject anchor;
	public float check_distance = 30;
	public int waypoint_height = 350;
	private GameObject[] waypoints;
	private int current = -1;

    public void Path()
    {
		Vector3[] waypoint_pos;
		waypoint_pos = new Vector3[]
		{
			new Vector3(775, waypoint_height, 310),
			new Vector3(790, waypoint_height, 400),
			new Vector3(800, waypoint_height, 475),
			new Vector3(690, waypoint_height, 565),
			new Vector3(570, waypoint_height, 590),
			new Vector3(425, waypoint_height, 600),
			new Vector3(370, waypoint_height, 510),
			new Vector3(245, waypoint_height, 515),
			new Vector3(105, waypoint_height, 520),
			new Vector3(-50, waypoint_height, 565),
			new Vector3(-165, waypoint_height, 520),
			new Vector3(-305, waypoint_height, 555),
		};
		waypoints = new GameObject[12];
		current = 0;
        for (var i = 0; i < 12; i++)
        {
			Vector3 pos = anchor.transform.position + waypoint_pos[i] + new Vector3(151, 0, -455);
			waypoints[i] = Instantiate(waypoint_prefab, pos, Quaternion.identity, this.transform);
			waypoints[i].GetComponent<MeshRenderer>().enabled = false;
        }
		waypoints[current].GetComponent<MeshRenderer>().enabled = true;
    }
	
	float GetHorizontalDistance(Vector3 a, Vector3 b)
	{
		float squared_sum = Mathf.Pow(a.x - b.x, 2) + Mathf.Pow(a.z - b.z, 2);
		return Mathf.Pow(squared_sum, 0.5f);
	}

    void Update()
    {
		if (waypoints == null)
		{
			return;
		}
		if (current > -1 && GetHorizontalDistance(player.transform.position, waypoints[current].transform.position) < check_distance && current < waypoints.Length)
		{
			waypoints[current].GetComponent<MeshRenderer>().enabled = false;
			current += 1;
			if (current == waypoints.Length) 
			{
				Cursor.lockState = CursorLockMode.None;
				Cursor.visible = true;
				Application.LoadLevel(0);
			}
			waypoints[current].GetComponent<MeshRenderer>().enabled = true;
			
		}
    }
}
