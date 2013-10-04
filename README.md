# SkypeNameTranslit

A simple Ruby script which transliterates Skype names from Russian to English.

## Using

This script depends on `russian` and `sqlite3`, so: 

```
$ gem install russian sqlite3
```

And then you can use it: 

```
$ ruby translit.rb <your_Skype_name> 
```

Or:

``` 
$ ruby translit.rb <your_Skype_name> <path_to_Skype_directory>
```

**Important! Be sure, that Skype is not running.** And don`t be afraid! Script will ask you before doing any permutations.

## Reason

If you are so lazy as I am, then you understand me. What do you prefer: repeat some operation manually 10 times or automate them?

![Screenshot](https://github.com/krasun/SkypeNameTranslit/blob/master/screenshot.png?raw=true "Screenshot")

## License

This script is under the MIT license. See the complete license [here](https://github.com/krasun/SkypeNameTranslit/blob/master/LICENSE).
