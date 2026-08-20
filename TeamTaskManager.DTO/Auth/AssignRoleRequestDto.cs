namespace TeamTaskManager.DTO.Auth;

public class AssignRoleRequestDto
{
    public required string UserEmail { get; set; }
    public required string Role { get; set; }
}
