Return-Path: <linux-kernel-owner+w=401wt.eu-S965365AbXDGF6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965365AbXDGF6s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 01:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965356AbXDGF6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 01:58:48 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:44799 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965312AbXDGF6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 01:58:46 -0400
Message-Id: <1175925525.21154.1183436614@webmail.messagingengine.com>
X-Sasl-Enc: 50NycYwAxnYqIZGNuakdXn2aOFcnUUPvrBEpTQNN/pyv 1175925525
From: johnrobertbanks@fastmail.fm
To: "Jan Harkes" <jaharkes@cs.cmu.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
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
   <20070406152119.GC4228@delft.aura.cs.cmu.edu>
   <1175914056.9653.1183426876@webmail.messagingengine.com>
   <20070407033049.GI4228@delft.aura.cs.cmu.edu>
Subject: Re: Reiser4. BEST FILESYSTEM EVER.
In-Reply-To: <20070407033049.GI4228@delft.aura.cs.cmu.edu>
Date: Fri, 06 Apr 2007 22:58:45 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


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
realize that you were be so impolite.

As to your email being private, I had thought I had joined a mailing
list. I had not idea your email was meant to be private and just
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
the first time around, as I was not convinced of their worth.

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
http://www.fastmail.fm - Choose from over 50 domains or use your own

