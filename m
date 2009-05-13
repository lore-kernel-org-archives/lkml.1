Return-Path: <linux-kernel-owner+w=401wt.eu-S1752806AbZEML5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbZEML5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 07:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbZEML5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 07:57:06 -0400
Received: from relay02-haj2.antispameurope.com ([83.246.65.52]:49890 "EHLO
	relay02-haj2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753016AbZEML5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 07:57:05 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 May 2009 07:57:04 EDT
Date: Wed, 13 May 2009 13:50:14 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: kyle@moffetthome.net
Cc: linux-kernel@vger.kernel.org, adi@hexapodia.org
Subject: Re: [2.6.30-rc2] CD-R: wodim intermittent failures: [sr0] Add. Sense: Logical block address out of range, sector 0
Message-ID: <4a0ab3f6.UuVdUeUlH1++jMSg%Joerg.Schilling@fokus.fraunhofer.de>
References: <49f07fa8.UFHStOXJD5eYq3ER%Joerg.Schilling@fokus.fraunhofer.de>
 <f73f7ab80905121852y42b200a4rfa25ed2b76dd3754@mail.gmail.com>
In-Reply-To: <f73f7ab80905121852y42b200a4rfa25ed2b76dd3754@mail.gmail.com>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 May 2009 11:50:14.0968 (UTC) FILETIME=[FAAE5380:01C9D3C0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett <kyle@moffetthome.net> wrote:

> On Thu, Apr 23, 2009 at 10:48 AM, Joerg Schilling
> <Joerg.Schilling@fokus.fraunhofer.de> wrote:
> > I see two possible problems that should be first resolved.
> >
> > 1)      You are using "wodim" instead of cdrecord.
> >        "wodim" is a very old version (4+ years) of cdrecord with
> >        additional bugs. Due to Copyright & GPL violations, it cannot
> >        even be legally distributed.
>
> Not to get into a flamewar on this, but multiple sources disagree with
> you on this point.  Just so it is clear... I do not expect a reply to
> this message and I will not read one if it is sent.  I simply wish to
> exercise my free speech rights and provide potentially useful
> information.

I cannot speak for other parts of the world (e.g. USA) but in Europe, 
Free Speech ends in case you try to you distribute incorrect claims.

> Since you released cdrtools under the GPL, you cannot possibly expect
> to claim that someone else distributing a copy under the same license
> is violating your copyright.  You also cannot claim trademark

It seems that you are not well informed about the Copyright law.
The Copyrigfht law has a higher precedence than a private contract like the GPL.
For specifc terms, the GPL text is irrelevent and the Copyright law applies.

> References:
> http://lwn.net/Articles/195167/
> http://en.wikipedia.org/wiki/Cdrkit
> http://www.cdrkit.org/

Why do you quote FUD?


> If you would like to contest specifics of GPL compliance, please also
> reference a rather extensive body of other GPL work (incl. the Linux
> kernel) which does *NOT* require the following (this list partially
> taken from your webpage at
> http://cdrecord.berlios.de/new/private/linux-dist.html):
>
>   *  Tracking the author and date for every individual change in every
> file.  If this was true, the Linux kernel source (for example) would
> be roughly 95% changelogs.

This is a requirement from the GPL and nobody usually care about this 
unless you have an extremely hostile downdstream like "Eduard Bloch"
who mainly spreads personal insults against the authors of an OSS project and 
who is not interested in the OSS project itself. If there is such a hostile
downstream, you start looking at the "official regulations".

>   *  Displaying the copyright messages exactly the same way the
> original author does.  The GPL requires that you must preserve the
> contents of the copyrights and attribution and make them easily
> accessible to the user.

This is a result of the Copyright law. Bloch ignores the Copyright law by 
removing Copyright signs that I consider important. So far this is the first 
time I see that a downstream did remove Copyright signs.....

As you quoted http://cdrecord.berlios.de/private/linux-dist.html, you know that
the fork is full of bugs and dead since more than 2 years. Some of the bugs 
have been in the very outdated original software many others have been added by
the initiators of the fork. 

The original software however is under constant development, fixed a lot of 
bugs during the past 3 years and added many interesting new features. Why 
should people care about a fork that was not created in favor of the users but 
just as a specifc way to attack a popular OSS project?


> And back to something vaguely resembling the original topic:
> > As Linux requires root privileges for many SCSI commands, you need to
> > install cdreord suid root which is automatically done via "make install"
> > as root.
>
> If you discover that you need root privileges to burn a CD or DVD,
> that is a kernel bug and we would very much appreciate a bugreport.

You need root privileges on Linux in order to write CDs/DVDs as long as Linux 
exists. If you consider this to be a bug, then you seem to consider security a
bug. 

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       joerg.schilling@fokus.fraunhofer.de (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/private/ ftp://ftp.berlios.de/pub/schily
