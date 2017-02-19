# File URL Resource

Downloads and tracks the update of a single URL-addressable file.  
This is a useful resource for pipeline development time, while a required artifact is temporarily available from a URL-addressable location, until it is moved to a more robust file management repository such as [git](https://github.com/concourse/git-resource) or [S3](https://github.com/concourse/s3-resource).  

## Source Configuration

* `url`: *Required.* The url location of the file. It has to be publicly available, no user authentication supported in v0.0.1.

* `filename`: *Optional.* The name of the file for the downloaded artifact to be save as. If not provided, the file will be saved using the full url string as its name.

* `skip_ssl_verification`: *Optional.* Skips ssl verification if defined as `true`. Default is `false`.

### Example

Resource configuration:

``` yaml
resource_types:
- name: file-url
  type: docker-image
  source:
    repository: pivotalservices/concourse-curl-resource
    tag: latest

resources:
- name: my-file
  type: file-url
  source:
    url: https://raw.githubusercontent.com/pivotalservices/concourse-curl-resource/master/test/data/pivotal-1.0.0.txt  
    filename: pivotal-1.0.0.txt  
```

## Behavior

### `check`: Check for the latest version of the file.

The resource uses `curl` under-the-covers to post a GET request and retrieve the HTTP header info for the file URL provided.  
If field `Last-Modified` is returned as part of the HTTP response header, then the resource will use that to build a version number timestamp with format "YYYYMMDDHHMMSS".
Otherwise, the timestamp string will be built using the request's current time, which will result in a new version being returned every time `check` is executed for that file.

### `in`: Download the latest version of the file.

Downloads the latest version of the file issuing a `curl` command under-the-covers.


### `out`: Not supported.

Write actions are not supported by this resource at this moment.
