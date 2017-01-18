# terraform-gocd-do

A simple terraform script to create a gocd server using DigitalOcean.

Simply provide a .env file like [.env.example](.env.example):

```
do_token=your_do_token
```

Then run `run-terraform.sh`

This will create a new SSH key called `do-meetup` and store it in a `keys` folder.

If you want to specify your own SSH keys, simply set the `TF_VAR_pvt_key` and `TF_VAR_pub_key` pointing to the private and public keys you wish to use.

You can also specify other terraform commands to `run-terraform.sh` if you wish to perform other operations (other than apply which is the default).

For example, you can:

```
./run-terraform.sh destroy -force
```

To remove the droplet completely.
