using static TeamTaskManager.Entities.Enums;

namespace TeamTaskManager.DTO;

public class ProjectMemberResponseDto
{
    public string UserId { get; set; } = default!;

    public string FullName { get; set; } = default!;

    public string Email { get; set; } = default!;

    public ProjectRole MemberRole { get; set; }

    public bool IsActive { get; set; }

    public DateTime JoinedDate { get; set; }
}
