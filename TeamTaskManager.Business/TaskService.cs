using Microsoft.EntityFrameworkCore;
using TeamTaskManager.DataAccess;
using TeamTaskManager.DTO;
using TeamTaskManager.Entities;
using static TeamTaskManager.Entities.Enums;

namespace TeamTaskManager.Business;

public class TaskService
{
    private readonly AppDbContext _context;

    public TaskService(AppDbContext context)
    {
        _context = context;
    }

    public async Task<TaskResponseDto?> CreateTaskAsync(
    CreateTaskDto dto,
    string createdByUserId)
    {
        var assigneeExists = await _context.Users
            .AnyAsync(u => u.Id == dto.AssignedUserId);
        var projectExists = await _context.Projects
            .AnyAsync(p => p.Id == dto.ProjectId);

        if (!assigneeExists || !projectExists)
            return null;

        var task = new TaskItem
        {
            ProjectId = dto.ProjectId,
            Title = dto.Title,
            Description = dto.Description,
            AssignedUserId = dto.AssignedUserId,
            Priority = dto.Priority,
            Status = ProjectTaskStatus.New,
            StartDate = dto.StartDate,
            DueDate = dto.DueDate,
            CreatedByUserId = createdByUserId,
            CreatedDate = DateTime.UtcNow
        };

        _context.Tasks.Add(task);

        await _context.SaveChangesAsync();

        var notification = new Notification
        {
            UserId = task.AssignedUserId,
            Title = "Yeni görev atandı",
            Message = $"'{task.Title}' görevi size atandı.",
            Type = NotificationType.TaskAssigned,
            RelatedEntityId = task.Id,
            IsRead = false,
            CreatedDate = DateTime.UtcNow
        };

        _context.Notifications.Add(notification);

        _context.ActivityLogs.Add(new ActivityLog
        {
            UserId = createdByUserId,
            EntityType = "Task",
            EntityId = task.Id,
            Action = "Created",
            Description = $"'{task.Title}' görevi oluşturuldu.",
            CreatedDate = DateTime.UtcNow
        });

        await _context.SaveChangesAsync();

        return MapToDto(task);
    }

    public async Task<List<TaskResponseDto>> GetTasksAsync(
        string currentUserId)
    {
        var tasks = await _context.Tasks
            .Where(t =>
                _context.Projects.Any(p =>
                    p.Id == t.ProjectId &&
                    p.ManagerUserId == currentUserId)

                ||

                _context.ProjectMembers.Any(pm =>
                    pm.ProjectId == t.ProjectId &&
                    pm.UserId == currentUserId &&
                    pm.IsActive))
            .ToListAsync();

        return tasks
            .Select(MapToDto)
            .ToList();
    }

    public async Task<TaskResponseDto?> GetTaskByIdAsync(
        int id,
        string currentUserId)
    {
        var task = await _context.Tasks
            .FirstOrDefaultAsync(t =>
                t.Id == id &&
                (
                    _context.Projects.Any(p =>
                        p.Id == t.ProjectId &&
                        p.ManagerUserId == currentUserId)

                    ||

                    _context.ProjectMembers.Any(pm =>
                        pm.ProjectId == t.ProjectId &&
                        pm.UserId == currentUserId &&
                        pm.IsActive)
                ));

        if (task == null)
            return null;

        return MapToDto(task);
    }

    public async Task<TaskResponseDto?> UpdateTaskStatusAsync(
        int id,
        ProjectTaskStatus newStatus,
        string currentUserId)
    {
        var task = await _context.Tasks
            .Include(t => t.Project)
            .FirstOrDefaultAsync(t => t.Id == id);

        if (task == null)
            return null;

        var isManager = task.Project.ManagerUserId == currentUserId;
        var isAssignee = task.AssignedUserId == currentUserId;

        if (!isManager && !isAssignee)
            throw new UnauthorizedAccessException(
                "Görev durumunu yalnızca atanan kişi veya proje yöneticisi değiştirebilir.");

        var oldStatus = task.Status;

        if (oldStatus != newStatus)
        {
            task.Status = newStatus;
            task.UpdatedDate = DateTime.UtcNow;

            if (newStatus == ProjectTaskStatus.Completed)
            {
                task.CompletedDate ??= DateTime.UtcNow;
            }
            else
            {
                task.CompletedDate = null;
            }

            _context.ActivityLogs.Add(new ActivityLog
            {
                UserId = currentUserId,
                EntityType = "Task",
                EntityId = task.Id,
                Action = "StatusChanged",
                Description =
                    $"Görev durumu {oldStatus} durumundan {newStatus} durumuna değiştirildi.",
                CreatedDate = DateTime.UtcNow
            });

            // Atanan kişi değiştirdiyse yöneticiye, yönetici değiştirdiyse atanan kişiye haber ver.
            var notifyUserId = isAssignee
                ? task.Project.ManagerUserId
                : task.AssignedUserId;

            if (!string.IsNullOrEmpty(notifyUserId) && notifyUserId != currentUserId)
            {
                _context.Notifications.Add(new Notification
                {
                    UserId = notifyUserId,
                    Title = "Görev durumu değişti",
                    Message = $"{task.Title} görevinin durumu {newStatus} olarak değiştirildi.",
                    Type = NotificationType.TaskStatusChanged,
                    RelatedEntityId = task.Id,
                    IsRead = false,
                    CreatedDate = DateTime.UtcNow
                });
            }

            await _context.SaveChangesAsync();
        }

        return MapToDto(task);
    }

    public Task<bool> UserExistsAsync(string userId)
    {
        return _context.Users.AnyAsync(u => u.Id == userId);
    }

    public async Task<TaskResponseDto?> UpdateTaskAsync(
        int id,
        UpdateTaskDto dto,
        string currentUserId)
    {
        var task = await _context.Tasks
            .FirstOrDefaultAsync(t => t.Id == id);

        if (task == null)
            return null;

        var oldStatus = task.Status;

        task.Title = dto.Title;
        task.Description = dto.Description;
        task.AssignedUserId = dto.AssignedUserId;
        task.Priority = dto.Priority;
        task.Status = dto.Status;
        task.StartDate = dto.StartDate;
        task.DueDate = dto.DueDate;
        task.UpdatedDate = DateTime.UtcNow;

        if (task.Status == ProjectTaskStatus.Completed &&
            task.CompletedDate == null)
        {
            task.CompletedDate = DateTime.UtcNow;
        }

        if (oldStatus != dto.Status)
        {
            var activityLog = new ActivityLog
            {
                UserId = currentUserId,
                EntityType = "Task",
                EntityId = task.Id,
                Action = "StatusChanged",
                Description =
                    $"Görev durumu {oldStatus} durumundan {dto.Status} durumuna değiştirildi.",
                CreatedDate = DateTime.UtcNow
            };

            _context.ActivityLogs.Add(activityLog);

            if (!string.IsNullOrEmpty(task.AssignedUserId))
            {
                var notification = new Notification
                {
                    UserId = task.AssignedUserId,
                    Title = "Görev durumu değişti",
                    Message =
                        $"{task.Title} görevinin durumu {dto.Status} olarak değiştirildi.",
                    Type = NotificationType.TaskStatusChanged,
                    RelatedEntityId = task.Id,
                    IsRead = false,
                    CreatedDate = DateTime.UtcNow
                };

                _context.Notifications.Add(notification);
            }
        }

        await _context.SaveChangesAsync();

        return MapToDto(task);
    }

    public async Task<bool> DeleteTaskAsync(int id, string currentUserId)
    {
        var task = await _context.Tasks
            .Include(t => t.Project) 
            .FirstOrDefaultAsync(t => t.Id == id);

        if (task == null)
            return false;

        if (task.Project.ManagerUserId != currentUserId)
        {
            throw new UnauthorizedAccessException("Bu görevi silmek için yetkiniz yok. Sadece projenin yöneticisi silebilir.");
        }

        _context.Tasks.Remove(task);

        await _context.SaveChangesAsync();

        return true;
    }

    private static TaskResponseDto MapToDto(TaskItem task)
    {
        return new TaskResponseDto
        {
            Id = task.Id,
            ProjectId = task.ProjectId,
            Title = task.Title,
            Description = task.Description,
            AssignedUserId = task.AssignedUserId,
            Priority = task.Priority,
            Status = task.Status,
            StartDate = task.StartDate,
            DueDate = task.DueDate,
            CompletedDate = task.CompletedDate,
            CreatedByUserId = task.CreatedByUserId,
            CreatedDate = task.CreatedDate,
            UpdatedDate = task.UpdatedDate
        };
    }
}