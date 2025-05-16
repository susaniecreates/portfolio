def initialize():
    '''Initializes the global variables needed for the simulation.
    Note: this function is incomplete, and you may want to modify it'''

    global cur_hedons, cur_health

    global cur_time, cur_star
    global last_activity, last_activity_duration
    global cur_star_activity

    global last_finished
    global bored_with_stars
    global is_tired
    global star_duration
    global total_star_duration
    global total_stars
    global prev_last_star_time
    global last_star_time

    cur_hedons = 0
    cur_health = 0

    cur_star = None
    cur_star_activity = None

    bored_with_stars = False
    tired = False

    last_activity = "resting"
    current_activity = None
    last_activity_duration = 121

    cur_time = 0
    star_duration = 0
    total_stars  = 0
    num_star = 0
    last_star_time = -1000
    prev_last_star_time = -1000

    last_finished = -1000


def is_tired():
    global tired, cur_time, last_finished, last_activity

    if last_activity == "resting" and last_activity_duration > 120:
        tired = False
    else:
        tired = True

    return tired

def perform_activity(activity, duration):
    global cur_health, cur_hedons, last_activity_duration, is_tired
    global cur_time, current_activity, last_activity, temp, cur_star

    tired = is_tired()
    cur_time += duration
    current_activity = activity
    temp = duration

    #sections for different activities
    if activity == "running":
        #health points
        if last_activity == activity:
            if cur_star == True:
                cur_star = False
            duration += last_activity_duration
            if duration < 180:
                cur_health += 3 * duration
            else:
                cur_health += 180 * 3
                cur_health -= last_activity_duration * 3
                duration = duration - 180
                cur_health += 1 * duration

        else:
            if duration < 180:
                cur_health += 3 * duration
            else:
                cur_health += 180 * 3
                cur_health += 180 - duration

        #hedons
        duration = temp
        if tired == True:
            cur_hedons += -2 * duration
        else:
            if duration >= 10:
                cur_hedons += 20
                cur_hedons = cur_hedons - (2*(duration - 10))
            else:
                cur_hedons += (2 * duration)
        if cur_star == True and cur_star_activity == activity:
            if duration < 10:
                cur_hedons += 3 * duration
            else:
                cur_hedons += 3 * 10



    if activity == "textbooks":
        #health points
        cur_health += 2 * duration

        #hedons
        if tired:
            cur_hedons = cur_hedons - (2 * duration)
        else:
            if duration >= 20:
                cur_hedons += 20
                cur_hedons -= (duration - 20)
            else:
                cur_hedons += duration

        if cur_star_activity == "textbooks" and bored_with_stars == False:
            if duration >=10:
                cur_hedons += 30
            else:
                cur_hedons = cur_hedons + (3 * duration)
        else:
            pass

    if activity == "resting":
        None


    cur_time += duration
    last_finished = cur_time
    last_activity = activity
    last_activity_duration = duration


def get_cur_hedons():
    return cur_hedons

def get_cur_health():
    return cur_health

def star_can_be_taken(activity):
    global cur_star, bored_with_stars, cur_star_activity
    if cur_star and not bored_with_stars:
        if cur_star_activity == activity:
            return True
        else:
            return False
    else:
        return False

def offer_star(activity):
    global cur_star, cur_star_activity, num_star, star_start_time, bored_with_stars
    global prev_last_star_time, last_star_time, cur_time

    if cur_time - prev_last_star_time <120:
        bored_with_stars = True
    else:
        bored_with_stars = False

    cur_star = True
    cur_star_activity = activity
    prev_last_star_time = last_star_time
    last_star_time = cur_time


    num_star = 0

    if num_star == 0:
        star_start_time = cur_time

    if not bored_with_stars:
        cur_star = True
        cur_star_activity = activity
        num_star += 1

    if num_star == 3 and (cur_time - star_start_time) < 120:
        bored_with_stars = True
        cur_stars = False


def most_fun_activity_minute():
    global last_activity_duration, last_activity, cur_hedons, cur_star, cur_star_activity, cur_time

    possible_running_hedons = 0
    possible_textbooks_hedons = 0
    possible_resting_hedons = 0

    if "running" == cur_star_activity:
        possible_running_hedons += 3

    if "textbooks" == cur_star_activity:
        possible_running_hedons += 3

    if "resting" == cur_star_activity:
        possible_running_hedons += 3

    if last_activity == "resting" and last_activity_duration >= 120:
        possible_textbooks_hedons += 1
        possible_running_hedons += 2

    else:
        possible_textbooks_hedons -= 2
        possible_running_hedons -= 2

    if possible_running_hedons > possible_textbooks_hedons and possible_running_hedons > possible_resting_hedons:
        return "running"

    if possible_textbooks_hedons > possible_running_hedons and possible_textbooks_hedons > possible_running_hedons:
        return "textbooks"

    else:
        return "resting"

################################################################################
#These functions are not required, but we recommend that you use them anyway
#as helper functions

def get_effective_minutes_left_hedons(activity):
    '''Return the number of minutes during which the user will get the full
    amount of hedons for activity activity'''
    pass

def get_effective_minutes_left_health(activity):
    pass

def estimate_hedons_delta(activity, duration):
    '''Return the amount of hedons the user would get for performing activity
    activity for duration minutes'''
    pass


def estimate_health_delta(activity, duration):
    pass

################################################################################

if __name__ == "__main__":
    initialize()
    perform_activity("running", 30)
    print(get_cur_hedons()) # -20 = 10 * 2 + 20 * (-2)
    print(get_cur_health()) # 90 = 30 * 3
    print(most_fun_activity_minute()) #resting
    perform_activity("resting", 30)
    offer_star("running")
    print(most_fun_activity_minute()) # running
    perform_activity("textbooks", 30)
    print(get_cur_health()) # 150 = 90 + 30*2
    print(get_cur_hedons()) # -80 = -20 + 30 * (-2)
    offer_star("running")
    perform_activity("running", 20)
    print(get_cur_health()) # 210 = 150 + 20 * 3
    print(get_cur_hedons()) # -90 = -80 + 10 * (3-2) + 10 * (-2)
    perform_activity("running", 170)
    print(get_cur_health()) # 700 = 210 + 160 * 3 + 10 * 1
    print(get_cur_hedons()) # -430 = -90 + 170 * (-2)
