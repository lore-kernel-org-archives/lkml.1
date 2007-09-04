Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbXIDAuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbXIDAuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 20:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbXIDAuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 20:50:00 -0400
Received: from keil-draco.com ([216.193.185.50]:50920 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbXIDAt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 20:49:59 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: davids@webmaster.com
Subject: Re: GPL weasels and the atheros stink
Date: Mon, 3 Sep 2007 20:49:44 -0400
User-Agent: KMail/1.9.6
Cc: espie@nerim.net, linux-kernel@vger.kernel.org
References: <MDEHLPKNGKAHNMBLJOLKOEGFGJAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKOEGFGJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709032049.45472.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 September 2007 20:23:37 David Schwartz wrote:
> > Wrong - I said "You can't complain about Person A doing X when
> > you let Person
> > B do X without complaint".
>
> Yes, I can. There is no inconsistency between acting in one case and
> failing to act in another. We need not act in every possible case where we
> could act to preserve our right to act in a particular case.

Sorry, I should have said that you cannot prosecute one person for doing 
something without prosecuting everyone that is doing it. Otherwise you have 
lost the case before it has started - no judge would allow such a one sided 
application of the law.

> > To whit: you can't complain that Jiri has made
> > changes to a dual-licensed "work" and only released his changes
> > under one of
> > the licenses on the work when somebody else - in this case Msr.
> > Floeter - has
> > done the same thing.
>
> First of all, I haven't complained about Jiri's changes. Second, I most
> certainly can. I can complain about one murder without complaining about
> every murder. There is no inconsistency whatsoever with acting in one case
> without having to act in every other conceivable case.

Sorry, this ties back to the original statement and the implied threats of 
legal action by Theo and backed up by almost every OpenBSD developer that has 
participated in this discussion.

It's a mis-statement of mine - see above. If you are going to prosecute one 
person for doing something, you have to prosecute everyone who does it.

> We can complain about or work to fight whatever injustices we like. There
> is no obligation to address every equal, or greater, injustice before
> working on the injustice of one's choice.

Yes, of course.

> > No, no confusion. You could care less about the code being dual-licensed.
>
> Your
>
> > choice of subjects 'GPL weasels' speaks volumes.
>
> *My* choice of subjects?! You seem to have me confused with someone else
> entirely.

Potentially - I am terrible with names and had assumed that you were the 
person who had forked the "Stealing Our Code" thread with the "GPL weasels" 
subject. If my assumption is faulty, then I apologize and ask your 
forgiveness for my false accusation.

> My sole points in this thread were to:
>
> 1) Correct some misunderstandings about how dual licenses actually work.

This was, IIRC, already well understood by most of the people on the Linux 
Kernel side of things. (Alan Cox has given several quite lucid statements 
showing that he, at least, does understand this)

> 2) Explain *why* a file cannot really remain dual-licensed if it's part of
> the Linux kernel distribution.

A file/files can have as many licenses on it as the developer wants, provided 
that at least one of them is the GPL(v2). That is because, for it to be 
legally distributed as part of the Linux Kernel it has to be done so under 
the auspices of the license on the Linux Kernel - the GPLv2. 

> While I generally prefer the BSD license to the GPL license and tend to be
> a pretty vocal GPL critic, I have said many times that almost any
> *consistent* license is better for a large project than different licenses,
> even if they're compatible, on different files.

I am critical of the GPL myself, as is Linus and a lot of people. (Linus 
himself has said, numerous times, that he is "no fan of the GPL, but it is 
the best that exists" (his words and opinion) - and I have heard similar 
sentiments from a lot of people.)

I am not a fan of the BSD license because I'd like to be able to incorporate 
any changes someone might make back into the original code. There is no 
requirement in the BSD license for someone to make their changes to my code 
available to me - so I am not a fan of it.

> > Doesn't matter if the BSD license or the GPL *PERMITS* it or not. The
> > fact remains that the person making a work available under *ANY* form of
>
> copyright
>
> > license has the right to revoke said grant of license to anyone. The GPL
> > codifies certain situations in which the person would not, personally,
>
> have
>
> > to revoke the license, but does not limit the original copyright holders
> > rights (in that regard) in any way.
>
> I'm not sure where you're getting this from, but it's not true. Linus
> cannot decide tomorrow that nobody can distribute the Linux kernel anymore.

In the US you have to explicitly waive rights for you to not have them (in 
regards to licenses). Although, considering what I have been informed of in 
regards to the law in Poland (and, seeing as how this has surprised a lot of 
people, likely a large number of other countries), to make sure those rights 
are "reserved" they should be explicitly spelled out in the text of the 
license.

And the truth is that Linus could do that - if he required contributors to do 
a copyright assignment (which would make him the holder of the sole copyright 
on the Linux Kernel). Since Linus is *NOT* the sole copyright holder on 
Linux, he cannot do this. He could, if he was so inclined, perform such a 
license revocation on code he holds copyright to, but this would not, IMHO, 
make any sort of lasting impact on the Linux Kernel itself. (It might force 
people to choose a different name as well, but...)

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
