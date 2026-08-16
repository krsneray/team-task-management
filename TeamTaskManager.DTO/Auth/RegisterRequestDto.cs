using System;
using System.Collections.Generic;
using System.Text;

namespace TeamTaskManager.DTO.Auth;

public class RegisterRequestDto
{
    public required string FirstName { get; set; }
    public required string LastName { get; set; }
    public required string Email { get; set; }
    public required string Password { get; set; }
}
