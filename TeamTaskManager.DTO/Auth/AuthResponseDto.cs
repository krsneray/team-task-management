namespace TeamTaskManager.DTO.Auth;

public class AuthResponseDto
{
    public required string UserId { get; set; }

    public required string Token { get; set; }
    public required string Email { get; set; }
    public required string FullName { get; set; }
    public required IList<string> Roles { get; set; }
    public required DateTime ExpiresAt { get; set; }
}
