using static TeamTaskManager.Entities.Enums;

namespace TeamTaskManager.Entities;

public class ProjectMember
{
    public int Id { get; set; }

    public int ProjectId { get; set; }
    public required Project Project { get; set; }

    public required string UserId { get; set; }
    public required ApplicationUser User { get; set; }

    public ProjectRole MemberRole { get; set; }
    public DateTime JoinedDate { get; set; } = DateTime.UtcNow;
    public bool IsActive { get; set; } = true;
}