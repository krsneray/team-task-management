using Microsoft.EntityFrameworkCore;
using TeamTaskManager.DataAccess;
using TeamTaskManager.DTO;
using TeamTaskManager.Entities;

namespace TeamTaskManager.Business;

public class TaskAttachmentService
{
    private readonly AppDbContext _context;

    public TaskAttachmentService(AppDbContext context)
    {
        _context = context;
    }

    // 1- Göreve dosya ekleme
    public async Task<TaskAttachmentResponseDto?> AddAttachmentAsync(
        int taskItemId,
        string originalFileName,
        string storedFileName,
        string filePath,
        string contentType,
        long fileSize,
        string uploadedByUserId)
    {
        var task = await _context.Tasks
            .FirstOrDefaultAsync(t => t.Id == taskItemId);

        if (task == null)
            return null;

        // Kullanıcı proje yöneticisi mi
        var isManager = await _context.Projects.AnyAsync(p =>
            p.Id == task.ProjectId &&
            p.ManagerUserId == uploadedByUserId);

        // Kullanıcı proje üyesi mi
        var isMember = await _context.ProjectMembers.AnyAsync(pm =>
            pm.ProjectId == task.ProjectId &&
            pm.UserId == uploadedByUserId &&
            pm.IsActive);

        if (!isManager && !isMember)
            return null;

        var attachment = new TaskAttachment
        {
            TaskItemId = taskItemId,
            OriginalFileName = originalFileName,
            StoredFileName = storedFileName,
            FilePath = filePath,
            ContentType = contentType,
            FileSize = fileSize,
            UploadedByUserId = uploadedByUserId,
            CreatedDate = DateTime.UtcNow
        };

        _context.TaskAttachments.Add(attachment);

        await _context.SaveChangesAsync();

        return MapToDto(attachment);
    }


    // 2- Göreve eklenen dosyaları listeleme
    public async Task<List<TaskAttachmentResponseDto>> GetAttachmentsAsync(
        int taskItemId,
        string currentUserId)
    {
        var task = await _context.Tasks
            .FirstOrDefaultAsync(t => t.Id == taskItemId);

        if (task == null)
            return new List<TaskAttachmentResponseDto>();

        // Kullanıcı proje yöneticisi mi
        var isManager = await _context.Projects.AnyAsync(p =>
            p.Id == task.ProjectId &&
            p.ManagerUserId == currentUserId);

        // Kullanıcı proje üyesi mi
        var isMember = await _context.ProjectMembers.AnyAsync(pm =>
            pm.ProjectId == task.ProjectId &&
            pm.UserId == currentUserId &&
            pm.IsActive);

        if (!isManager && !isMember)
            return new List<TaskAttachmentResponseDto>();

        var attachments = await _context.TaskAttachments
            .Where(a => a.TaskItemId == taskItemId)
            .OrderByDescending(a => a.CreatedDate)
            .ToListAsync();

        return attachments
            .Select(MapToDto)
            .ToList();
    }


    // 3- İndirilecek dosyayı id ile bulma
    public async Task<TaskAttachment?> GetAttachmentByIdAsync(
        int id,
        string currentUserId)
    {
        var attachment = await _context.TaskAttachments
            .Include(a => a.TaskItem)
            .FirstOrDefaultAsync(a => a.Id == id);

        if (attachment == null)
            return null;

        // Kullanıcı proje yöneticisi mi
        var isManager = await _context.Projects.AnyAsync(p =>
            p.Id == attachment.TaskItem.ProjectId &&
            p.ManagerUserId == currentUserId);

        // Kullanıcı proje üyesi mi
        var isMember = await _context.ProjectMembers.AnyAsync(pm =>
            pm.ProjectId == attachment.TaskItem.ProjectId &&
            pm.UserId == currentUserId &&
            pm.IsActive);

        if (!isManager && !isMember)
            return null;

        return attachment;
    }


    // Entity bilgisini DTO'ya çeviriyoruz
    private static TaskAttachmentResponseDto MapToDto(
        TaskAttachment attachment)
    {
        return new TaskAttachmentResponseDto
        {
            Id = attachment.Id,
            TaskItemId = attachment.TaskItemId,
            OriginalFileName = attachment.OriginalFileName,
            ContentType = attachment.ContentType,
            FileSize = attachment.FileSize,
            UploadedByUserId = attachment.UploadedByUserId,
            CreatedDate = attachment.CreatedDate
        };
    }
}