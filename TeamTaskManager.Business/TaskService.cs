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

    public async Task<TaskResponseDto> CreateTaskAsync(
        CreateTaskDto dto,
        string createdByUserId)
    {
        var task = new TaskItem
        {
            ProjectId = dto.ProjectId,
            Title = dto.Title,
            Description = dto.Description,
            AssignedUserId = dto.AssignedUserId,
            Priority = dto.Priority,
            Status = dto.Status,
            StartDate = dto.StartDate,
            DueDate = dto.DueDate,
            CreatedByUserId = createdByUserId,
            CreatedDate = DateTime.UtcNow
        };

        _context.Tasks.Add(task);

        await _context.SaveChangesAsync();

        return MapToDto(task);
    }

    public async Task<List<TaskResponseDto>> GetTasksAsync(string currentUserId)
    {
        var tasks = await _context.Tasks
            .Where(t => _context.ProjectMembers.Any(pm =>
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
                _context.ProjectMembers.Any(pm =>
                    pm.ProjectId == t.ProjectId &&
                    pm.UserId == currentUserId &&
                    pm.IsActive));

        if (task == null)
            return null;

        return MapToDto(task);
    }

    public async Task<TaskResponseDto?> UpdateTaskAsync(
        int id,
        UpdateTaskDto dto)
    {
        var task = await _context.Tasks
            .FirstOrDefaultAsync(t => t.Id == id);

        if (task == null)
            return null;

        task.Title = dto.Title;
        task.Description = dto.Description;
        task.AssignedUserId = dto.AssignedUserId;
        task.Priority = dto.Priority;
        task.Status = dto.Status;
        task.StartDate = dto.StartDate;
        task.DueDate = dto.DueDate;
        task.UpdatedDate = DateTime.UtcNow;

        if (task.Status == ProjectTaskStatus.Finish &&
            task.CompletedDate == null)
        {
            task.CompletedDate = DateTime.UtcNow;
        }

        await _context.SaveChangesAsync();

        return MapToDto(task);
    }

    public async Task<bool> DeleteTaskAsync(int id)
    {
        var task = await _context.Tasks
            .FirstOrDefaultAsync(t => t.Id == id);

        if (task == null)
            return false;

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