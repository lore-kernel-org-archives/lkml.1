Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbXDHVu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbXDHVu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 17:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbXDHVu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 17:50:57 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:44139 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751999AbXDHVuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 17:50:54 -0400
Message-Id: <1176069053.31062.1183584012@webmail.messagingengine.com>
X-Sasl-Enc: PPgjZkUfipbhL6IlQu3QMa9yn3YBmoIBR+jHDij7/kb6 1176069053
From: johnrobertbanks@fastmail.fm
To: "Christer Weinigel" <christer@weinigel.se>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       reiserfs-list@namesys.com
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <46157B5B.5000602@gmail.com>
   <1175817921.18400.1183285196@webmail.messagingengine.com>
   <461592FB.5060507@zytor.com>
   <1175819681.20754.1183287946@webmail.messagingengine.com>
   <461596DE.2020802@zytor.com>
   <1175823288.25662.1183293506@webmail.messagingengine.com>
   <4615C780.5040407@zytor.com>
   <1175833931.8916.1183307802@webmail.messagingengine.com>
   <20070407191715.GG3510@csclub.uwaterloo.ca>
   <1175993097.32498.1183512070@webmail.messagingengine.com>
   <m3zm5jebad.fsf@zoo.weinigel.se>
Subject: Re: Reiser4. BEST FILESYSTEM EVER - Christer Weinigel
In-Reply-To: <m3zm5jebad.fsf@zoo.weinigel.se>
Date: Sun, 08 Apr 2007 14:50:53 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Christer Weinigel: Until YOU, have actually used the REISER4 filesystem
yourself, I think YOU OWE IT to the people on the linux-kernel mailing
list, to, AS YOU SAY, shut the fuck up. 

Even reading up on the REISER4 filesystem would help. 

Applying a little intelligence would undoubtedly help too.

> johnrobertbanks@fastmail.fm writes:
> 
> > Lennart. Tell me again that these results from 
> > 
> > http://linuxhelp.150m.com/resources/fs-benchmarks.htm and
> > http://m.domaindlx.com/LinuxHelp/resources/fs-benchmarks.htm
> > 
> > are not of interest to you. I still don't understand why you
> > have your head in the sand.
> 
> Oh, for fucks sake, stop sounding like a broken record.  

Oh, for fucks sake, would you, and your religious anti-REISER cohorts,
stop sounding like a broken record.

> You have repeated the same totally meaningless statistics more 
> times than I care to count.  Please shut the fuck up.

You, and your religious anti-REISER cohorts, have indeed repeated the
same broken arguments (if you can call them such) more times than I care
to count.

NO statistics, NO real facts, just selective MANIPULATION of facts.

> Please shut the fuck up.

Yes, why don't you politely, shut the fuck up.

Until YOU, have actually used the REISER4 filesystem yourself, I think
YOU OWE IT to the people on the linux-kernel mailing list, to shut the
fuck up, as YOU say.

I guess, the fact that you are a TOTAL HYPOCRITE, has completely escaped
you.

By the way: Did I thank you "delightful" people for the "pleasant"
welcome to the linux-kernel mailing list?

-----------------------------------------------------------------

> So the two bonnie benchmarks with lzo and gzip are
> totally meaningless for any real life usages.

YOU (yes, the one with no experience and next to NO knowledge on the
subject) claim that because bonnie++ writes files that are mostly zeros,
the results are meaningless. It should be mentioned that bonnie++ writes
files that are mostly zero for all the filesystems compared. So the
results are meaningful, contrary to would you claim.

And hopefully all will notice that you just ignore these tests:

.-------------------------------------------------.
|File         |Disk |Copy |Copy |Tar  |Unzip| Del |
|System       |Usage|655MB|655MB|Gzip |UnTar| 2.5 |
|Type         | (MB)| (1) | (2) |655MB|655MB| Gig |
.-------------------------------------------------.
|REISER4 gzip | 213 | 148 |  68 |  83 |  48 |  70 |
|REISER4 lzo  | 278 | 138 |  56 |  80 |  34 |  84 |
|REISER4 tails| 673 | 148 |  63 |  78 |  33 |  65 |
|REISER4      | 692 | 148 |  55 |  67 |  25 |  56 |
|NTFS3g       | 772 |1333 |1426 | 585 | 767 | 194 |
|NTFS         | 779 | 781 | 173 |   X |   X |   X |
|REISER3      | 793 | 184 |  98 |  85 |  63 |  22 |
|XFS          | 799 | 220 | 173 | 119 |  90 | 106 |
|JFS          | 806 | 228 | 202 |  95 |  97 | 127 |
|EXT4 extents | 806 | 162 |  55 |  69 |  36 |  32 |
|EXT4 default | 816 | 174 |  70 |  74 |  42 |  50 |
|EXT3         | 816 | 182 |  74 |  73 |  43 |  51 |
|EXT2         | 816 | 201 |  82 |  73 |  39 |  67 |
|FAT32        | 988 | 253 | 158 | 118 |  81 |  95 |
.-------------------------------------------------.


where the files are definitely NOT mostly zeros. 

Your negligence has to be deliberate,... but why?

Are you manipulating the facts just to try and win an argument?

Most sane people will realize, that what you say is simply wrong.

ALSO YOU IGNORE examples offered by others, on lkml, which contradict
your assertion: FOR EXAMPLE:

> I see the same thing with my nightly scripts that do syslog analysis, last year 
> I trimmed 2 hours from the nightly run by processing compressed files instead of 
> uncompressed ones (after I did this I configured it to compress the files as 
> they are rolled, but rolling every 5 min the compression takes <20 seconds, so 
> the compression is < 30 min)

>From David Lang http://lkml.org/lkml/2007/4/7/196

Willy Tarreau also mentions this situation in a couple of articles.

Let me spoon feed you:

David has said that compressing the logs takes

24 x 12 x 20 secs = 5,760 secs = 1.6 hours of CPU time (over the day)

but he saves 2 hours of CPU time on the daily syslog analysis.

For a total (minimum) saving of 24 minutes.

The actual saving is probably much greater. It depends on the CPU
utilization when not compressing, ie, whether you are using ide CPU
cycles or not. I guess it also depends on whether you can go home one
and a half hours earlier by using compression, or if your boss makes you
stick around anyway.

NOTE THAT THE FILES IN THIS EXAMPLE ARE ALSO NOT MAINLY ZEROS.

MAYBE you just lacked the knowledge to understand what David was saying,
or maybe your desire to denigrate REISER4 is so strong, that you simply
don't care what other people say about similar circumstances.

I am not sure why you have to be spoon feed on these matters, or why you
adamantly refuse to find the facts of the matter, for yourself.

-----------------------------------------------------------------
-----------------------------------------------------------------

On Fri, 6 Apr 2007 23:30:49 -0400, "Jan Harkes" <jaharkes@cs.cmu.edu>
said:
> 
> Since you decide to publically respond to a private email, but not only
> you did not 'discuss' anything I wrote and in fact cut out most of the
> useful information in my reply I guess I will have to repeat my
> observations.

You are a funny guy Jan.

Here you are, once again, cutting out my most useful information, ie,
the data I was discussing, while complaining that I cut out your most
useful information. 

You know,... you cut out this bit:

-----------------------------------------------------------------

> The following benchmarks are from
> 
> http://linuxhelp.150m.com/resources/fs-benchmarks.htm or,
> http://m.domaindlx.com/LinuxHelp/resources/fs-benchmarks.htm
> 
> .-------------------------.
> | FILESYSTEM | TIME |DISK |
> | TYPE       |(secs)|USAGE|
> .-------------------------.
> |REISER4 lzo | 1938 | 278 |
> |REISER4 gzip| 2295 | 213 |
> |REISER4     | 3462 | 692 |
> |EXT2        | 4092 | 816 |
> |JFS         | 4225 | 806 |
> |EXT4        | 4408 | 816 |
> |EXT3        | 4421 | 816 |
> |XFS         | 4625 | 779 |
> |REISER3     | 6178 | 793 |
> |FAT32       |12342 | 988 |
> |NTFS-3g     |10414 | 772 |
> .-------------------------.
> 
> Column one measures the time taken to complete the bonnie++ benchmarking test (run with the parameters bonnie++ -n128:128k:0)
> 
> Column two, Disk Usage: measures the amount of disk used to store 655MB of raw data (which was 3 different copies of the Linux kernel sources).

-----------------------------------------------------------------

And this bit: 

Jan,... Here is another section, you conveniently cut out. Maybe you
should explain why you cut out this section? Was it embarrassing to you?
I mean, your statement is sort of correct,... but it shows a basic
misunderstanding of filesystems.

> > With compression there is a pretty high probability that one corrupted
> > byte or disk block will result in loss of a considerably larger amount
> > of data. 
> 
> Bad blocks are NOT dealt with by the filesystem,... so your comment is
> irrelevant, or just plain wrong.
> 
> If your filesystem is writing to bad blocks, then throw away your
> operating system.

-----------------------------------------------------------------

It is true that I considered your "most useful information," an
irrelevant section, which is why it was cut out (ignored).

I did not see my doing this, any worse than you doing it. I did not
realize that you were being so impolite.

As to your email being private, I had thought I had joined a mailing
list. I had no idea your email was meant to be private and just
considered it like all the others.

Now you mention it, I wondered why the email did not automatically list
the mailing lists, as recipients, and I had to add them. If I had
realized this I may have added the mailing lists as recipients, anyway.
It would be like me to do such. However, you should understand that I am
new to mailing lists.
 
> 
> > > Do you really have to repeat the results in every email you sent?
> > 
> > Damn, I did it again. WHY DO YOU CARE?
> 
> Because I saw them the first time around. And although the performance
> difference on those micro benchmarks seems quite impressive, I'm not
> convinced.

So, likewise, I saw your comments (you know the ones you miss so much)
the first time around, and I ignored them, as I was not convinced of
their worth.

The benchmarks measure certain data. Its fine you do not read into them,
stuff that isn't there, like reliability, for example. 

> > Look, its simple, I am (among other things) discussing these results, so
> > people need to see them.
> 
> However, you do not discuss, you just repeat, and repeat, and repeat.

I never said I wanted discussion, you just said I did.

You just repeat, and repeat, and repeat.

In reality, I quite appreciate reasonable discussion. But, I doubt I
will get much from you.

> But for what reason. Do you want an actual discussion, or do you hate
> the reiserfs developers so much that you want to antagonize any and all
> other Linux file systems developers?

Why do you think I hate reiserfs developers? That is an insane claim.
Why would I hate reiser3 developers?
Why would I hate reiser4 developers? 
Why would I even dislike them?

I think Hans Reiser is a genius. Is that what you mean by hate?

Answer this question. Why do YOU think I am antagonizing reiserfs
developers?

You must have a reason for stating what you have.

> > By the way, I have pulled the plug on my REISER4 system, a number of
> > times now, and it recovers without problem.
> 
> Very nice for you. I guess you have also not been hit by out of memory
> conditions or failing partial writes. So I guess we can ignore the patch
> that was just sent a day or two ago to the mailing list because you
> succesfully pulled the plug, a number of times at that.

Why are you attacking me with sarcasm, when I have just stated a simple
fact?

> > > > I have set up a Reiser4 partition with gzip compression, here is the
> > > > difference in disk usage of a typical Debian installation on two 10GB
> > > > partitions, one with Reiser3 and the other with Reiser4.
> > > > 
> > > > debian:/# df
> > > > Filesystem           1K-blocks      Used Available Use% Mounted on
> > > > /dev/sda3             10490104   6379164   4110940  61% /3
> > > > /dev/sda7              9967960   2632488   7335472  27% /7
> > > ...
> > > > Partition 3 is Reiser3 -- uses 6.4 GB.
> > > > Partition 7 is Reiser4 -- uses 2.6 GB.
> > > > 
> > > > So Reiser4 uses 2.6 GB to store the (typical) data that it takes Reiser3
> > > > 6.4 GB to store (note it would take ext2/3/4 some 7 GB to store the same
> > > > info).
> > > 
> > > Wow, consider me totally and completely, unimpressed.
> > > 
> 
> Here is the part of my email that you seemed to totally ignore,

Yes, I ignored it,.... is that a crime?

> You've just saved yourself $3.80, now go get yourself a latte.
> (see. http://tomayko.com/weblog/2006/09/11/that-dilbert-cartoon)
> 
> Seriously, disk storage is getting less expensive all the time, you can
> already buy a 250GB SATA drive for $70. Also, compression doesn't help
> once you store already compressed data such as jpeg images, mp3 files,
> or mpeg2/4/divx video files. Not only are the savings non-existant, but
> we still end up with the disadvantage that corruption propagates to
> multiple files because of the compression in the file system.

I believe that compression in REISER4 is just a wrapper for gzip or lzo.
So each file is compressed and your "corruption propagation" is just in
your imagination.

> And if it doesn't propagate across multiple files, the compression can't
> be all that good 

It can be as good as gzipping every file, ie, pretty damn good.

> since it can't benefit as much from similarity between
> files. So if that is the case and you really want to save diskspace you
> almost have to look at read-only compressed filesystems such as cramfs,
> squashfs, zisofs, cloop and various other variants in combination with
> a unionfs overlay to get read/write functionality.
> 
> But in the end everything is a tradeoff. You can save diskspace, but
> increase the cost of corruption. 

You deliberately ignored the fact that bad blocks are NOT dealt with by
the filesystem,... but by the operating system. Like I said: If your
filesystem is writing to bad blocks, then throw away your operating
system.

> Use a better compression algorithm, but
> that uses more CPU or which is visible in performance of the
> application. 

Not necessarily, just look at the bonnie++ tests. The tests show that
using compression (with todays hardware) leads to read speeds that are
some FOUR times the physical disk read rate,... 

but you ignore this as you have some strange anti-REISER religion.

Think about it,... read speeds that are some FOUR times the physical
disk read rate,... impossible without the use of compression (or
something similar).

> This can be offset by caching more, and being lazier with
> writebacks, but that hurts on-disk consistency, creates more memory
> pressure (more swapout/paging) and generally slows down other
> applications that aren't actually accessing the disk. Having a fast
> multi-core cpu and lots of memory helps a lot, but at some point what
> tradeoff did we just make, we saved a couple of dollars not having to
> buy a larger disk, but we spend considerably more on the more
> expensive cpu and memory.
> 

Wow, consider me STILL totally impressed by your AMAZING BIAS.
Would you like to tell me why you are SO BIASED against REISER4?

John.
-- 
  
  johnrobertbanks@fastmail.fm

-- 
http://www.fastmail.fm - The professional email service

