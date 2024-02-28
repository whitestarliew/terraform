import boto3
import docker

def lambda_handler(event, context):
    # Replace with your actual values
    s3_bucket = "your-bucket-name"
    s3_file = "your-csv-file"
    ecr_profile_name = "abc132"  # Assuming your ECR credentials are in profile named "abc132"
    ecr_region = "us-east-1"

    # Download CSV file from S3
    s3_client = boto3.client('s3')
    try:
        response = s3_client.get_object(Bucket=s3_bucket, Key=s3_file)
        response.download_file(s3_file)
        print(f"Successfully downloaded file from S3: {s3_file}")
    except Exception as e:
        print(f"Failed to download file from S3: {e}")
        return {
            'statusCode': 500,
            'body': f"Error downloading file from S3: {str(e)}"
        }

    # Login to ECR using profile credentials
    session = boto3.Session(profile_name=ecr_profile_name)
    ecr_client = session.client('ecr', region_name=ecr_region)
    try:
        login_command = ecr_client.get_authorization_token(registryIds=[ecr_client.meta.region_endpoint])
        docker_client = docker.from_env()
        docker_client.login(
            username=login_command['authorizationData'][0]['authorizationToken'],
            email="",  # Remove email for security concerns
            password="",  # Remove password for security concerns
        )
        print("Successfully logged in to ECR!")
    except Exception as e:
        print(f"Failed to log in to ECR: {e}")
        return {
            'statusCode': 500,
            'body': f"Error logging in to ECR: {str(e)}"
        }

    # Process each line in the CSV file
    with open(s3_file, 'r') as csvfile:
        reader = csv.reader(csvfile)
        next(reader)  # Skip header row
        for row in reader:
            nexus_repo, nexus_tags, ecr_repo, ecr_tag = row

            # Pull image from Nexus
            try:
                image = f"{nexus_repo}:{nexus_tags}"
                docker_client.images.pull(image)
                print(f"Successfully pulled image: {image}")
            except Exception as e:
                print(f"Failed to pull image {image}: {e}")
                continue  # Skip to next iteration on failure

            # Tag the image for ECR
            try:
                ecr_image = f"{ecr_repo}:{ecr_tag}"
                docker_client.images.tag(image, ecr_image)
                print(f"Successfully tagged image: {image} -> {ecr_image}")
            except Exception as e:
                print(f"Failed to tag image: {e}")
                continue  # Skip to next iteration on failure

            # Push the image to ECR
            try:
                docker_client.images.push(ecr_image)
                print(f"Successfully pushed image: {ecr_image}")
            except Exception as e:
                print(f"Failed to push image {ecr_image}: {e}")
                continue  # Skip to next iteration on failure

            # Optionally remove pulled and pushed images
            try:
                docker_client.images.remove(image=image, force=True)
                docker_client.images.remove(image=ecr_image, force=True)
                print(f"Successfully removed images: {image} and {ecr_image}")
            except Exception as e:
                print(f"Failed to remove images: {e}")  # Ignore removal failures

    # Optionally remove the downloaded file
    # ... remove file code (implementation depends on your preference)

    return {
        'statusCode': 200,
        'body': "Image pull and push process completed successfully."
    }
