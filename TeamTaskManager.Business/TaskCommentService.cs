using Microsoft.EntityFrameworkCore;
using TeamTaskManager.DataAccess;
using TeamTaskManager.DTO;
using TeamTaskManager.Entities;

namespace TeamTaskManager.Business;

public class TaskCommentService
{
    private readonly AppDbContext _context;

    public TaskCommentService(AppDbContext context)
    {
        _context = context;
    }

    public async Task<TaskCommentResponseDto?> CreateCommentAsync(
        CreateTaskCommentDto dto,
        string currentUserId)
    {
        var task = await _context.Tasks
            .FirstOrDefaultAsync(t => t.Id == dto.TaskItemId);

        if (task == null)
            return null;

        // Kullanıcı proje yöneticisi mi kontrol ediyoruz
        var isManager = await _context.Projects
            .AnyAsync(p =>
                p.Id == task.ProjectId &&
                p.ManagerUserId == currentUserId);

        // Kullanıcı proje üyesi mi kontrol ediyoruz
        var isProjectMember = await _context.ProjectMembers
            .AnyAsync(pm =>
                pm.ProjectId == task.ProjectId &&
                pm.UserId == currentUserId &&
                pm.IsActive);

        // Yönetici veya üye değilse yorum ekleyemez
        if (!isManager && !isProjectMember)
            return null;

        var comment = new TaskComment
        {
            TaskItemId = dto.TaskItemId,
            UserId = currentUserId,
            Content = dto.Content,
            CreatedDate = DateTime.UtcNow
        };

        _context.TaskComments.Add(comment);

        await _context.SaveChangesAsync();

        return MapToDto(comment);
    }

    public async Task<List<TaskCommentResponseDto>> GetCommentsByTaskIdAsync(
        int taskItemId,
        string currentUserId)
    {
        var task = await _context.Tasks
            .FirstOrDefaultAsync(t => t.Id == taskItemId);

        if (task == null)
            return new List<TaskCommentResponseDto>();

        // Kullanıcı proje yöneticisi mi kontrol ediyoruz
        var isManager = await _context.Projects
            .AnyAsync(p =>
                p.Id == task.ProjectId &&
                p.ManagerUserId == currentUserId);

        // Kullanıcı proje üyesi mi kontrol ediyoruz
        var isProjectMember = await _context.ProjectMembers
            .AnyAsync(pm =>
                pm.ProjectId == task.ProjectId &&
                pm.UserId == currentUserId &&
                pm.IsActive);

        if (!isManager && !isProjectMember)
            return new List<TaskCommentResponseDto>();

        var comments = await _context.TaskComments
            .Where(c => c.TaskItemId == taskItemId)
            .OrderBy(c => c.CreatedDate)
            .ToListAsync();

        return comments
            .Select(MapToDto)
            .ToList();
    }

    private static TaskCommentResponseDto MapToDto(TaskComment comment)
    {
        return new TaskCommentResponseDto
        {
            Id = comment.Id,
            TaskItemId = comment.TaskItemId,
            UserId = comment.UserId,
            Content = comment.Content,
            CreatedDate = comment.CreatedDate,
            UpdatedDate = comment.UpdatedDate
        };
    }
}