using Microsoft.EntityFrameworkCore;
using TeamTaskManager.DataAccess;
using TeamTaskManager.DTO;
using TeamTaskManager.Entities;
using static TeamTaskManager.Entities.Enums;

namespace TeamTaskManager.Business;

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