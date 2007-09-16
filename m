Return-Path: <linux-kernel-owner+w=401wt.eu-S1752372AbXIPIXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbXIPIXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 04:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbXIPIXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 04:23:13 -0400
Received: from smtpoutm.mac.com ([17.148.16.74]:55130 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbXIPIXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 04:23:10 -0400
In-Reply-To: <200709160052.45493.jcroberts@designtools.org>
References: <5C8C3794-C62A-4935-8267-81080CCF6867@dixongroup.net> <200709150333.20384.jcroberts@designtools.org> <1B000B52-707E-4592-88CD-64BD88C6C9B2@mac.com> <200709160052.45493.jcroberts@designtools.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <2D9F0E1E-0E7A-46A5-8251-209CCF458A5D@mac.com>
Cc: Jason Dixon <jason@dixongroup.net>, misc@openbsd.org,
       LKML Kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Wasting our Freedom
Date: Sun, 16 Sep 2007 04:23:02 -0400
To: "J.C. Roberts" <jcroberts@designtools.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to CC all those FSF people on this as I'm sure  
they're plenty busy with other things, have lots of people to dispel  
FUD for them, and certainly don't need the excess email in their  
inboxes.

On Sep 16, 2007, at 03:52:43, J.C. Roberts wrote:
> On Sunday 16 September 2007, Kyle Moffett wrote:
>> On Sep 15, 2007, at 06:33:18, J.C. Roberts wrote:
>>> Would Linus put up a fight if someone took his source tree and  
>>> relicensed the whole thing as GPLv3 without his permission? Yep,  
>>> you betcha he'd fight and he has already had to put up with a lot  
>>> of strong arm nonsense from the GPLv3/FSF zealots.
>>
>> OH COME FREAKING ON!!!!  Can you guys DROP it already?  There was  
>> NO VIOLATION because nobody actually changed the code!!!  The  
>> patch that Jiri submitted was a *MISTAKE* and was *NEVER* *MERGED*!!!
>
> You are wrong.

Well you seem to have CCed the linux kernel mailing list, so I am  
talking about the linux kernel sources, not stuff hosted on  
madwifi.org or other places as I have no knowledge or control over  
what those maintainers accept or do not accept.  If you aren't  
talking about the Linux kernel itself then you should get your  
flamewar off this list as nobody here cares.


> http://marc.info/?l=linux-wireless&m=118857712529898&w=2
> http://madwifi.org/browser/branches/ath5k

I see these very out-of-date URLs showing people making changes to  
some already-problematic licenses in various files in some other non- 
linux-kernel repository.  Please note that the Linux kernel does  
*NOT* contain an atheros driver right now!  Therefore this doesn't  
seem to be the patch posted to LKML I was talking about:

Original patch:
http://lkml.org/lkml/2007/8/28/157

Responses:
http://lkml.org/lkml/2007/8/28/304
http://lkml.org/lkml/2007/8/29/171
http://lkml.org/lkml/2007/8/29/69

The "madwifi" site is not a linux-kernel branch at *all*.  The stuff  
that gets imported there is totally under the control of the madwifi  
people and if you want to gripe about copyright *they* are the people  
you should be griping to.  It's like complaining to the OpenBSD  
developers about copyright issues in some code that NetBSD developers  
commit to their repository; it just plain doesn't make sense.

As Jeff Garzik said:
> A better place to look would be 'ath5k' branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless- 
> dev.git
>
> but nonethless, the fact remains that ath5k is STILL NOT UPSTREAM  
> and HAS NEVER BEEN UPSTREAM, as can be verified from
>
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> 	(official linux repo; nothing is official until it hits here)

On Sep 16, 2007, at 03:52:43, J.C. Roberts wrote:
> I suggest actually taking the time to get the facts before making  
> completely baseless statements. When you make obviously erroneous  
> statements, it leaves everyone to believe you are either hopelessly  
> misinformed, or a habitual liar. -Which is it?

For starters, I seem to have plenty of references to "the facts" as  
cited above.  You even deleted 3 major references from the email you  
were *replying* to!

Secondly, what the HELL is with you guys and the personal  
attacks?!?!?  You said I am "hopelessly misinformed, or a habitual  
liar"???  You very carefully snipped out the 3 examples I gave where  
people were describing how the Linux kernel did the right thing both  
legally and ethically so you could make those claims?  Seriously, if  
you really want to know what went on as far as the Linux Kernel and  
the LKML is concerned, please go read the endless LKML archives on  
this particular topic and stop bringing up this topic over and over  
again with a few thousand people who didn't do anything wrong and  
don't care about that code at all.

If you want to know what the real upstream sources contain they're  
all publicly available for purview at:
http://git.kernel.org/?p=linux/kernel/git/torvalds/ 
linux-2.6.git;a=summary

I'm really getting tired of these endless streams of emails which  
show up with a new thread every few days containing 95% insults and  
flamage and I'm going to completely ignore anything further related  
to atheros/licensing/etc since virtually all of the people sending  
emails to the LKML can't seem to have a reasonable conversation.  Plonk.

Cheers,
Kyle Moffett

