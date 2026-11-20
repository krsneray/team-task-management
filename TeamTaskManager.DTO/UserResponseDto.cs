namespace TeamTaskManager.DTO;

public class UserResponseDto
{
    public string Id { get; set; } = default!;

    public string Email { get; set; } = default!;

    public string FullName { get; set; } = default!;

    public List<string> Roles { get; set; } = new();

    public bool IsActive { get; set; }
}
