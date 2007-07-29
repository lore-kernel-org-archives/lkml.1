Return-Path: <linux-kernel-owner+w=401wt.eu-S934252AbXG2TSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934252AbXG2TSz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 15:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764041AbXG2TSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 15:18:48 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:2089 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763589AbXG2TSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 15:18:48 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: ck@vds.kolivas.org
Subject: Re: [ck] Re: Linus 2.6.23-rc1
Date: Sun, 29 Jul 2007 21:18:44 +0200
User-Agent: KMail/1.9.7
Cc: Satyam Sharma <satyam@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       lkml@metanurb.dk
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <200707292023.36555.Martin@lichtvoll.de> <alpine.LFD.0.999.0707300008230.30928@enigma.security.iitk.ac.in> (sfid-20070729_204823_774350_03921303)
In-Reply-To: <alpine.LFD.0.999.0707300008230.30928@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707292118.45484.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 29 Juli 2007 schrieb Satyam Sharma:
> Hi Martin,

Hi Satyam,

> > I believe that Ingo did not meant any bad at all. I think its just
> > the way he works, he likes to have code before saying anything. But
> > still I believe before I'd go about replacing someone else code
> > completely I would inform that developer beforehand, even if it then
> > turns out not to be feasible at all. No need to anounce it to the
> > world already, but I would have informed that developer.
>
> IMHO, what you're suggesting is: (1) not the way development normally
> happens in Linux, and, (2) not the way it /should/ happen, either. If
> there's something (subsystem, any code big or small) I think I can do
> better or have an idea for, I /should/ be able to just hack on it a bit
> and then send it out so everybody can comment on it. Why should I be
> forced to dance/discuss around with some other people, when the faster
> and more effective way would be just present the code/patch that I
> have in my mind as an RFC?

Hmmm, that email would have taken how long? 5 minutes maybe?

I just feel that I would have written it if I happen to know that another 
developer spent lots of time and effort into a subsystem I plan to 
rewrite. Its just human logic to me. Especially when I happen to know 
that the other developer may be new to the kernel development process as 
I know it from a internal view point.

The current kernel development process tries to pretend that there is no 
human involvement. Which is plain inaccurate: It is *all* human 
involvement, without a human not a single bit of kernel code would 
change.

I always believed that kernel developers are human beings and no robots. 
And thus the kernel development process IMHO should be designed with 
human developers in mind instead of robots which take no offence out of 
anything. Otherwise things like what happened here will happen again and 
again and again and talent is lost.

It is damn good to take technical merits into full account! But ignoring 
human aspects of development actually will hinder this. Cause then in the 
end its not about technical merits anymore that do the decision, but that 
human aspects that have been ignored and are floating around 
unconsiously.

Actually I do believe that this discussion already took more resources 
than actually writing a few more mails and doing a bit more communication 
here and there... IMHO the fact that this discussion exists already shows 
that something in the process of submitting kernel patches and supporting 
involvement in kernel development can be improved upon.

> See, Martin, in the end it's not about developer A vs developer B. It's
> about making the kernel the best out there -- that's what the users
> want, anyway. Yes, I fully understand (and have said so earlier myself)
> that there's a very important "social" aspect to development on such
> projects, but it's best if developer B understands that this is the way
> things do (and should) happen and adapt to it. [ It's not like I've
> been around for long, however, but the above is still my opinion, fwiw.
> ]

I am not saying that developer B (Con) does not have his share in how it 
all happened. As written before I got the impression that Con reacted 
hurt where from my point of view no offence was meant - and I told him 
that. But from what I know it would have been possible to actually deal 
with that quite a bit better than has happened. And it would not have 
taken much effort. Well actually I think it would have been quite easy to 
take the talent that has offered itself.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
