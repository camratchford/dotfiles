#!/usr/bin/python3

import mailbox
import argparse
from pathlib import Path
from os import environ

default_user = environ.get('USER')

parser = argparse.ArgumentParser()
parser.add_argument('--user', default=default_user)
parser.add_argument('--count', action='store_true')
parser.add_argument('--index', type=int, required=False)
args = parser.parse_args()
user = args.user
mailbox_path = Path("/var/mail/").joinpath(args.user)

if not mailbox_path.exists():
    print("Mailbox does not exist")
    exit(1)

messages = mailbox.mbox(f'/var/mail/{args.user}')
if args.count:
    print(str(len(messages)))
    exit(0)

if len(messages) > args.index:
    print(f"{messages[args.index].get('subject')}")
    exit(0)


