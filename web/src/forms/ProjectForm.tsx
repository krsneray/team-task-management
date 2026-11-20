import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { getErrorMessages } from '../api/client'
import { Alert, Button, Field, Input, Textarea } from '../components/ui'
import { projectSchema, type ProjectValues } from '../lib/schemas'
import type { Project } from '../types/api'

interface Props {
  project?: Project
  submitLabel: string
  onSubmit: (values: ProjectValues) => Promise<unknown>
  onCancel: () => void
}

export function ProjectForm({ project, submitLabel, onSubmit, onCancel }: Props) {
  const [serverErrors, setServerErrors] = useState<string[]>([])
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<ProjectValues>({
    resolver: zodResolver(projectSchema),
    defaultValues: {
      name: project?.name ?? '',
      description: project?.description ?? '',
      startDate: project?.startDate.slice(0, 10) ?? '',
      targetEndDate: project?.targetEndDate.slice(0, 10) ?? '',
    },
  })

  const submit = handleSubmit(async (values) => {
    setServerErrors([])
    try {
      await onSubmit(values)
    } catch (error) {
      setServerErrors(getErrorMessages(error))
    }
  })

  return (
    <form onSubmit={submit} className="space-y-4" noValidate>
      <Alert messages={serverErrors} />
      <Field label="Proje adı" htmlFor="project-name" required error={errors.name?.message}>
        <Input id="project-name" {...register('name')} placeholder="Örn. Mobil uygulama" />
      </Field>
      <Field label="Açıklama" htmlFor="project-description" error={errors.description?.message}>
        <Textarea id="project-description" {...register('description')} />
      </Field>
      <div className="grid gap-4 sm:grid-cols-2">
        <Field label="Başlangıç tarihi" htmlFor="project-start" required error={errors.startDate?.message}>
          <Input id="project-start" type="date" {...register('startDate')} />
        </Field>
        <Field label="Hedef bitiş tarihi" htmlFor="project-end" required error={errors.targetEndDate?.message}>
          <Input id="project-end" type="date" {...register('targetEndDate')} />
        </Field>
      </div>
      <div className="flex justify-end gap-2 pt-2">
        <Button variant="secondary" onClick={onCancel}>
          Vazgeç
        </Button>
        <Button type="submit" loading={isSubmitting}>
          {submitLabel}
        </Button>
      </div>
    </form>
  )
}
