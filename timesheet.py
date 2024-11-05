#!/usr/bin/python3
# parse a md file for timesheet calculations. lines of interest are:
# # date
# ## start-time acct
# ## acct start-time
# ## end-time
# any start time is implicitly the end time of the previous block

import argparse
import fileinput
import re
from datetime import datetime, date, time
import pdb


def seconds_to_hrsmins(seconds):
    hours = seconds // 3600
    minutes = (seconds - hours * 3600) // 60
    return hours, minutes


cmdLineArgParser = argparse.ArgumentParser(
    description='Calculate timesheet info from a MarkDown file',
    epilog='''H1 lines ('#') are expected to contain dates.
              H2 lines ('#') are expected to contain start times and
              either ticket numbers or account numbers.

              output should be a series of blocks, separated by blank lines, showing the date,
              time spent on that date for each ticket/account, and the total reportable time
              for that date.
              '''
)
cmdLineArgParser.add_argument('filename', nargs='*')
cmdLineArgParser.add_argument('-v', '--verbose', action='store_true')
cmdLineArgParser.add_argument('-D', '--debug', action='store_true')
args = cmdLineArgParser.parse_args()
if args.verbose: print(args)

acct_regex = '([a-zA-Z]+-[0-9]+|[a-zA-Z0-9]+\.[a-zA-Z0-9.]+)'
date_regex = '([0-9]{4})[-/]([0-9]{2})[-/]([0-9]{2})'
time_regex = '([0-9]{1,2}):?([0-9]{2})'
h1_with_date = re.compile(f'^#\s(\S*\s)*{date_regex}.*$')
h2_with_acct_time = re.compile(f'^##\s(\S*\s)*{acct_regex}\s(\S*\s)*{time_regex}.*$')
h2_with_time_acct = re.compile(f'^##\s(\S*\s)*{time_regex}\s(\S*\s)*{acct_regex}.*$')
h2_with_time = re.compile(f'^##\s(\S*\s)*{time_regex}.*$')

current_date = None
current_time = None
current_datetime = None
current_acct = None
prev_datetime = None
accumulator = {}
if args.debug: breakpoint()

for line in fileinput.input(files=args.filename):
    if args.verbose: print(line.strip())
    time_diff = None
    prev_acct = current_acct

    h1_with_date_match = h1_with_date.match(line)
    h2_with_acct_time_match = h2_with_acct_time.match(line)
    h2_with_time_acct_match = h2_with_time_acct.match(line)
    h2_with_time_match = h2_with_time.match(line)

    if h1_with_date_match:
        year = int(h1_with_date_match.group(2))
        month = int(h1_with_date_match.group(3))
        day = int(h1_with_date_match.group(4))
        current_date = date(year, month, day)
        if args.verbose: print(f'h1 with date {current_date}')
        if not current_date in accumulator:
            accumulator[current_date] = {}

    elif h2_with_acct_time_match:
        current_acct = h2_with_acct_time_match.group(2)
        hour = int(h2_with_acct_time_match.group(4))
        minute = int(h2_with_acct_time_match.group(5))
        if args.verbose: print(f'h2 with acct {current_acct}, time {hour}:{minute}')
        prev_datetime = current_datetime
        current_time = time(hour, minute)
        current_datetime = datetime.combine(current_date, current_time)
        if current_datetime and prev_datetime:
            time_diff = current_datetime - prev_datetime
            if current_acct in accumulator[current_date]:
                accumulator[current_date][current_acct] += time_diff
            else:
                accumulator[current_date][current_acct] = time_diff

    elif h2_with_time_acct_match:
        hour = int(h2_with_time_acct_match.group(2))
        minute = int(h2_with_time_acct_match.group(3))
        current_acct = h2_with_time_acct_match.group(5)
        if args.verbose: print(f'h2 with time {hour}:{minute}, acct {current_acct}')
        current_time = time(hour, minute)
        prev_datetime = current_datetime
        current_datetime = datetime.combine(current_date, current_time)
        if current_datetime and prev_datetime:
            time_diff = current_datetime - prev_datetime
            if current_acct in accumulator[current_date]:
                accumulator[current_date][current_acct] += time_diff
            else:
                accumulator[current_date][current_acct] = time_diff

    elif h2_with_time_match:
        hour = int(h2_with_time_match.group(2))
        minute = int(h2_with_time_match.group(3))
        if args.verbose: print(f'h2 with time {hour}:{minute}')
        current_acct = ''
        current_time = time(hour, minute)
        prev_datetime = current_datetime
        current_datetime = datetime.combine(current_date, current_time)
        if current_datetime and prev_datetime:
            time_diff = current_datetime - prev_datetime
            if prev_acct in accumulator[current_date]:
                accumulator[current_date][prev_acct] += time_diff
            elif prev_acct != '':
                accumulator[current_date][prev_acct] = time_diff
    else:
        continue

    if args.verbose:
        print(f'd {current_date} delta {time_diff} account {current_acct}\t', end='')
        if (current_date in accumulator and current_acct in accumulator[current_date]):
            print(f'accumulated {accumulator[current_date][current_acct]}')
        else:
            print(f'accumulator [not found]')

for day, value in accumulator.items():
    if args.verbose: print(day, "->", value)
    if value != {}:
        day_total_seconds = 0
        for acct, time_diff in value.items():
            day_total_seconds += time_diff.seconds
            hours, minutes = seconds_to_hrsmins(time_diff.seconds)
            print("{day}:\t{acct:10s}\t{hours:02d}:{minutes:02d}\t{hrs:.1f}".format(day=day, acct=acct, hours=hours,
                                                                                    minutes=minutes,
                                                                                    hrs=time_diff.seconds / 3600))
        hours, minutes = seconds_to_hrsmins(day_total_seconds)
        print("{day}:\t{acct:10s}\t{hours:02d}:{minutes:02d}\t{hrs:.1f}".format(day=day, acct='total', hours=hours,
                                                                                minutes=minutes,
                                                                                hrs=day_total_seconds / 3600))
    else:
        print(f'nothing happened on {day}')
