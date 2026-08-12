namespace TeamTaskManager.Entities;

public class Enums
{
    public enum NotificationType
    {
        TaskAssigned,
        TaskStatusChanged,
        TaskCommented,
        ProjectMemberAdded
    }
    public enum TaskPriority
    {
        Low,
        Medium,
        High,
        Critical
    }
    public enum ProjectTaskStatus
    {
        New,
        Continues,
        OnHold,
        Finish,
        Cancelled
    }
    public enum ProjectRole
    {
        Manager,
        Member
    }
    public enum ProjectStatus
    {
        ToDo,
        InProgress,
        Review,
        Done
    }
}
