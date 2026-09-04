using Microsoft.EntityFrameworkCore;
using TeamTaskManager.DataAccess;
using TeamTaskManager.DTO;

namespace TeamTaskManager.Business;

public class NotificationService
{
    private readonly AppDbContext _context;

    public NotificationService(AppDbContext context)
    {
        _context = context;
    }

    // 1- Kullanıcının bildirimlerini listeleme
    public async Task<List<NotificationResponseDto>> GetNotificationsAsync(
        string currentUserId)
    {
        var notifications = await _context.Notifications
            .Where(n => n.UserId == currentUserId)
            .OrderByDescending(n => n.CreatedDate)
            .ToListAsync();

        return notifications.Select(n => new NotificationResponseDto
        {
            Id = n.Id,
            UserId = n.UserId,
            Title = n.Title,
            Message = n.Message,
            Type = n.Type,
            RelatedEntityId = n.RelatedEntityId,
            IsRead = n.IsRead,
            CreatedDate = n.CreatedDate
        }).ToList();
    }


    // 2- Bildirimi okundu olarak işaretleme
    public async Task<bool> MarkAsReadAsync(
        int id,
        string currentUserId)
    {
        var notification = await _context.Notifications
            .FirstOrDefaultAsync(n =>
                n.Id == id &&
                n.UserId == currentUserId);

        if (notification == null)
            return false;

        notification.IsRead = true;

        await _context.SaveChangesAsync();

        return true;
    }
}