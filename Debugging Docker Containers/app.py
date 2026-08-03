import time
import os
import sys

def main():
    print('Starting application...')
    counter = 0
    while True:
        counter += 1
        print(f'Iteration {counter}')
        
        if counter == 5:
            print('Warning: Approaching error condition', file=sys.stderr)
        
        if counter == 10:
            print('Error: Simulated application error', file=sys.stderr)
            # Don't exit, just continue with errors
        
        time.sleep(3)

if __name__ == '__main__':
    main()
