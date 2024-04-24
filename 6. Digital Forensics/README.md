Cloud and Network Security Lab 6: Digital Forensics (and Incident Respone)
====

Responsible person/main contact: Niklas Saari & Lauri Suutari


## Preliminary tasks & prerequisites

This is the sixth lab in the series with the theme of Cloud Security. 
You should return the tasks to GitHub.

Make yourself familiar with the following topics:

### For the first task

Get familiar with the documentation of the following tools / useful background info articles

* [Digital forensics on Wikipedia](https://en.wikipedia.org/wiki/Digital_forensics)
* [Volatility 3 documentation](https://volatility3.readthedocs.io/en/latest/)

### For the second task

Ever heard about the Unix [philosophy?](https://en.wikipedia.org/wiki/Unix_philosophy)

Essentially, it is about the software modularity and simplicity:
 * Write programs that do one thing and do it well.
 * Write programs to work together.
 * Write programs to handle text streams, because that is a universal interface.

And logs are textual data.
Your work here is to do a bit more advanced log analysis by using the basic Unix tools only.
They can be very efficient and help you to understand how some visualization software works internally.

The log file follows Microsoft's [ISS Logging style](https://learn.microsoft.com/en-us/previous-versions/iis/6.0-sdk/ms525410(v=vs.90)).

### For the third task

* [SIEM system in Wikipedia](https://en.wikipedia.org/wiki/Security_information_and_event_management)
* Wazuh [documentation](https://documentation.wazuh.com/current/index.html)
* Knowledge about Kubernetes, containers and logging

### For the bonus task

* [Steganography on Wikipedia](https://en.wikipedia.org/wiki/Steganography)
* Search information about different tools that could be used in computer forensics
  * Examples: `foremost`, `scalpel`, `exiftool`, `binwalk`, `strings`
  * Simply writing "Digital forensics tools" to Google should provide a huge load of information


## Grading

<!-- <details><summary>Details</summary> -->

The order of the tasks is not mandated, but the workload grows to the end.

Task| Points | Description | Good-to-have skills
--|:--:|--|--
1 |2|Memory investigation|Basic understanding of working of RAM and Volatility usage
2|1|DDoS attack investigation|Fluent usage of basic linux commands and coding, understanding of DDoS attack principles
3|2|SIEM and EDR| Kubernetes, containers and log analysis
Bonus|1| Data recovery and steganography | Data recovery and steganography investigation | Basic understanding of disk storage systems and steganography


Total points accumulated by doing the exercises reflect the overall grade. You can acquire up to 6 points from the whole exercise.
<!-- </details> -->

---


## Introduction

Digital forensics (aka digital forensic science) is a field committed to recovering and investigating evidence found in digital devices.

The field is too large to cover in a single lab (there exist multiple different digital forensic subfields) so this lab only intends to give you a slight intro to the digital forensic investigation-related issues.

> We are particularly interested on memory and log forensics this time.

You can find a good overview of the field from [Wikipedia](https://en.wikipedia.org/wiki/Digital_forensics)

Notice that this lab does not make you actually any kind of certified digital forensics expert.
There exists actual training for those jobs which may include also a lot of evidence chain-of-custody and legal issues that are not paid attention to in this lab at all.
This lab tries to concentrate on interesting problem-solving situations that could theoretically be part of forensic investigation in real life.

## Practical arrangements of this lab

This lab does not require any specific Linux distribution to be used.
You are required to install quite many tools yourself, so anything you can install them on is good enough.
You can find most tools if not all as Arch Linux packages for the course VM.

All memory and image dumps are available as a download.
The link is provided in Moodle.

## Important reminder

This lab features tasks that are a little similar to tasks in CTF challenges.
There is a specified type of information hidden in somewhere and it is up to you to figure it out.

Basically, this means that this lab may be harder than the others,
instructions and directions where you should go are more unclear than in the other labs and changes of tool usage problems and other irritating errors are higher than in the other labs.

Other labs might have had simple tutorials/instructions on how to use certain tools during them.
This lab does not do such a thing. You are expected to determine what tools you have to use and learn the usage of them yourself.

There may or may not be multiple ways to solve each task.
You must use your own judgment to determine what ways could or should be pursued to gain success.
Independent thinking/researching of problems and creative problem-solving are highly encouraged.

You are required to install all needed tools yourself and if there happens to be some problems with them - well, hopefully, Google and your good troubleshooting skills can help you then.

Consider yourself to be properly informed after reading this.

If you still want to take this challenge, good luck. You might really need it too.


# Tasks

Read task instructions carefully before starting to work to have a clear picture about what you are supposed to do.

Every task should clearly state what you are expected to do and return.

**If you are doing this work in a group, remember to mark down clearly which of you participated in which tasks**

## Task 1

Welcome to the imaginary day of digital forensic investigator. This task has highly fictional backstory which tries to give meaningful context to tasks. Notice that also any task or skill you will be using might or might not be useful in real life, because this lab does not equal to any official digital forensic training. Also, because this story is purely fictional, any possible connections to the real life events or people are coincidental.

Story starts here.

Mallory is notorious member of criminal underworld. He is known for illegal items trade, and he is rumored to have multiple shady contacts supplying him with high-quality "stuff", which have made him easy to gain foothold of black market.

Mallory has also reputation of being faster talker than thinker.

Mallory have been successful in his criminal activities lately, giving large influx of money and letting him expand his network, which have made him one of the "big players" of criminal underworld.

Unfortunately for him, also law enforcement at national level agencies have noticed his success. Mallory has reputation of being faster talker than thinker and because rumors spread fast, becoming known by law enforcement was only matter of time.

Big wheels start to turn, and large surveillance operation against Mallory and his minions was started started. After 3 months of fruitless efforts intel from trusted source appears: Mallorys gang is going to do drug deal next day.

Intel turns out to be correct and leading investigator decides that this is correct moment to strike. This would not be major victory, because only couple of Mallorys men would be caught red-handed, but it still could result Mallorys conviction if enough evidence is found about his involvement. Situation is not optimal, but small success is better than fruitless waiting of 3 months.

Moment to strike has come: Special units of police crash into the place of meeting and find 2 of Mallorys crooks with huge stash of illegal weapons and drugs. Simultaneously multiple carefully coordinated house raids are performed to all known members of Mallorys gang, including Mallorys home himself.

Mallory is caught by surprise when police storms into his apartment and immediately arrests him.
Police officers start to search Mallorys apartment and technician begins to investigate Mallorys computer which is turned on and logged on. After discussing with leading investigator, technician decides to start with dumping volatile memory of computer to his external hard drive.
Next to Mallorys computer is ordinary USB-memory stick. That stick is securely bagged to the evidence box for later inspection.

But Mallory has some brutal surprise for digital forensic technician: Just as memory dump from volatile memory is secured to investigators external drive, Mallorys computer starts to smoke and soon catches on fire explosively. Technician grabs his drive containing memory dump and runs out of apartment because toxic smoke from melting components is starting to spread fastly.
Apartment is evacuated in hurry and human casualties are avoided, but Mallorys improvised dead-man-switch - timed incendiary bomb inside computer which he supposedly managed to trigger when he heard police breaking in - has rendered whole machine unsalvageable.

Investigators know that there was so much critical information gone with Mallorys computer, and any hope they have left lies in single memory dump of Mallorys machine and ordinary USB memory stick.

### Inspecting memory with Volatility 3

> *Interrogator: You just would not mind telling where have you hidden your delivery caches?*
> 
> *Mallory: Haha! Do you imagine I will tell GPS locations of my last 2 hidden drug caches because you just ask for it? Uh-, I mean- I don't know what you are talking about!*
> 
> *Interrogator: Ok, ok, you do not need to shout. Lets have little lighter chat instead for while - shall we? I like lot of hiking, do you have any favourite map services you could recommend for me?*
> 
> *Mallory: Well, I am ok with this little chit-chat. Killing time is just fine because eventually you realize that I am completely innocent law-abiding citizen and let me go. Hmm, I like to use Google Maps via regular browser, I am little old stylish.*
> 
> *Interrogator: Ok, sounds nice. For what purpose are you using it?*
> 
> *Mallory: I want to check different locations before I-, uh- I mean I like hiking too.*

While exact location remains unknown, intel gathered from other sources suggests that Mallorys organization has been using codenames for those 2 caches: *LAKE* and *COAST*. Leading investigator suspects that those codenames are most likely describing also the places themselves. Leading investigator also suspects, that hidden caches are mostly located not too far from city and those should not require too long distance to be travelled by foot. Also caches can not obviously be located on densely populated areas.

Your first task is to find 2 different GPS locations where police officers should start for looking hidden stashes.

> *Leading investigator: There is problem with gathering Mallorys emails*
> 
> *You: How so? In this case we have court order for service provider to give us access to Mallorys email-account.*
> 
> *Leading investigator: Yes we do, but seems like they all have gone on holiday or something. I did not succeed connecting to anybody who could give us access right now. Typical corporate bureaucracy in action...*
> 
> *You: Oh. That's bad. But eventually we will get it.*
> 
> *Leading investigator: Yes we will. But this is urgent because any useful intel we could get from his email might be irrelevant next week because word about Mallorys arrest is spreading and his contacts are going to flee any moment with hidden caches.*
> 
> *You: I see. So we have only this memory dump right now. I'll see what I can do.*

Intel from unconfirmed sources says that there is rumors about Mallory having also third hidden cache. Nothing about it is known but its codename: *FOREST*

Your second task is to retrieve any email exchange of Mallory and his criminal partner. Extract content of the messages and solve location of third hidden cache.

Fill your answers and reasoning to the return template.

#### Hints and links

Volatility is tool for volatile memory inspection.

Find out what browser Mallory is using and then search for URLs which you want to find from its process memory.

Similar approach can be used to e-mail task: Determine what program Mallory is using for mail and start digging the process memory of it.

* [Volatility 3 documentation](https://volatility3.readthedocs.io/en/latest/)
  * Volatility 3 identifies the memory profile automatically
  * Useful volatility3 plugins:  `pslist`, `yarascan`, `memdump`
  * There exist lots of different Volatility plugins: Some may make your life lots easier with this task.
* Exiftool is a tool for inspecting image metadata
* Foremost can extract files of a specified type from other files, for example, memory dumps of processes.


## Task 2: Analyzing a DDoS attack

Your next task is to make an analysis and report of the real-world DDoS attack.

There was a real DDoS campaing in Finland some years ago, and this tasks gives you the target server's log file.

 A specific kind of malware was responsible for creating a botnet, which used to cause this DDoS attack.
 Malware was mostly spread by YouTube advertising. 
 
 You will find the server log file in the same place as the memory dumps of earlier tasks.

After unzipping log, you may find out that opening log file (which contains over 6 million lines of data) may crash regular text editor so you most likely have to utilize other tools to initial investigation of log file. Commands `grep`, `less`, `sort`, `cut`, `awk` and `uniq` might be helpful.

Calculate next things from attack: Start time(s) and end time(s) (different parts in attack can exist), attack intensity charts/tables (requests per second and per minute) and IP addresses (bots) participating attack and analysis of them (times new bots entered in, how many bots were total, request counts per bot).

Feel free to use any tool/scripting language/existing solution to calculate your analysis.

Analyze how server was burdened. Obviously by sending overload of requests to it, but why just that kind of request was used? You do not know inner workings of server, but make educated guess based on what you see and know.

Can you find person who hypothetically was behind the whole attack? That person made one mistake, and his/hers IP address could be reasoned out from the logs.

### What to return

Your carefully thought out analysis of attack containing **at least** next items:
* Careful analysis of attack start/end time, intensities and bots participating it (analysis targets described above). Your style of reporting is free-formed, but depth and quality of analysis is expected to be sufficient.
* Well-reasoned explanation why certain type of request were used in DDoS attack.
* IP address which points towards the real person controlling the botnet, and reasoning why you ended up to that conclusion.

Fill your answers to the return template.

## Task 3: TBA

TBA



## Bonus task: Data recovery & steganography

The story continues with Mallory from the task 1.

### A) Data hiding & password recovery (0.5p)

> *Interrogator: We have started investigating that USB memory stick found next to your computer. Would you be nice enough to bother telling what data is on that stick?*
> 
> *Mallory: Of course. I am totally innocent so I can tell that on that stick was couple of totally useless RTF and PDF documents. And I kept some lorem ipsum flle and bunch of random strings there too.*
> 
> *Interrogator: "Was" and "kept". What do you mean?*
> 
> *Mallory: Well, I deleted everything. And formatted that stick too. Sadly everything is gone, otherwise I would have given everything to you because I totally have nothing to hide.*
> 
> *Interrogator: Well, I see. When you cleared that stick then?*
> 
> *Mallory: Just 15 seconds before you burst in through my door. What a coincidence!*
> 
> *Interrogator: Sure.*

Technical investigator attaches Mallorys memory stick to his machine by using write-blocker device. Stick seems to be empty and freshly formatted as Mallory implied. Technical investigator utilizes his tools to create raw disk-dump of that USB-stick and then gives it to you.

Your task is next:
* Recover RTF and PDF documents (1 RTF, 2 PDFs)
  * You must independently utilize your skills, creativity and hints from memory dump to decrypt PDF document content

#### Hints and links

Carve out deleted documents from disk and proceed on your task as you see fit.

Useful tools and utilities
* `foremost`, common tool for recovering files
* `scalpel`, another tool based on foremost
  * Learn to use custom configuring of it to carve files that foremost can not
* Any hex editors/readers (for example Ghex and hexdump) for investigating raw memory
* `hashcat`
  * Utility for recovering passwords, high amount of features for different situations
* `rockyou.txt`
  * Enormous collection of commonly used passwords
* `pdf2john.py` is utility for extracting hash information from PDF files

Some hints:
* Scalpel might sometimes produce broken files, try with another configurations or foremost
* Some PDF-readers might not handle AES-256 encrypted PDF well. They claim that the password is incorrect even when it is not. Try with another PDF-capable program (for example with internet browser).
* Hashcat might require some other libraries to be installed before it runs correctly
* Feel free to utilize any other tool you can find to solve these tasks
* Files with strong encryption and long enough passwords are unfeasible to be bruteforced
* Mallory might have kept some unnecessary file clutter on his USB-stick just to annoy anybody else who happens to read it.
* [File slack space](https://www.google.com/search?q=file+slack+space)


### B) Detecting and analyzing steganography (0.5p)

> *Investigator: Hey, I found something interesting*
> 
> *You: Ok, bring it on.*
> 
> *Investigator: I digged out some of Mallorys public online profiles and found that he has profile on this service*
> 
> *You: Not surprising - Even you and I and 50% of population of this nation have profile there*
> 
> *Investigator: Correct. You can see that Mallorys public profile lists all interest groups he has membership of. One of the groups gathered my attention: United Space Photo Gatherers - USPG. Do you see what I mean?*
> 
> *You: Hmm, yesss. Mallory seems not to be that kind of person who has interest on sharing and discussing space images*
> 
> *Investigator: I thought the same. I joined that group myself and started digging around little. Seems like that Mallory joined that group 2 years ago but has not posted single image or comment to that group - ever*
> 
> *You: Odd, but could be explained by that he just joined group and then forgot its existence. Happens to everybody sometimes*
> 
> *Investigator: So I thought. Until I went to the statistics page of that group. Obviously Mallory is not on those highly wanted "TOP 10 Poster of month"-listings at all, but some miscellaneous statistics show that he has been amongst TOP 100 frequent visitors during last 2 years. That is more than 99% of whole group.*
> 
> *You: That is weird. So what is your conclusion?*
> 
> *Investigator: I suspect that Mallory is using that message group as covert channel to receive messages from his criminal partners. Could you take a look at those images and either confirm or deny my theory?*
> 
> *You: I'll see what I can do*

Your task is to find 4 different suspicious images, and then extract the clear-text of the messages hidden into them. 

#### Hints and links

Steganography is practice of concealing actual information inside innocuous-looking information.

First problem is to identify image which is holding secret information, second problem is to find how to extract it.

Useful info
* [Useful overview to steganography](https://en.wikipedia.org/wiki/Steganography)
* Useful command line commands: `strings`, `hexdump`, `foremost`, `binwalk`
* [StegExpose](https://github.com/b3dk7/StegExpose) - Tool for detecting LSB steganography
* [zsteg](https://github.com/zed-0xff/zsteg) - Tool for detecting and extracting steganography
* steghide and its counterpart [StegCracker](https://github.com/Paradoxis/StegCracker)

Hints:
* Simplest form of hiding text in image is simply writing it straight to the image data, as plain text or encoded text (2 images)
  * Tools like `strings` and `hexdump` are useful in these cases
  * Somebody could encode their message before injecting it to the image file, so you must decode it too
* More advanced image steganography includes modification of least-significant-bits (LSB) of PNG images (1 image)
  * Statistical tools exists to detect if image is tampered somehow
  * Tools like StegExpose and zsteg can detect and extract LSB-hidden information from images
* It is possible to include file into another file (1 image)
  * Obviously it makes file bigger than it should be
  * Tools like foremost and/or binwalk can detect this kind of file-in-file tampering
  * Image steganography tool `steghide` can encrypt and hide information to image very efficiently
    * That tool has counter named `StegCracker`, which bruteforces information hidden with `steghide` out of the image (but you have to provide wordlist for it)
  * Last hint for this target comes from interrogation log:
> *Interrogator: By the way, if you hid your secret data to image with some tool supporting encryption, would you use some leetspeak version of your own name as password? Like `m4lL0rY`*
> 
> *Mallory: H-h-haha, of couse not - I am not obviously that stupid!*
> 
> *Mallory starts to sweat visibly*
