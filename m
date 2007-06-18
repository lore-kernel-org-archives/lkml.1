Return-Path: <linux-kernel-owner+w=401wt.eu-S1759231AbXFRBQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231AbXFRBQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 21:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755545AbXFRBQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 21:16:28 -0400
Received: from keil-draco.com ([216.193.185.50]:50703 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbXFRBQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 21:16:28 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: mea culpa on the meaning of Tivoization (was: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3)
Date: Sun, 17 Jun 2007 21:15:19 -0400
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Robin Getz <rgetz@blackfin.uclinux.org>, Rob Landley <rob@landley.net>,
       Bron Gondwana <brong@fastmail.fm>, Al Viro <viro@ftp.linux.org.uk>
References: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br> <20070617222123.0412f740@the-village.bc.nu> <orabuyfa7i.fsf_-_@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <orabuyfa7i.fsf_-_@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706172115.20285.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 June 2007 19:11:13 Alexandre Oliva wrote:
> On Jun 17, 2007, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> > That accurately describes the FCC wireless rules.
> >>
> >> AFAIK the FCC mandates not permitting the user to tinker.  It doesn't
> >> mandate the vendor to retain this ability to itself.
> >
> > In practical terms it does since a recall/replacement in the event of
> > rule changes is a bit impractical
>
> Indeed.  But that's not a legal requirement, it's an economic reason.
>
> "But I need to make a profit" or "But I need to reduce costs" is no
> excluse to disrespect the GPL.
>
> >> Therefore, per the above, FCC doesn't mandate tivoization.
> >
> > I'm sure you can find a definition to sort your goals whatever.
>
> Are you per chance implying that I'm twisting the definition of
> tivoization?
>
>
> You know...  I now believe that would be correct.  I have indeed
> twisted the definition of tivoization, and I'm sorry about that.
> Which is not to say that I agree that the FCC or any other law
> mandates tivoization, or that tivozation is a good thing or that it is
> permitted by GPLv2.  Please read on.
>
>
> After long conversations with RMS about the section on poisoned apples
> and tivoization in my draft article about GPLv3 (Corresponding Sources
> is the name of the section in
> http://fsfla.org/svnwiki/blogs/lxo/draft/gplv3-snowwhite) I had come
> to the conclusion that Tivoization amounted to:
>
>   denying the user of the computer the freedom to run modified
>   versions of the Free Software in it, while retain this ability to
>   oneself.
>
> This understanding of mine had been strengthened by my understanding
> of the wording and the rationale of GPLv3dd3, the wording about
> technical restrictions in the rationales published along with
> GPLv2dd2, and the various speeches in which the term was presented.
>
> Nevertheless, I consulted with him and others highly involved in the
> development of GPLv3 about some of the discussions going on here, and
> got responses over the past few hours that surprised me.  A lot.
>
> So I've just went back to that discussion about my article, and to
> various other cases in which RMS, Eben Moglen and others presented
> Tivoization, the rationales, and so on, and I came to the conclusion
> that I had experienced a subtle but very significant misunderstanding.
>
> I'm now convinced that a more appropriate definition would be:
>
>   denying the user of the computer the freedom to run modified
>   versions of the Free Software in it, by not sharing information as
>   to how it could be accomplished.
>
>
> This difference is very significant, and even more so for this
> discusion, because it contradicts some of what I claimed before about
> forms to use GPLed software where regulations require the user to be
> unable to modify the software.
>
>
> Let me start with an example: I bought a wireless router some time
> ago, and it had a GNU+Linux distribution installed in it.  No source
> code or written offer for source code, though.

Just want to point out that, when I read this, my reaction was "But... That is 
a direct violation of the GPLv2. No specific reading of the license needed."

> Now, if I called the vendor next day and asked for the source code,
> and they responded "sorry, I can't give you that.  I threw it all
> away, such that I wouldn't be able to give it to you.", they would
> still be disrespecting my freedoms, as well as the license, right?

Yes, they would. They are distributing a modification - in the words of the 
GPLv2 "a work based on the work" - without complying with the terms of the 
license.

> You see where I'm going?  Now, if they gave me the source code, but I
> still couldn't install modified versions, because they introduced
> technical measures with the purpose of denying me this possibility,
> then the inability to modify the program wouldn't be caused by
> something like a physical impossibility (something like ROM), but
> rather by an active measure to trample my ability to adapt the program
> and run it for any purpose.
>
> So, if I called them to ask how to install and run modified versions
> of the GPLed programs, and they responded "sorry, I can't give you
> that.  I threw it all away, such that I wouldn't be able to give it to
> you.", they would still be disrespecting my freedoms, as well as the
> license.

Not even the GPLv3dd4 - because they don't have the information anymore 
either. If, however, they still retained the information - in any form - they 
would be violating the GPLv3dd4.

The GPLv2 doesn't make the actions described above - "how to install and 
run" - a license violation.

> The reasons as to why they'd want to disrespect the freedoms don't
> matter.  It could be "making a profit", "complying with the law",
> "abiding by contractual restrictions", anything.  Imposing
> restrictions to the exercise of the freedoms is not in line with the
> spirit of the GPL, as such restrictions render the Software non-Free.

Then anyone using GPLv3'd software to drive WiFi devices, radio (HAM radio) 
networks, etc - in the US, at least - isn't allowed to do such. US Law makes 
some provisions of the GPLv3 illegal to comply with. Thanks to section 6 of 
the GPLv3 that invalidates the rights granted under the license.

>
> The conclusion?  Throwing keys away, or using split-key techniques, as
> I have suggested as potential alternatives to ROM for compliance with
> GPLv3 are not meant to be permitted by GPLv3.  There might be
> practical advantages to compromising and permitting these techniques,
> but that would amount to endorsing disrespect for users' freedoms, and
> more, betraying those who licensed their works under GPLv1+ or v2+
> with an intent to not permit these practices.  I don't think FSF is
> willing to be part of this, and this is how it should be.

Umm... making things more strict will just do more damage. As it is there are 
restrictions on companies that make them unable to comply with the GPL. What 
the GPLv3 has done is take away options they might otherwise have had. If one 
of the goals of the FSF is to force proprietary software into a minority then 
its just done damage to that goal.


DRH

> As for those who didn't mean the GPL this way, they can always grant
> additional permissions, or simply refrain from enforcing the license
> in these cases.
>
>
> I apologize for my terrible misunderstanding, and for spreading it.
>
> Hopefully this message will reach everyone I have misled.
>
> I've tried to Cc: everyone who'd received copies of my mistaken claims
> directly from me.  If I left you out by accident, please holler ;-)



-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
