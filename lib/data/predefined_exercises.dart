import '../models/exercise.dart';

class PredefinedExercises {
  static const String _defaultUserId = 'predefined';

  static final List<Exercise> exercises = [
    Exercise(
      id: 'pred_pullups',
      userId: _defaultUserId,
      nameEn: 'Pull-ups',
      nameDe: 'Klimmzüge',
      descriptionEn:
          'Hang from a bar and pull your body up until your chin is over the bar. Great for building back and arm strength.',
      descriptionDe:
          'Hängen Sie sich an eine Stange und ziehen Sie Ihren Körper hoch, bis Ihr Kinn über der Stange ist. Hervorragend für den Aufbau von Rücken- und Armkraft.',
      createdAt: DateTime(2024, 1, 1),
    ),
    Exercise(
      id: 'pred_pushups',
      userId: _defaultUserId,
      nameEn: 'Push-ups',
      nameDe: 'Liegestütz',
      descriptionEn:
          'Start in a plank position and lower your body until your chest nearly touches the floor, then push back up.',
      descriptionDe:
          'Beginnen Sie in der Plank-Position und senken Sie Ihren Körper ab, bis Ihre Brust fast den Boden berührt, dann drücken Sie sich wieder hoch.',
      createdAt: DateTime(2024, 1, 1),
    ),
    Exercise(
      id: 'pred_benchpress',
      userId: _defaultUserId,
      nameEn: 'Bench Press',
      nameDe: 'Bankdrücken',
      descriptionEn:
          'Lie on a bench and press a barbell or dumbbells from chest level to arms extended. Primary chest exercise.',
      descriptionDe:
          'Liegen Sie auf einer Bank und drücken Sie eine Langhantel oder Kurzhanteln von der Brusthöhe bis zu ausgestreckten Armen. Primäre Brustübung.',
      createdAt: DateTime(2024, 1, 1),
    ),
    Exercise(
      id: 'pred_rowing',
      userId: _defaultUserId,
      nameEn: 'Bent-over Row',
      nameDe: 'Rudern',
      descriptionEn:
          'Bend forward and pull a barbell or dumbbells toward your lower chest/upper abdomen. Excellent for back development.',
      descriptionDe:
          'Beugen Sie sich nach vorne und ziehen Sie eine Langhantel oder Kurzhanteln zu Ihrer unteren Brust/oberen Bauch. Hervorragend für die Rückenentwicklung.',
      createdAt: DateTime(2024, 1, 1),
    ),
    Exercise(
      id: 'pred_bicep_curls',
      userId: _defaultUserId,
      nameEn: 'Bicep Curls',
      nameDe: 'Bizeps-Curls',
      descriptionEn:
          'Hold weights at your sides and curl them up toward your shoulders, focusing on bicep contraction.',
      descriptionDe:
          'Halten Sie Gewichte an Ihren Seiten und curlen Sie sie zu Ihren Schultern hoch, konzentrieren Sie sich auf die Bizepskontraktion.',
      createdAt: DateTime(2024, 1, 1),
    ),
    Exercise(
      id: 'pred_squats',
      userId: _defaultUserId,
      nameEn: 'Squats',
      nameDe: 'Kniebeugen',
      descriptionEn:
          'Stand with feet shoulder-width apart and lower your body as if sitting back into a chair. Great for legs and glutes.',
      descriptionDe:
          'Stehen Sie mit schulterbreit auseinander stehenden Füßen und senken Sie Ihren Körper ab, als würden Sie sich in einen Stuhl setzen. Hervorragend für Beine und Gesäß.',
      createdAt: DateTime(2024, 1, 1),
    ),
    Exercise(
      id: 'pred_deadlifts',
      userId: _defaultUserId,
      nameEn: 'Deadlifts',
      nameDe: 'Kreuzheben',
      descriptionEn:
          'Lift a barbell from the ground to hip level by extending your hips and knees. Full-body compound movement.',
      descriptionDe:
          'Heben Sie eine Langhantel vom Boden auf Hüfthöhe, indem Sie Ihre Hüften und Knie strecken. Ganzkörper-Verbundübung.',
      createdAt: DateTime(2024, 1, 1),
    ),
    Exercise(
      id: 'pred_shoulder_press',
      userId: _defaultUserId,
      nameEn: 'Shoulder Press',
      nameDe: 'Schulterdrücken',
      descriptionEn:
          'Press weights overhead from shoulder level. Can be done standing or seated.',
      descriptionDe:
          'Drücken Sie Gewichte von Schulterhöhe über den Kopf. Kann im Stehen oder Sitzen durchgeführt werden.',
      createdAt: DateTime(2024, 1, 1),
    ),
    Exercise(
      id: 'pred_planks',
      userId: _defaultUserId,
      nameEn: 'Planks',
      nameDe: 'Planks',
      descriptionEn:
          'Hold a push-up position with straight body alignment. Excellent core strengthening exercise.',
      descriptionDe:
          'Halten Sie eine Liegestütz-Position mit gerader Körperausrichtung. Hervorragende Übung zur Stärkung der Körpermitte.',
      createdAt: DateTime(2024, 1, 1),
    ),
    Exercise(
      id: 'pred_lunges',
      userId: _defaultUserId,
      nameEn: 'Lunges',
      nameDe: 'Ausfallschritte',
      descriptionEn:
          'Step forward into a lunge position, lowering your back knee toward the ground. Great for legs and balance.',
      descriptionDe:
          'Machen Sie einen Schritt nach vorne in eine Ausfallschritt-Position und senken Sie Ihr hinteres Knie zum Boden. Hervorragend für Beine und Balance.',
      createdAt: DateTime(2024, 1, 1),
    ),
    Exercise(
      id: 'pred_dips',
      userId: _defaultUserId,
      nameEn: 'Dips',
      nameDe: 'Dips',
      descriptionEn:
          'Support your body on parallel bars or a bench and lower yourself down, then push back up. Great for triceps and chest.',
      descriptionDe:
          'Stützen Sie Ihren Körper auf Parallelbaren oder einer Bank und senken Sie sich ab, dann drücken Sie sich wieder hoch. Hervorragend für Trizeps und Brust.',
      createdAt: DateTime(2024, 1, 1),
    ),
    Exercise(
      id: 'pred_mountain_climbers',
      userId: _defaultUserId,
      nameEn: 'Mountain Climbers',
      nameDe: 'Bergsteiger',
      descriptionEn:
          'Start in plank position and alternate bringing knees to chest in a running motion. Great cardio and core exercise.',
      descriptionDe:
          'Beginnen Sie in der Plank-Position und wechseln Sie ab, die Knie in einer Laufbewegung zur Brust zu bringen. Hervorragendes Cardio- und Core-Training.',
      createdAt: DateTime(2024, 1, 1),
    ),
  ];

  static List<Exercise> getAllExercises() {
    return exercises;
  }

  static List<Exercise> getExercisesByCategory(ExerciseCategory category) {
    switch (category) {
      case ExerciseCategory.chest:
        return exercises
            .where(
              (e) => [
                'pred_pushups',
                'pred_benchpress',
                'pred_dips',
              ].contains(e.id),
            )
            .toList();
      case ExerciseCategory.back:
        return exercises
            .where((e) => ['pred_pullups', 'pred_rowing'].contains(e.id))
            .toList();
      case ExerciseCategory.legs:
        return exercises
            .where(
              (e) => [
                'pred_squats',
                'pred_deadlifts',
                'pred_lunges',
              ].contains(e.id),
            )
            .toList();
      case ExerciseCategory.arms:
        return exercises
            .where((e) => ['pred_bicep_curls', 'pred_dips'].contains(e.id))
            .toList();
      case ExerciseCategory.shoulders:
        return exercises
            .where((e) => ['pred_shoulder_press'].contains(e.id))
            .toList();
      case ExerciseCategory.core:
        return exercises
            .where(
              (e) => ['pred_planks', 'pred_mountain_climbers'].contains(e.id),
            )
            .toList();
      case ExerciseCategory.cardio:
        return exercises
            .where((e) => ['pred_mountain_climbers'].contains(e.id))
            .toList();
    }
  }

  static Exercise? getExerciseById(String id) {
    try {
      return exercises.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  static bool isPredefinedExercise(String id) {
    return id.startsWith('pred_');
  }
}

enum ExerciseCategory { chest, back, legs, arms, shoulders, core, cardio }
