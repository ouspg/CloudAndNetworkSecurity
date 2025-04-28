Cloud and Network Security Lab 6: Digital Forensics (and Incident Response)
====

Responsible person/main contact: Niklas Saari


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

All memory and image dumps are available as a direct download.
The link is provided in Moodle.

## Important reminder

This lab features tasks that are a little similar to tasks in CTF challenges.
There is a specified type of information hidden somewhere and it is up to you to figure it out.

This means that this lab may be harder than some of the others,
instructions and directions where you should go are more unclear than in the other labs and changes of tool usage problems and other irritating errors are higher than in the other labs.

Other labs might have had simple tutorials/instructions on how to use certain tools during them.
This lab does not do such a thing. You are expected to determine what tools you have to use and learn the usage of them yourself.

There may or may not be multiple ways to solve each task.
You must use your own judgment to determine what ways could or should be pursued to gain success.
Independent thinking/researching of problems and creative problem-solving are highly encouraged.

You are required to install all needed tools yourself and if there happen to be some problems with them - well, hopefully, Google and your good troubleshooting skills can help you then.

Consider yourself to be properly informed after reading this.

If you still want to take this challenge, good luck. You might really need it too.


# Tasks

Read task instructions carefully before starting to work to have a clear picture of what you are supposed to do.

Every task should clearly state what you are expected to do and return.

**If you are doing this work in a group, remember to mark down clearly which of you participated in which tasks**

## Task 1

Welcome to the imaginary day of a digital forensic investigator.
This task has a highly fictional backstory that tries to give meaningful context to tasks. Notice that also any task or skill you will be using might or might not be useful in real life, because this lab does not equal any official digital forensic training.
Also, because this story is purely fictional, any possible connections to real-life events or people are coincidental.

The story starts here.

Mallory is a notorious member of the criminal underworld. He is known for illegal items trade, and he is rumored to have multiple shady contacts supplying him with high-quality "stuff", which has made him easy to gain a foothold in the black market.

Mallory has also a reputation for being a faster talker than a thinker.

Mallory has been successful in his criminal activities lately, giving large influx of money and letting him expand his network, which has made him one of the "big players" of the criminal underworld.

Unfortunately for him, also law enforcement at national level agencies have noticed his success. Mallory has a reputation for being a faster talker than a thinker and because rumors spread fast, becoming known by law enforcement was only a matter of time.

Big wheels start to turn, and a large surveillance operation against Mallory and his minions starts. After 3 months of fruitless efforts, intel from a trusted source appears: Mallory's gang is going to do a drug deal in next day.

Intel turns out to be correct and the leading investigator decides that this is a correct moment to strike. This would not be a major victory, because only a couple of Mallory's men would be caught red-handed, but it still could result in Mallory's conviction if enough evidence is found about his involvement. The situation is not optimal, but small success is better than fruitless waiting of 3 months.

The moment to strike has come: Special units of police crash into the place of the meeting and find 2 of Mallory's crooks with a huge stash of illegal weapons and drugs. Simultaneously multiple carefully coordinated house raids are performed on all known members of Mallory's gang, including Mallory's home himself.

Mallory is caught by surprise when police storm into his apartment and immediately arrest him.

Police officers start to search Mallory's apartment and the technician begins to investigate Mallory's computer which is turned on and logged on.
After discussing with the leading investigator, the technician decides to start dumping the volatile memory of the computer into his external hard drive.
Next to Mallory's computer is an ordinary USB memory stick. That stick is securely bagged into the evidence box for later inspection.

But Mallory has some brutal surprise for the digital forensic technician: Just as the memory dump from volatile memory is secured to the investigator's external drive, Mallory's computer starts to smoke and soon catches on fire explosively. The technician grabs his drive containing a memory dump and runs out of the apartment because toxic smoke from melting components is starting to spread quickly.
The apartment is evacuated in a hurry and human casualties are avoided, but Mallory's improvised dead-man-switch - timed incendiary bomb inside the computer which he supposedly managed to trigger when he heard police breaking in - has rendered the whole machine unsalvageable.

Investigators know that there was so much critical information gone with Mallory's computer and any hope they have left lies in a single memory dump of Mallory's machine and an ordinary USB memory stick.

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

While the exact location remains unknown, intel gathered from other sources suggests that Mallor's organization has been using codenames for those 2 caches: *LAKE* and *COAST*. The leading investigator suspects that those codenames are most likely describing also the places themselves.
The leading investigator also suspects, that hidden caches are mostly located not too far from the city and those should not require a too long distance to be traveled by foot. Also, caches can not obviously be located in densely populated areas.

Your first task is to find 2 different GPS locations where police officers should start for looking hidden stashes.

> *Leading investigator: There is problem with gathering Mallorys emails*
>
> *You: How so? In this case we have a court order for service provider to give us access to Mallorys email-account.*
>
> *Leading investigator: Yes we do, but seems like they all have gone on holiday or something. I did not succeed on connecting to anybody who could give us access right now. Typical corporate bureaucracy in action...*
>
> *You: Oh. That's bad. But eventually we will get it.*
>
> *Leading investigator: Yes we will. But this is urgent because any useful intel we could get from his email might be irrelevant next week because word about Mallory's arrest is spreading and his contacts are going to flee any moment with hidden caches.*
>
> *You: I see. So we have only this memory dump right now. I'll see what I can do.*

Intel from unconfirmed sources says that there are rumors about Mallory having also a third hidden cache. Nothing about it is known but its codename: *FOREST*

Your second task is to retrieve any email exchange between Mallory and his criminal partner. Extract the content of the messages and solve the location of the third hidden cache.

> Fill your answers and reasoning as a mark of completion this task.

#### Hints and links

Volatility is a tool for volatile memory inspection.

Find out what browser Mallory is using and then search for URLs that you want to find from its process memory.

A similar approach can be used in the e-mail task: Determine what program Mallory is using for mail and start digging into the process memory of it.

* [Volatility 3 documentation](https://volatility3.readthedocs.io/en/latest/)
  * Volatility 3 identifies the memory profile automatically
  * Useful volatility3 plugins:  `pslist`, `yarascan`, `memdump`
  * There exist lots of different Volatility plugins: Some may make your life lots easier with this task.
* Exiftool is a tool for inspecting image metadata
* Foremost can extract files of a specified type from other files, for example, memory dumps of processes.


> [!Note]
> The story continues as bonus task later if you are willing to dig into disk forensics and steganography!


## Task 2: Analyzing a DDoS attack

Your next task is to make an analysis and report of the real-world DDoS attack.

There was a real DDoS campaign in Finland some years ago, and this task gives you the one target server's log file.
 A specific kind of malware was responsible for creating a botnet, which used to cause this DDoS attack.
 Malware was mostly spread by YouTube advertising (you can analyse it in the Hardware&Software security course).

More about the case [is available here.](https://www.tamperelainen.fi/paikalliset/1590735)


 You will find the server log file in the same place as the memory dumps of earlier tasks.

After unzipping the log, you may find out that opening the log file (which contains over 6 million lines of data) may crash the regular text editor so you most likely have to utilize other tools to initially investigate of log file. Commands `grep`, `less`, `sort`, `cut`, `awk` and `uniq` might be helpful.

Estimate the following things from the attack: Start time(s) and end time(s) (different parts in the attack can exist), attack intensity charts/tables (requests per second and per minute) and IP addresses (bots) participating attack and analysis of them (times new bots entered in, how many bots were total, request counts per bot).

Analyze how the server was burdened. Obviously, by sending an overload of requests to it, but why just that kind of request was used? You do not know the inner workings of the server, but make educated guesses based on what you see and know.

Can you find the person who hypothetically was behind the whole attack? That person made one mistake, and his/her IP address could be reasoned out from the logs. That got them caught in the end.

You can use existing log analysis tools if you fail to do the task with the Unix tools, but you are not likely to get the full points.

### What to return

Your carefully thought-out analysis of the attack contains **at least** the following items:
* Careful analysis of attack start/end time, intensities and bots participating in it (analysis targets described above). Your style of reporting is free-formed, but the depth and quality of analysis are expected to be sufficient.
Well-reasoned explanation of why certain types of requests were used in DDoS attacks.
* IP address which points towards the real person controlling the botnet, and reasoning why you ended up to that conclusion.

> Fill in your answers to the return template.

## Task 3: XDR and SIEM protection

Wazuh is a free and open-source platform designed for threat prevention, detection, and response.
It protects workloads across on-premises, virtualized, containerized, and cloud-based environments.
The platform unifies extended detection and response (XDR) with security information and event management (SIEM) for endpoints and cloud workloads.
SIEM focuses on monitoring log data from various sources in the network whereas XDR covers a broader range of security telemetry data such as; endpoint data, network traffic and cloud-based environments.

Wazuh solution consists of an endpoint security agent, deployed to the monitored systems, and a management server, which collects and analyzes data gathered by the agents' endpoints.
Besides, Wazuh has been fully integrated with the Elastic Stack, providing a search engine and data visualization tool that allows users to navigate through their security alerts.
Because of its large coverage and adaptability to different environments, Wazuh has become one of the go-to services for SIEM & XDR protection in cloud-based environments.

Understanding the skills of configuring security monitoring systems such as Wazuh, creating custom alerting rules, and analyzing generated alerts is crucial for cloud security and the cyber security industry for several reasons such as:

* Cloud environments have vast attack surfaces and are constantly changing, so being able to detect potential security threats is essential, proactive threat detection and alerting mechanisms allow organizations to identify and respond to security incidents before they escalate.
* Implementing effective alerting mechanisms and demonstrating the ability to analyze generated alerts helps organizations meet compliance and [regulatory requirements](https://documentation.wazuh.com/current/compliance/index.html) to avoid potential penalties and/or legal consequences.

The following image shows the important components and how they communicate with each other to form this service, in the first part of this task we are focusing on the endpoint side of things and in the other tasks the central component configuration will become crucial as well.

![Wazuh Architecture](img/deployment-architecture1.png)

Wazuh has great documentation about different ways of its usage, you can find more about it here:
* https://documentation.wazuh.com/current/index.html

### A) Host system & Docker monitoring (1p)
In this task, you will explore the capabilities of Wazuh by creating a basic log auditing system for the host machine.
The course staff has provided an initial script that installs the required components in order to run the cluster locally.

Contrary to last week, this week's deployment has been optimized for the Minikube version of Kubernetes. You can find information about setting this up from the [official documentation.](https://minikube.sigs.k8s.io/docs/start/)

For the course VM, check the [Arch Linux Wiki](https://wiki.archlinux.org/title/Minikube) entry and **use the Docker driver**. By default, Minikube runs in VirtualBox virtual machine, which is not likely the most optimal for us.


To launch the Minikube Kubernetes cluster run `minikube start --driver=docker --container-runtime=containerd` and then deploy Wazuh itself with `deploy_wazuh.sh` shell script.

The script does the following:
  * Installs required Kubernetes components with `helm`, such as Ingress controller for Nginx.
  * Generates self-signed certificates since Wazuh deployment uses always HTTPS protocol
  * Downloads up-to-date Kubernetes configuration from the [upstream](https://github.com/wazuh/wazuh-kubernetes/tags) (Currently supported version is v4.11.2)
  * Deploys the configuration

These services are called `wazuh-indexer`, `wazuh-dashboard`, `wazuh-cluster`, `wazuh` and `wazuh-workers`.
Wazuh-indexer service handles the communication between indexer nodes which are used by the API to read and write alerts, dashboard contains the frontend side of Wazuh, wazuh service handles the authentication of wazuh agents and wazuh-workers is the reporting service of this tool.

Example of successful deployment of pods:

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/55877405/1c656c9d-b29c-473f-a605-079c9fc95b66)


Example of successful deployment of services:

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/55877405/756253e6-f681-4dec-adab-67ab2373a811)


Once you have successfully launched the Kubernetes services and they are in READY and Running states (this can take a bit), you need to open certain ports in the cluster to access the Wazuh dashboard in the host machine and to create agents. The important ports are the following:

* 443 Wazuh web user interface
* 55000 Wazuh server RESTful API
* 1514 (TCP/UDP) The agent connecion service
* 1515 (UDP) The agent enrollment service

You can do this using the `kubectl port-forward` command or the `minikube service` command. (Keep in mind Wazuh resources are in the Wazuh namespace)
>[!Note]
>Keep in mind to what port the services are port-forwarded to on the host machine, you will need this port for later when configuring the agent to connect to the Wazuh server, you will need to edit the ossec.conf to use the port assigned by minikube. If you use kubectl you can define the ports to their respective ones (1514:1514, 1515:1515 ... etc), but minikube service will automatically assign some random ports which will need to be kept in mind when connecting the agent.

Example of Minikube service output:

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/55877405/ce632966-88ed-4894-9ce3-2ac72c8e90fc)


Once you have opened the ports and gained access to the Wazuh dashboard at `https://<wazuh_server_ip>:<port>` (for example https://localhost:8443) you can log in to the admin with the following credentials: `admin:SecretPassword`, afterward, if you navigate to Modules/Security Events, you should see the following (without data):

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/55877405/e072a066-39de-4496-b342-ae50a2da7a75)


Your task now is to install and configure a Wazuh agent to monitor your host machine to audit logs from Docker and analyze the data that is sent to the Wazuh server. You can deploy agents easily by navigating to the Agents page in the Wazuh dashboard and following the instructions to deploy a new agent with the packages related to your system.

Example of Wazuh agent deployment in the dashboard:

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/55877405/f536191f-18ed-4703-bb74-57ecd5efdfea)


You can find out more information about configuring the agent and Wazuh server to audit Docker containers from:
https://documentation.wazuh.com/current/user-manual/capabilities/container-security/index.html

If you encounter issues with registering an agent or in general you can look for the logs generated by the Wazuh Kubernetes pods in the Wazuh namespace, you can use the default `kubectl` commands to see the logs for example:

```sh
kubectl logs wazuh-dashboard-949b86888-27dhj -n wazuh
```

Once you have successfully deployed the agent you should see an active agent in the Wazuh dashboard:

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/55877405/3a1e13d1-5b3e-457e-b74e-22dede9dd964)

Now configure the agent by editing the [ossec.conf](https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/index.html) file, this can be found in Linux systems from `/var/ossec/etc/ossec.conf`. After this, you should start seeing logs from Docker when deploying containers in the Docker listener section of the Wazuh dashboard. Now play around, and see if you can get the agent to audit logs from other applications in your system and/or run commands in the docker containers, particularly using sudo and/or installing packages in them.


Example of Docker logs in the Wazuh dashboard:

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/55877405/98e83a52-fa50-4f4b-8ed0-c2de6fe0bc8e)


**Document your process of deploying and configuring the agent, and provide images of the dashboard and logs generated by the agent**

**What kind of different logs did you get the Wazuh agent to audit?**

**What kind of MITRE ATT&CKS did you get?**


### B) Create a monitor for Wazuh against potential attacks (1p)

This task focuses on simulating attacks and configuring the server and agent to react to these potential threats. This allows the student to gain experience in setting up a security monitoring system and configuring it to specific needs.

In the first task, the server side of Wazuh was preconfigured for you during the deployment. This task requires you to edit the deployment files for this week as you need to be able to edit the Wazuh manager during deployment to ensure the server gets the required configurations initialized. You also may need to configure the local Wazuh agent to output new logs to the Wazuh server. The configuration you make should demonstrate an alert that is caused by some kind of attack on the target machine (where the agent is running).

You can find more information and ideas from the Wazuh documentation:
* https://documentation.wazuh.com/current/proof-of-concept-guide/index.html

To edit the Wazuh server's ossec config, you can make changes to the file at `week6/wazuh/wazuh_managers/wazuh_conf/master.conf`

There is an example in `week6/wazuh_managers/wazuh-master-sts.yaml` about how to initialize a custom local_decoder.xml file located in `/var/ossec/etc/decoders`, in essence you need to create a Kubernetes ConfigMap for the file you want to edit in the Kubernetes wazuh-manager-master-0 pod for it to take effect in the server side of Wazuh, you also need to instruct the wazuh-manager-master StatefulSet to use this configmap in the volumes and volumeMounts sections of the `.yaml`.

You can use the following command to interact with pods (change the <pod_name> accordingly):

```sh
kubectl exec -it <pod_name> -n wazuh -- /bin/bash
```

Example of an ossec-decoder configmap:

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/55877405/18da1d55-e349-455b-8e45-736fd2e7c4cf)

Example of volume change for wazuh-manager-master:

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/55877405/c93f6811-5b89-421a-a346-fc95e29cad92)

Example of volumeMounts-change for wazuh-manager-master:

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/55877405/8b81b9fb-3506-438c-b0bc-738108d42746)


There are a multitude of options to choose from for new monitors in the following links:

* https://documentation.wazuh.com/current/cloud-security/monitoring.html
* https://documentation.wazuh.com/current/user-manual/index.html
* https://documentation.wazuh.com/current/user-manual/api/use-cases.html
* https://documentation.wazuh.com/current/user-manual/capabilities/container-security/use-cases.html

You are free to choose what kind of "attacks" you are creating and alerting/monitoring rules, but some good ideas that could be implemented are:
* Detecting an SQL injection attack
* Detecting a shellshock attack
* Monitoring GitHub audit logs

>[!Note]
>Make sure to censor any important data such as APIKEYs!

**To get full points for this section, you need to provide the .yaml files that you edit for the Kubernetes deployments, provide your Wazuh agent's /var/ossec/etc/ossec.conf file, provide images of the new logs, and alerts shown in the Wazuh dashboard, explain what the new monitor is logging and how you simulated an attack.**



## Bonus task: Data recovery & steganography

The story continues with Mallory from task 1.

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

The technical investigator attaches Mallory's memory stick to his machine by using a write-blocker device. Stick seems to be empty and freshly formatted as Mallory implied. Technical investigator utilizes his tools to create a raw disk dump of that USB stick and then gives it to you.

Your task is next:
* Recover RTF and PDF documents (1 RTF, 2 PDFs)
  * You must independently utilize your skills, creativity and hints from the memory dump to decrypt PDF document content

#### Hints and links

Carve out deleted documents from the disk and proceed with your task as you see fit.

Useful tools and utilities
* `foremost`, a common tool for recovering files
* `scalpel`, another tool based on the foremost
  * Learn to use custom configuring of it to carve files that foremost can not
* Any hex editors/readers (for example Ghex and `hexdump`) for investigating raw memory
* `hashcat`
  * Utility for recovering passwords, high amount of features for different situations
* `rockyou.txt`
  * Enormous collection of commonly used passwords
* `pdf2john.py` is a utility for extracting hash information from PDF files

Some hints:
* Scalpel might sometimes produce broken files, so try with other configurations or foremost
* Some PDF readers might not handle AES-256 encrypted PDF well. They claim that the password is incorrect even when it is not. Try with another PDF-capable program (for example with an internet browser).
* Hashcat might require some other libraries to be installed before it runs correctly
* Feel free to utilize any other tool you can find to solve these tasks
* Files with strong encryption and long enough passwords are unfeasible to be brute-forced
* Mallory might have kept some unnecessary file clutter on his USB stick just to annoy anybody else who happens to read it.
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

Your task is to find 4 different suspicious images, and then extract the clear text of the messages hidden in them.

#### Hints and links

Steganography is the practice of concealing actual information inside innocuous-looking information.

The first problem is to identify the image which is holding secret information, second problem is to find how to extract it.

Useful info
* [Useful overview of steganography](https://en.wikipedia.org/wiki/Steganography)
* Useful command line commands: `strings`, `hexdump`, `foremost`, `binwalk`
* [StegExpose](https://github.com/b3dk7/StegExpose) - Tool for detecting LSB steganography
* [zsteg](https://github.com/zed-0xff/zsteg) - Tool for detecting and extracting steganography
* steghide and its counterpart [StegSeek](https://github.com/RickdeJager/stegseek)

Hints:
* The simplest form of hiding text in an image is simply writing it straight to the image data, as plain text or encoded text (2 images)
  * Tools like `strings` and `hexdump` are useful in these cases
  * Somebody could encode their message before injecting it into the image file, so you must decode it too
* More advanced image steganography includes modification of least-significant-bits (LSB) of PNG images (1 image)
  * Statistical tools exist to detect if the image is tampered with somehow
  * Tools like StegExpose and `zsteg` can detect and extract LSB-hidden information from images
* It is possible to include the file in another file (1 image)
  * Obviously, it makes the file bigger than it should be
  * Tools like `foremost` and/or `binwalk` can detect this kind of file-in-file tampering
  * Image steganography tool `steghide` can encrypt and hide information in images very efficiently
    * That tool has a counter named `StegCracker`, which brute forces information hidden with `steghide` out of the image (but you have to provide a wordlist for it)
  * The last hint for this target comes from the interrogation log:

> *Interrogator: By the way, if you hid your secret data to image with some tool supporting encryption, would you use some leetspeak version of your own name as password? Like `m4lL0rY`*
>
> *Mallory: H-h-haha, of couse not - I am not obviously that stupid!*
>
> *Mallory starts to sweat visibly*
