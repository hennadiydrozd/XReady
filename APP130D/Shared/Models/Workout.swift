import Foundation

enum Workout: CaseIterable, Identifiable {
    case preWorkoutQuick
    case preWorkoutFull
    case postWorkoutQuick
    case postWorkoutFull
    
    var id: String {
        switch self {
        case .preWorkoutQuick: return "pre_quick"
        case .preWorkoutFull: return "pre_full"
        case .postWorkoutQuick: return "post_quick"
        case .postWorkoutFull: return "post_full"
        }
    }
    
    var title: String {
        switch self {
        case .preWorkoutQuick: return "Quick\nWarm-up"
        case .preWorkoutFull: return "Full Warm-up"
        case .postWorkoutQuick: return "Quick Stretch"
        case .postWorkoutFull: return "Full Stretch"
        }
    }
    
    var subtitle: String {
        switch self {
        case .preWorkoutQuick: return "5 minutes • Dynamic exercises\nto prepare your muscles"
        case .preWorkoutFull: return "15 minutes • Complete preparation\nfor intense training"
        case .postWorkoutQuick: return "5 minutes • Essential stretches\nfor recovery"
        case .postWorkoutFull: return "15 minutes • Complete flexibility\nand recovery routine"
        }
    }
    
    var isQuick: Bool {
        switch self {
        case .preWorkoutQuick, .postWorkoutQuick: return true
        case .preWorkoutFull, .postWorkoutFull: return false
        }
    }
    
    var totalDuration: TimeInterval {
        exercises.reduce(0) { $0 + $1.duration }
    }
    
    var exercises: [Exercise] {
        switch self {
        case .preWorkoutQuick:
            return [
                Exercise(name: "Light Jog in Place", duration: 60, instructions: "Jog gently in place to warm up", imageName: "e1"),
                Exercise(name: "Arm Circles", duration: 30, instructions: "Make large circles with your arms", imageName: "e2"),
                Exercise(name: "Leg Swings (Side to Side)", duration: 30, instructions: "Swing your leg side to side across your body", imageName: "e3"),
                Exercise(name: "Torso Twists", duration: 30, instructions: "Twist your torso left and right", imageName: "e4"),
                Exercise(name: "Leg Swings (Front to Back)", duration: 30, instructions: "Swing your leg forward and backward", imageName: "e5")
            ]
            
        case .preWorkoutFull:
            return [
                Exercise(name: "Light Jog", duration: 120, instructions: "Jog at a comfortable pace to warm up", imageName: "e6"),
                Exercise(name: "Arm Circles (Forward & Backward)", duration: 60, instructions: "Make large circles with your arms, both forward and backward", imageName: "e7"),
                Exercise(name: "Leg Swings (Front to Back)", duration: 60, instructions: "Swing each leg forward and backward", imageName: "e8"),
                Exercise(name: "Leg Swings (Side to Side)", duration: 60, instructions: "Swing each leg side to side across your body", imageName: "e9"),
                Exercise(name: "Torso Twists", duration: 60, instructions: "Twist your torso left and right", imageName: "e10"),
                Exercise(name: "Walking Lunges", duration: 90, instructions: "Step forward into a lunge, alternating legs", imageName: "e11"),
                Exercise(name: "High Knees", duration: 60, instructions: "Bring your knees up towards your chest", imageName: "e12"),
                Exercise(name: "Moderate Pace Jog", duration: 60, instructions: "Maintain a steady jogging pace to warm up", imageName: "e13"),
                Exercise(name: "Fast Pace Run", duration: 60, instructions: "Increase your pace to a quick run or sprint", imageName: "e14"),
            ]
            
        case .postWorkoutQuick:
            return [
                Exercise(name: "Quad Stretch", duration: 60, instructions: "Stand and pull your heel towards your glute, stretching the front of your thigh.", imageName: "e15"),
                Exercise(name: "Forward Fold", duration: 60, instructions: "Sit or stand and fold forward, reaching for your toes to stretch your hamstrings.", imageName: "e16"),
                Exercise(name: "Calf Stretch", duration: 60, instructions: "Lean against a wall or sturdy object with one foot back, pressing your heel down to stretch your calf.", imageName: "e17"),
                Exercise(name: "Hip Flexor Lunge", duration: 60, instructions: "Kneel in a lunge position, shifting your weight forward to stretch your hip flexor. (The red highlight likely indicates the muscle being stretched).", imageName: "e18"),
                Exercise(name: "Overhead Tricep/Shoulder Stretch", duration: 60, instructions: "Reach one arm overhead and bend your elbow, pulling the elbow gently with your other hand to stretch your tricep and shoulder.", imageName: "e19")
            ]
            
        case .postWorkoutFull:
            return [
                Exercise(name: "Quad Stretch", duration: 60, instructions: "Stand and pull your heel towards your glute, stretching the front of your thigh.", imageName: "e20"),
                Exercise(name: "Seated Hamstring Stretch", duration: 60, instructions: "Sit with one leg extended and reach for your toes, keeping your back straight to stretch your hamstring. (The red line indicates good posture for the stretch).", imageName: "e21"),
                Exercise(name: "Calf Stretch", duration: 60, instructions: "Lean against a wall or sturdy object with one foot back, pressing your heel down to stretch your calf.", imageName: "e22"),
                Exercise(name: "Hip Flexor Lunge", duration: 60, instructions: "Kneel in a lunge position, shifting your weight forward to stretch your hip flexor. (The red highlight indicates the area being stretched).", imageName: "e23"),
                Exercise(name: "Seated Cross-Legged Stretch", duration: 60, instructions: "Sit cross-legged with good posture to gently stretch your hips and inner thighs.", imageName: "e24"),
                Exercise(name: "IT Band Stretch", duration: 60, instructions: "Cross one leg behind the other and lean away from the front leg, feeling the stretch along the outside of your thigh. (The red highlight indicates the IT band area).", imageName: "e25"),
                Exercise(name: "Butterfly Stretch", duration: 60, instructions: "Sit with the soles of your feet together and gently press your knees towards the ground, stretching your inner thighs and groin. (The red highlights indicate the inner thigh area).", imageName: "e26"),
                Exercise(name: "Shoulder Stretch", duration: 60, instructions: "Pull one arm across your body with the other arm, keeping your shoulder down, to stretch your shoulder.", imageName: "e27")
            ]
        }
    }
}
