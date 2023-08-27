#!/usr/bin/python

from ansible.module_utils.basic import AnsibleModule
import boto3
import time

def run_command(instance_id, commands, region):
    client = boto3.client('ssm', region_name=region)
    
    try:
        response = client.send_command(
            InstanceIds=[instance_id],
            DocumentName="AWS-RunShellScript",
            Parameters={'commands': commands}
        )
        command_id = response['Command']['CommandId']

        # Wait for the command to complete
        while True:
            time.sleep(5)
            output = client.list_command_invocations(
                InstanceId=instance_id, 
                CommandId=command_id
            )
            if output['CommandInvocations'][0]['Status'] in ['Success', 'Failed']:
                break

        return True, 'Command executed successfully'
    except Exception as e:
        return False, f'Error: {e}'


def main():
    module = AnsibleModule(
        argument_spec={
            'instance_id': {'required': True, 'type': 'str'},
            'commands': {'required': True, 'type': 'list'},
            'region': {'required': True, 'type': 'str'},
        }
    )
    
    is_success, result = run_command(
        module.params['instance_id'],
        module.params['commands'],
        module.params['region']
    )
    
    if is_success:
        module.exit_json(changed=True, msg=result)
    else:
        module.fail_json(msg=result)


if __name__ == '__main__':
    main()
