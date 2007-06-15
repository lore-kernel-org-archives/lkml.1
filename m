Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbXFOTrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbXFOTrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbXFOTrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:47:10 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50058 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbXFOTrJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:47:09 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: "Nicolas Mailhot" <nicolas.mailhot@laposte.net>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 15:46:52 -0400
User-Agent: KMail/1.9.6
Cc: "Jesper Juhl" <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org
References: <9a8748490706150353i452cf529oc5c0e8119f91e64e@mail.gmail.com> <52052.192.54.193.51.1181907121.squirrel@rousalka.dyndns.org>
In-Reply-To: <52052.192.54.193.51.1181907121.squirrel@rousalka.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706151546.52113.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 07:32:01 Nicolas Mailhot wrote:
> Le Ven 15 juin 2007 12:53, Jesper Juhl a écrit :
> > On 15/06/07, Nicolas Mailhot <nicolas.mailhot@laposte.net> wrote:
> >> >> > by your argument, the user has some "right to modify the
> >>
> >> software", on
> >>
> >> >> > that piece of hardware it bought which had free software on it,
> >>
> >> correct?
> >>
> >> >> Yes.  This means the hardware distributor who put the software in
> >> >> there must not place roadblocks that impede the user to get where
> >>
> >> she
> >>
> >> >> wants with the software, not that the vendor must offer the user
> >>
> >> a
> >>
> >> >> sport car to take her there.
> >> >
> >> >Okay. That means that if I ship Linux on a ROM chip I have to
> >>
> >> somehow
> >> make
> >>
> >> >it so that the person purchasing the chip can modify the copy of
> >>
> >> Linux
> >>
> >> >installed on the chip *if* I want to follow both the spirit and the
> >>
> >> letter
> >>
> >> >of the GPLv2.
> >>
> >> The key word there is "can"
> >>
> >> You don't have to send the buyer the hardware design, replace the
> >> ROM
> >> with a flash, use a rom socket that allows easy switching etc.
> >>
> >> But you can not add measures to your hardware specifically designed
> >> to
> >> stop the user from modifying the GPL software part. Especially if
> >> those measures are something like DRM that do not make the tinkering
> >> just technically hard, but legally forbidden.
> >>
> >> As long as the restrictions result from technical choices not
> >> targetted at forbidding changes you're ok.
> >
> > That's simply not true.
> >
> > As long as you get a copy of the source code for the software that's
> > running on the hardware it's OK. That's all the GPLv2 says.
>
> You'll note I was answering to a message about what the GPL intended,
> not the strict literal reading of the GPLv2 words.
>
> And what the GPL authors intended is obvious from the fact it all
> started with a printer driver and the need to change the software used
> to control this particular hardware (not some mythical other device
> without manufacturer restrictions

And it doesn't *MATTER* what they intended, or what they feel the "spirit" of 
the license is. The second they made it public and gave people the option of 
applying the GPL to their projects their intent lost all meaning - because 
the intent of all the people that decided to release their projects under the 
GPL also has to be taken into account.

Note that I am not arguing, and have never argued, that the FSF overstepped 
its bounds when they wrote the GPLv3. Instead I am arguing that they are 
taking their own interpretation od the GPLv2, the intent of one *small* group 
of users of the GPLv2 and saying "this isn't something it was supposed to 
allow, so we have to make it clear in this new version". 

And even then they aren't being really consistent. The fact is that RMS has 
stated he believes it isn't ethical to charge for software. I see *nothing* 
in that belief that is in conflict with TiVO. What *IS* wrong with TiVO is 
that it makes it impossible for anyone to *easily* change the system - that 
the TiVO corporation could do something with ease that other people can't.

DRH
http://www.faifzilla.org/ch06.html  ("the prospect of charging money for 
software [is] a crime against humanity")
http://www.faifzilla.org/ch01.html ("I already had an idea that software 
should be shared, but I wasn't sure how to think about that.")

PS: Note that Stallmans motivation was *SOURCE* *CODE* *ACCESS* - nothing 
else. His inability to get the source code to that printer was just the 
proverbial "straw that broke the camels back", *NOT* the prime motivation.

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
