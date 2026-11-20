using Microsoft.EntityFrameworkCore;
using TeamTaskManager.DataAccess;
using TeamTaskManager.DTO;
using static TeamTaskManager.Entities.Enums;

namespace TeamTaskManager.Business;

public class DashboardService
{
    private readonly AppDbContext _context;

    public DashboardService(AppDbContext context)
    {
        _context = context;
    }

    public async Task<DashboardSummaryDto> GetSummaryAsync(
        string currentUserId,
        bool canSeeWorkload)
    {
        var today = DateOnly.FromDateTime(DateTime.UtcNow);

        // Kullanıcının yönettiği ya da üyesi olduğu projeler (görev listesiyle aynı kural)
        var projects = await _context.Projects
            .Where(p =>
                p.ManagerUserId == currentUserId ||
                _context.ProjectMembers.Any(pm =>
                    pm.ProjectId == p.Id &&
                    pm.UserId == currentUserId &&
                    pm.IsActive))
            .Select(p => new { p.Id, p.Name })
            .ToListAsync();

        var projectIds = projects.Select(p => p.Id).ToList();

        var tasks = await _context.Tasks
            .Where(t => projectIds.Contains(t.ProjectId))
            .Select(t => new
            {
                t.Id,
                t.ProjectId,
                t.Title,
                t.AssignedUserId,
                t.Status,
                t.DueDate
            })
            .ToListAsync();

        static bool IsOpen(ProjectTaskStatus s) =>
            s == ProjectTaskStatus.New ||
            s == ProjectTaskStatus.InProgress ||
            s == ProjectTaskStatus.OnHold;

        var summary = new DashboardSummaryDto
        {
            ProjectCount = projects.Count,
            TotalTasks = tasks.Count,
            OpenTasks = tasks.Count(t => IsOpen(t.Status)),
            OverdueTasks = tasks.Count(t => IsOpen(t.Status) && t.DueDate < today),
            CompletedTasks = tasks.Count(t => t.Status == ProjectTaskStatus.Completed),
            MyOpenTasks = tasks.Count(t =>
                t.AssignedUserId == currentUserId && IsOpen(t.Status)),
            MyOverdueTasks = tasks.Count(t =>
                t.AssignedUserId == currentUserId && IsOpen(t.Status) && t.DueDate < today),
            UnreadNotifications = await _context.Notifications
                .CountAsync(n => n.UserId == currentUserId && !n.IsRead)
        };

        foreach (var project in projects)
        {
            var projectTasks = tasks.Where(t => t.ProjectId == project.Id).ToList();
            var counted = projectTasks.Count(t => t.Status != ProjectTaskStatus.Cancelled);
            var completed = projectTasks.Count(t => t.Status == ProjectTaskStatus.Completed);

            summary.Projects.Add(new ProjectProgressDto
            {
                ProjectId = project.Id,
                Name = project.Name,
                TotalTasks = projectTasks.Count,
                CompletedTasks = completed,
                OverdueTasks = projectTasks.Count(t => IsOpen(t.Status) && t.DueDate < today),
                ProgressPercent = counted == 0
                    ? 0
                    : (int)Math.Round(completed * 100.0 / counted)
            });
        }

        var taskIds = tasks.Select(t => t.Id).ToList();

        var activities = await _context.ActivityLogs
            .Where(a => a.EntityType == "Task" && taskIds.Contains(a.EntityId))
            .OrderByDescending(a => a.CreatedDate)
            .Take(10)
            .Select(a => new { a.Id, a.UserId, a.EntityId, a.Description, a.CreatedDate })
            .ToListAsync();

        var workloadGroups = canSeeWorkload
            ? tasks
                .GroupBy(t => t.AssignedUserId)
                .Select(g => new
                {
                    UserId = g.Key,
                    Open = g.Count(t => IsOpen(t.Status)),
                    Completed = g.Count(t => t.Status == ProjectTaskStatus.Completed)
                })
                .ToList()
            : null;

        var userIds = activities.Select(a => a.UserId)
            .Concat(workloadGroups?.Select(w => w.UserId) ?? Enumerable.Empty<string>())
            .Distinct()
            .ToList();

        var users = await _context.Users
            .Where(u => userIds.Contains(u.Id))
            .Select(u => new { u.Id, u.FirstName, u.LastName })
            .ToListAsync();

        string NameOf(string id)
        {
            var user = users.FirstOrDefault(u => u.Id == id);
            return user == null ? "Bilinmeyen kullanıcı" : $"{user.FirstName} {user.LastName}";
        }

        if (workloadGroups != null)
        {
            summary.Workload = workloadGroups
                .OrderByDescending(w => w.Open)
                .Select(w => new UserWorkloadDto
                {
                    UserId = w.UserId,
                    FullName = NameOf(w.UserId),
                    OpenTasks = w.Open,
                    CompletedTasks = w.Completed
                })
                .ToList();
        }

        summary.RecentActivities = activities
            .Select(a => new RecentActivityDto
            {
                Id = a.Id,
                TaskId = a.EntityId,
                TaskTitle = tasks.FirstOrDefault(t => t.Id == a.EntityId)?.Title ?? "",
                UserFullName = NameOf(a.UserId),
                Description = a.Description,
                CreatedDate = a.CreatedDate
            })
            .ToList();

        return summary;
    }
}
