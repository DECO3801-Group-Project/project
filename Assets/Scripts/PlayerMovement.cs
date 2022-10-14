 using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    [Header("Movement")] //creates a header above inputs
    public float moveSpeed; //good value: 7
    public float groundDrag; //good value: 5

    public float jumpForce; //good value: 12
    public float jumpCooldown; //good value: 0.25
    public float airMultiplier; //good value: 0.4
    bool readyToJump;

    [Header("Ground Check")]
    public float playerHeight;
    public LayerMask whatIsGround;
    bool grounded;

    /* IMPORTANT - READ WHEN IMPLEMENTING 
     * Create a new layer mask called 'whatIsGround' and apply it to the ground object
     */

    [Header("Transform orientation (Orientation object inside of player)")]
    public Transform orientation;

    float horizontalInput;
    float verticalInput;

    Vector3 moveDirection;

    Rigidbody rigidbody;

    // Start is called before the first frame update
    void Start()
    {
        rigidbody = GetComponent<Rigidbody>();
        rigidbody.freezeRotation = true;
        readyToJump = true;
    }

    // Update is called once per frame
    void Update()
    {
        //Uses a raycast from the current player position downwards and see if it hits something
        //The length of the array is half of the players height plus a little offset
        grounded = Physics.Raycast(transform.position, Vector3.down, playerHeight * 0.5f + 0.2f, whatIsGround);

        //watches for keyboard inputs
        horizontalInput = Input.GetAxisRaw("Horizontal");
        verticalInput = Input.GetAxisRaw("Vertical");

        SpeedControl(); //prevents endless accelerating


        if (grounded) //raycast detects something
            rigidbody.drag = groundDrag;
        else
            rigidbody.drag = 0; //no drag when in air

        //Checks to see if player is ready to jump and is grounded
        if (Input.GetKey(KeyCode.Space) && readyToJump && grounded)
        {
            readyToJump = false;
            Jump();

            //After some time has passed, call the reset jump function to change the value of the readyToJump bool
            Invoke(nameof(ResetJump), jumpCooldown);
        }

    }

    void FixedUpdate()
    {
        MovePlayer();
    }


    private void MovePlayer()
    {
        //will walk in the direction the user is looking
        moveDirection = orientation.forward * verticalInput + orientation.right * horizontalInput;

        //adds force to the player in the direction that was just calculated
        rigidbody.AddForce(moveDirection.normalized * moveSpeed * 10f, ForceMode.Force);
    }

    //to impose a limit on speed so user does not continuosly accelerate
    private void SpeedControl()
    {
        //finds current velocity from x,z plane
        Vector3 flatVelocity = new Vector3(rigidbody.velocity.x, 0f, rigidbody.velocity.z);

        //if the magnitude of the flat velocity is greater than the set moveSpeed
        if (flatVelocity.magnitude > moveSpeed)
        {
            //Creates a new vector with a reduced speed but having the same ratio of x,z
            Vector3 limitedVelocity = flatVelocity.normalized * moveSpeed;

            //Applies this velocity (with the original y velocity) to the rigidBody
            rigidbody.velocity = new Vector3(limitedVelocity.x, rigidbody.velocity.y, limitedVelocity.z);
        }

    }

    private void Jump()
    {
        //Resets y velocity to 0
        rigidbody.velocity = new Vector3(rigidbody.velocity.x, 0f, rigidbody.velocity.z);

        //Impulse since we are only applying the force once during the initial jump
        rigidbody.AddForce(transform.up * jumpForce, ForceMode.Impulse);
    }

    private void ResetJump()
    {
        readyToJump = true;
    }
}
