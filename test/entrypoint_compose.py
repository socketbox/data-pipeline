import os
import subprocess

if __name__ == "__main__":
    logging = "debug"
    print(os.environ)
    print("Running meltano install...")
    subprocess.run(['meltano', 'install'])
    #print("Adding admin user...")
    #subprocess.run(['meltano', 'user', 'add', '--role', 'admin', '--overwrite',
    #                os.getenv('MELTANO_ADMIN_USER'), os.getenv('MELTANO_ADMIN_PASSWORD')])
    print("Running meltano ui...")
    subprocess.run(['meltano', '-v', '--log-level', logging, 'ui'])
