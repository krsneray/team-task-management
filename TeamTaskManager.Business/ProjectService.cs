using Microsoft.EntityFrameworkCore;
using TeamTaskManager.DataAccess;
using TeamTaskManager.DTO;
using TeamTaskManager.Entities;
using static TeamTaskManager.Entities.Enums;

namespace TeamTaskManager.Business;

public enum AddMemberResult
{
    Added,
    ProjectNotFound,
    UserNotFound,
    AlreadyMember
}

public class ProjectService
{
    private readonly AppDbContext _context;

    public ProjectService(AppDbContext context)
    {
        _context = context;
    }

    public async Task<ProjectResponseDto> CreateProjectAsync(
    CreateProjectDto dto,
    string managerUserId)
    {
        var project = new Project
        {
            Name = dto.Name,
            Description = dto.Description,
            StartDate = dto.StartDate,
            TargetEndDate = dto.TargetEndDate,
            ManagerUserId = managerUserId,
            Status = ProjectStatus.ToDo,
            CreatedTime = DateTime.UtcNow,
            UpdatedTime = DateTime.UtcNow
        };

        _context.Projects.Add(project);

        await _context.SaveChangesAsync();

        var managerMembership = new ProjectMember
        {
            ProjectId = project.Id,
            UserId = managerUserId,
            MemberRole = ProjectRole.Manager,
            JoinedDate = DateTime.UtcNow,
            IsActive = true
        };

        _context.ProjectMembers.Add(managerMembership);

        await _context.SaveChangesAsync();

        return MapToDto(project);
    }

    public async Task<List<ProjectResponseDto>> GetProjectsAsync()
    {
        var projects = await _context.Projects
            .ToListAsync();

        return projects
            .Select(MapToDto)
            .ToList();
    }

    public async Task<ProjectResponseDto?> GetProjectByIdAsync(int id)
    {
        var project = await _context.Projects
            .FirstOrDefaultAsync(p => p.Id == id);

        if (project == null)
            return null;

        return MapToDto(project);
    }

    public async Task<ProjectResponseDto?> UpdateProjectAsync(
        int id,
        UpdateProjectDto dto,
        string currentUserId)
    {
        var project = await _context.Projects
            .FirstOrDefaultAsync(p => p.Id == id);

        if (project == null)
            return null;

        if (project.ManagerUserId != currentUserId)
            throw new UnauthorizedAccessException(
                "Bu projeyi sadece proje yöneticisi güncelleyebilir.");

        project.Name = dto.Name;
        project.Description = dto.Description;
        project.StartDate = dto.StartDate;
        project.TargetEndDate = dto.TargetEndDate;
        project.UpdatedTime = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        return MapToDto(project);
    }

    public async Task<bool> DeleteProjectAsync(
        int id,
        string currentUserId)
    {
        var project = await _context.Projects
            .FirstOrDefaultAsync(p => p.Id == id);

        if (project == null)
            return false;

        if (project.ManagerUserId != currentUserId)
            throw new UnauthorizedAccessException(
                "Bu projeyi sadece proje yöneticisi silebilir.");

        _context.Projects.Remove(project);

        await _context.SaveChangesAsync();

        return true;
    }

    public async Task<List<ProjectMemberResponseDto>?> GetMembersAsync(int projectId)
    {
        var exists = await _context.Projects.AnyAsync(p => p.Id == projectId);

        if (!exists)
            return null;

        var members = await _context.ProjectMembers
            .Where(pm => pm.ProjectId == projectId && pm.IsActive)
            .Include(pm => pm.User)
            .OrderBy(pm => pm.MemberRole)
            .ThenBy(pm => pm.JoinedDate)
            .ToListAsync();

        return members
            .Select(pm => new ProjectMemberResponseDto
            {
                UserId = pm.UserId,
                FullName = $"{pm.User.FirstName} {pm.User.LastName}",
                Email = pm.User.Email ?? "",
                MemberRole = pm.MemberRole,
                IsActive = pm.IsActive,
                JoinedDate = pm.JoinedDate
            })
            .ToList();
    }

    public async Task<AddMemberResult> AddMemberAsync(
        int projectId,
        string userId,
        string currentUserId)
    {
        var project = await _context.Projects
            .FirstOrDefaultAsync(p => p.Id == projectId);

        if (project == null)
            return AddMemberResult.ProjectNotFound;

        if (project.ManagerUserId != currentUserId)
            throw new UnauthorizedAccessException(
                "Projeye üyeyi sadece proje yöneticisi ekleyebilir.");

        var userExists = await _context.Users
            .AnyAsync(u => u.Id == userId && u.IsActive);

        if (!userExists)
            return AddMemberResult.UserNotFound;

        var membership = await _context.ProjectMembers
            .FirstOrDefaultAsync(pm =>
                pm.ProjectId == projectId && pm.UserId == userId);

        if (membership != null && membership.IsActive)
            return AddMemberResult.AlreadyMember;

        if (membership == null)
        {
            _context.ProjectMembers.Add(new ProjectMember
            {
                ProjectId = projectId,
                UserId = userId,
                MemberRole = ProjectRole.Member,
                JoinedDate = DateTime.UtcNow,
                IsActive = true
            });
        }
        else
        {
            membership.IsActive = true;
            membership.JoinedDate = DateTime.UtcNow;
        }

        _context.Notifications.Add(new Notification
        {
            UserId = userId,
            Title = "Projeye eklendiniz",
            Message = $"'{project.Name}' projesine üye olarak eklendiniz.",
            Type = NotificationType.ProjectMemberAdded,
            RelatedEntityId = project.Id,
            IsRead = false,
            CreatedDate = DateTime.UtcNow
        });

        await _context.SaveChangesAsync();

        return AddMemberResult.Added;
    }

    public async Task<bool> RemoveMemberAsync(
        int projectId,
        string userId,
        string currentUserId)
    {
        var project = await _context.Projects
            .FirstOrDefaultAsync(p => p.Id == projectId);

        if (project == null)
            return false;

        if (project.ManagerUserId != currentUserId)
            throw new UnauthorizedAccessException(
                "Projeden üyeyi sadece proje yöneticisi çıkarabilir.");

        if (project.ManagerUserId == userId)
            throw new InvalidOperationException(
                "Proje yöneticisi projeden çıkarılamaz.");

        var membership = await _context.ProjectMembers
            .FirstOrDefaultAsync(pm =>
                pm.ProjectId == projectId &&
                pm.UserId == userId &&
                pm.IsActive);

        if (membership == null)
            return false;

        membership.IsActive = false;

        await _context.SaveChangesAsync();

        return true;
    }

    private static ProjectResponseDto MapToDto(Project project)
    {
        return new ProjectResponseDto
        {
            Id = project.Id,
            Name = project.Name,
            Description = project.Description,
            StartDate = project.StartDate,
            TargetEndDate = project.TargetEndDate,
            Status = project.Status,
            ManagerUserId = project.ManagerUserId,
            CreatedTime = project.CreatedTime,
            UpdatedTime = project.UpdatedTime
        };
    }
}