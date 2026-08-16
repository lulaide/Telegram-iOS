# Custom MTProto server builds

This fork can replace Telegram's initial datacenter with a self-hosted MTProto
endpoint. The implementation follows Teamgram's client patch, but keeps the
server values in the normal build configuration instead of hardcoding them in
the networking and authentication sources.

The default configuration in
`build-system/teamgram-configuration.json` connects to Teamgram at
`tcp://43.155.11.190:10443`, uses datacenter `1`, and includes Teamgram's RSA
public key.

## Configuration fields

Add these optional fields to any Telegram iOS build configuration:

```json
{
  "custom_server_url": "tcp://example.com:10443",
  "custom_server_datacenter_id": 1,
  "custom_server_public_key": "-----BEGIN RSA PUBLIC KEY-----\n...\n-----END RSA PUBLIC KEY-----"
}
```

`custom_server_url` accepts `tcp://` or `mtproto://` and must contain a host and
port. The RSA public key must match the private key used by the MTProto server.
Set `custom_server_url` to an empty string to retain Telegram's official
datacenters, keys, and backup discovery behavior.

When custom-server mode is enabled, the client:

- seeds only the configured datacenter and endpoint;
- authenticates the server with the configured RSA public key;
- uses the configured datacenter for new and restored account contexts; and
- disables Telegram's iCloud and internet backup-address discovery so it does
  not silently reconnect to an official Telegram datacenter.

## GitHub Actions

Run **Build LiveContainer IPA** from the Actions tab. `server_url` and
`datacenter_id` can be changed for each manual run. The workflow uses the
Teamgram public key by default.

For a server with a different key, create the repository secret
`CUSTOM_SERVER_PUBLIC_KEY_BASE64` containing the base64-encoded PEM file. For
example:

```bash
base64 < server-public-key.pem | tr -d '\n'
```

The workflow builds with Telegram's fake signing material because Bazel needs a
device archive, then removes code signatures and provisioning profiles before
uploading `Telegram-Teamgram-LiveContainer-unsigned.ipa`. LiveContainer can
import that artifact and apply its own runtime signing behavior.
