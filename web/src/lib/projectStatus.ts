import { ProjectStatus, type ProjectProgress } from '../types/api'

/**
 * API'deki proje durumu alanı güncellenemediği için (UpdateProjectDto'da yok) web arayüzü
 * durumu görev ilerlemesinden türetir.
 */
export function deriveProjectStatus(progress?: ProjectProgress): ProjectStatus {
  if (!progress || progress.totalTasks === 0) return ProjectStatus.ToDo
  if (progress.progressPercent >= 100) return ProjectStatus.Done
  return ProjectStatus.InProgress
}
