Return-Path: <linux-kernel-owner+w=401wt.eu-S1750917AbZEFVpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750917AbZEFVpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 17:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbZEFVoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:44:39 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:58592 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbZEFVoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:44:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MfP9F4W0/hf4ANIT54i+RRmNzdopSSHLfZ5G03zubJpE875EzedzKJLX4sadG0P+tv
         PcN6KuzrUBAEiFkkl/7Zc39UsKmTpKmN0kTO0uERYa5gI9RnwdDEOtBgsxUTBVdaCecg
         Ealgcc6tPHxtFL7b8DHNAmEt+dKb9rq+/HIdQ=
Subject: Re: Fusion-IO
From: Clive Wagenaar <clivewagenaar@gmail.com>
Reply-To: clivewagenaar@gmail.com
To: Tony Vroon <tony@linx.net>
Cc: Theodore Tso <tytso@mit.edu>, Andy <genanr@emsphone.com>,
       jason@dvnation.com, lkml <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>
In-Reply-To: <20090506125036.453252e0@linx.net>
References: <1241028283.4624.92.camel@9200>
	 <20090506125036.453252e0@linx.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 May 2009 22:44:27 +0100
Message-Id: <1241646267.3759.35.camel@9200>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-06 at 12:50 +0100, Tony Vroon wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On Wed, 29 Apr 2009 19:04:43 +0100
> Clive Wagenaar <clivewagenaar@gmail.com> wrote:
> 
> > Has Fusion-IO managed to release the ioxtreme yet?
> 
> Yes, we got our hands on a 80GB unit this morning. They're out in the
> United Kingdom. It was 3600GBP + VAT.
> 
> > Can you deliver to Ireland?
> 
> You should probably talk to DiamondPoint, which is where ours came from:
> http://www.dpie.com/contact.html
> 
> They should be responsive, but if not, e-mail me and I'll get you a
> direct contact.
> 
> > I take it one would have to compile the drivers from source if ones
> > kernel is later than the drivers they have on their site for ones
> > kernel?
> 
> - From what I can see they offer kernel sources. The OS selection is a
> bit pedestrian, but with some searching you can find a tarball.
> 
> >         Will the driver be incorporated into the Linux kernel
> > directly?
> 
> If you talk to FusionIO, please suggest Greg's staging tree to them.
> They could submit their current driver and have volunteers improve on
> it until it gets to a state where it can enter the mainline kernel.
> 
> Regards,
> Tony V.
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.11 (GNU/Linux)
> 
> iEYEARECAAYFAkoBeY8ACgkQp5vW4rUFj5qCEgCcDBq5Rn8zRfrzCuWxGGWfZZhW
> 5IgAoJ/lBXhxvKiMyMvJwHBIDaC4o53a
> =IbkO
> -----END PGP SIGNATURE-----

I ended up with a OCZ Vertex 120G SDD for under €400, 200MB/s read, they
seem very active with their firmware updates, also very responsive to
user feedback.
The drive is probably a bit slower than the x25-m, but then a lot
cheaper and they seem alot more customer focused and should support trim
before Intel on the x25 drives

It arrived today, Ubuntu 9.04 boots in 11 seconds on bootchart and 15
seconds to get into GDM with Arora browser at google homepage.
Best I got with 7200 Seagate Barracuda drive was 17 seconds.
As a whole desktop is very response for now.
Will be fine as 120G drive and 9.04 only uses 4G on my setup.
I will reflash if its slows down before 'trim' happen between Ocz and
Linux.

Within the next 2 weeks they will be releasing new firmware that will
support the trim ATA 'standard' for the linux kernel.
They have a tool/exe the runs under 32 windows to trim the drive for
windows file-systems, but its not integrated into Windows as they
waiting, zzz, for MS to implement it which could be window 7 release, or
maybe only W7 + SP1. (Does not help that the ATA standard is not yet
approved). Their Windows exe runs from within widoews, but obviously
only trims windows filesystems

Tony, the main forum staff chap, indicates native linux support soon:
http://www.ocztechnologyforum.com/forum/showthread.php?t=55632&highlight=trim+linux

Snip:
Mid May or earlier we should see a new FW with native Linux TRIM for
beta testing 

I will be testing it and have plenty of time to test for Linux kernel
devs or OCZ, this is why I bought the drive .

If I can help test trim under Linux, it would be my pleasure.






-- 
clivewagenaar@gmail.com

System Powered by:
Ubuntu/Debian/Gnu/Linux
Distro: Jaunty 9.04
Kernel: 2.6.30-rc4-generic
File System: Ext4
Gnu+Linux user #419390
Ubuntu user #1072

