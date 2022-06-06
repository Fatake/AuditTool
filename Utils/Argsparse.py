import argparse

def GetArgs():
    parser = argparse.ArgumentParser(description='''
    Audit Tool are a commpile of  scripts to automate 
    repetitive tasks dunring a pentest.
    ''')

    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('-i','--init', 
                        action='store_true',
                        default=False,
                        dest='init',
                        help='Start the working directory')

    group.add_argument('-n','--nameProject', 
                        metavar='name',
                        action='store',
                        default=None,
                        type=str,
                        nargs=1,
                        dest='Name',
                        help='Set Project Name')

    parser.add_argument('-b','--initBurpProject', 
                        action='store_true',
                        default=False,
                        dest='InitBurp',
                        help='Instance a New Burp project')

    args = parser.parse_args()

    return args