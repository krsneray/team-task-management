using static TeamTaskManager.Entities.Enums;

namespace TeamTaskManager.Entities;

public class Notification
{
    public int Id { get; set; }

    public string UserId { get; set; } = default!;
    public ApplicationUser User { get; set; } = default!;

    public string Title { get; set; } = default!;
    public string Message { get; set; } = default!;
    public NotificationType Type { get; set; }

    public int RelatedEntityId { get; set; }
    public bool IsRead { get; set; } = false;

    public DateTime CreatedDate { get; set; } = DateTime.UtcNow;
}