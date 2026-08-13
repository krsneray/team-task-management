using Microsoft.AspNetCore.Identity;
using TeamTaskManager.Entities;

namespace TeamTaskManager.API;

public static class DbSeeder
{
    public static async Task SeedRolesAsync(RoleManager<IdentityRole> roleManager)
    {
        string[] roles = { "Admin", "ProjectManager", "TeamMember"};

        foreach (var role in roles)
        {
            var exists = await roleManager.RoleExistsAsync(role);
            if(!exists)
            {
                await roleManager.CreateAsync(new IdentityRole(role));
            }
        }
    }
}
