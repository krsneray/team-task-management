namespace TeamTaskManager.DTO;

public class DashboardSummaryDto
{
    public int ProjectCount { get; set; }

    public int TotalTasks { get; set; }

    public int OpenTasks { get; set; }

    public int OverdueTasks { get; set; }

    public int CompletedTasks { get; set; }

    public int MyOpenTasks { get; set; }

    public int MyOverdueTasks { get; set; }

    public int UnreadNotifications { get; set; }

    public List<ProjectProgressDto> Projects { get; set; } = new();

    public List<UserWorkloadDto> Workload { get; set; } = new();

    public List<RecentActivityDto> RecentActivities { get; set; } = new();
}

public class ProjectProgressDto
{
    public int ProjectId { get; set; }

    public string Name { get; set; } = default!;

    public int TotalTasks { get; set; }

    public int CompletedTasks { get; set; }

    public int OverdueTasks { get; set; }

    public int ProgressPercent { get; set; }
}

public class UserWorkloadDto
{
    public string UserId { get; set; } = default!;

    public string FullName { get; set; } = default!;

    public int OpenTasks { get; set; }

    public int CompletedTasks { get; set; }
}

public class RecentActivityDto
{
    public long Id { get; set; }

    public int TaskId { get; set; }

    public string TaskTitle { get; set; } = default!;

    public string UserFullName { get; set; } = default!;

    public string Description { get; set; } = default!;

    public DateTime CreatedDate { get; set; }
}
