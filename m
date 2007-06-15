Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbXFOB0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbXFOB0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 21:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbXFOB0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 21:26:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56884 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbXFOB0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 21:26:43 -0400
Date: Fri, 15 Jun 2007 03:26:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alexandre Oliva <aoliva@redhat.com>, Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615012623.GA25189@elte.hu>
References: <200706132121.04532.dhazelton@enter.net> <orhcpbjnqj.fsf@oliva.athome.lsd.ic.unicamp.br> <200706132304.21984.dhazelton@enter.net> <20070614112329.3645c397@the-village.bc.nu> <20070614103846.GA7902@elte.hu> <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br> <20070614195517.GA4933@elte.hu> <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br> <20070614235004.GA14952@elte.hu> <20070615011012.6c09066e@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070615011012.6c09066e@the-village.bc.nu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > the GPLv2 license says no such thing, and you seem to be mighty 
> > confused about how software licenses work.
> 
> There is no such thing as a software licence. It is a copyright 
> licence.

a "software license" is a common shortcut for "copyright license for 
copies of software works". It's a commonly used phrase. In fact it is 
used by the FSF itself too:

   http://www.fsf.org/licensing/essays/free-sw.html

   "To decide whether a specific software license qualifies as a free 
                                 ^^^^^^^^^^^^^^^^
    software license, we judge it based on these criteria to determine 
    whether it fits their spirit as well as the precise words."

> > the GPL applies to software. It is a software license.
> 
> You can GPL a new graphical logo you painted on your toilet seat, you 
> can GPL hardware designs. It might not be a good licence for either 
> but it is a valid licence.

yeah - the GPL can be applied to most types of works recognized by 
copyright law.

> > the Tivo box is a piece of hardware.
> 
> A Tivo box is a collection of literary works protected by copyright, 
> designs protected by design patents and copyright, names and logos 
> protected by trademarks, functionalities protected by patents and many 
> more things. These are the things that restrict what I may do with it 
> and how I may treat it. The collection of bits of metal and sand 
> aren't really of relevance in terms of licencing.

If you are into technicalities then you fail to achieve that "rigorous 
base" by a wide margin. The Tivo box is not "a collection of literary 
works", it is a piece of matter, that also happens to contain fixated 
copies of literary (and other) works. The Tivo box is just one copy of 
those works - it is not "a collection of literary works". (Only if there 
was just a single Tivo box on the planet then could that box itself be 
meaningfully called a collection of works - a single and unique "master 
copy" of a work can be called the work itself.)

and that distinction, although fine, is very important. Look at GPLv2 
section 0:

" 0. This License applies to any program or other work which contains a 
  notice placed by the copyright holder saying it may be distributed 
  under the terms of this General Public License. "

the work is not the copy! The work is a more 'abstract' entity. The word 
"copyright" comes straight from that: the right to create specific 
copies of the work. And that's another reason why it's nonsensical to 
suggest that somehow the GPLv2 gives us the right to influence the 
hardware environment that the copy of the kernel got fixated into. We 
dont. ( unless that hardware environment too is a copy of a GPL-ed work 
or it is a copy of a work that is a modification of or derives from a 
GPL-ed work - but in the Tivo case it isnt. It's a collection of copies 
of works and derivation does not "jump" from the harddisk to the 
hardware. )

More down the technicalities road: the Tivo box also contains many items 
that are not copies of works protected by copyright: common types of 
screws that are not original forms of expression that are creative 
enough enough to gain copyright protection. Or numbers painted on 
various places. Or computer-originated random output. Copies of works 
that have entered the public domain and thus are not under the scope of 
copyright protection.

Neither is the Tivo box "collection of functionalities protected by 
patents", if then it is an embodiment of a method and apparatus, which 
invention is under patent protection (there are other types of patents 
as well), or which invention might not be under patent protection but 
have a patent application pending. (which might or might not issue at 
the end of the patent application process.)

> > a disk is put into it with software copied to it already: a bootloader, 
> > a Linux kernel plus a handful of applications. The free software bits 
> > are available for download.
> 
> Except the keys - which may nor may not be required depending upon how a
> court (not a mailing list) interprets the phrases
> 
> "The source code for a work means the preferred form of the work for
> making modifications to it"

i think it is clear what is intended with this section: that for example 
using automatic tools to strip out comments and obfuscating the source 
code does not fly, because what matters is the _form of the software_ 
the developer usually makes his modifications under. So this in essence 
defines the scope of the actual source code that must be made available 
so that it works on a general purpose computer, not the specific 
hardware environment under which the developer operates.

so i believe it is a ... fairly creative bending of the wording of this 
section to attempt to extend it to the hardware environment. You dont 
get my ssh keys either [*] that i use on my test-boxes, and those test 
boxes are very much part of the preferred way for me to produce kernel 
patches. But you get my kernel patches for sure! [ that is, if they dont 
crash the testboxes :-) ] Am i violating the GPLv2?

> and
> 
> "For an executable work, complete source code means all the source 
> code for all modules it contains, plus any associated interface 
> definition files, plus the scripts used to control compilation and 
> installation of the executable."

i think it is pretty clear what this section intends: not allowing 
people to become cute by stripping out of makefiles from the source 
tarball. If someone else tries to run that software on a general purpose 
computer (which has enough physical resources for that purpose) it 
should be possible.

But to read this to require a toaster that a piece of free software came 
installed on to be modifiable by the licensee who choses to excercise 
his rights under the GPL, in the same way as the original developer was 
able to modify that toaster is ... quite creative too i think, and leads 
to many absurd results.

> If you ask the legal profession about this seriously the answer you 
> get is bluntly "There is no caselaw I am aware of", which means that 
> nobody knows. Obviously Tivo and their legal counsel have formed an 
> opinion and have based their actions upon that opinion.

i guess i'll take Linus' word that the FSF's own lawyers agreed that the 
distribution of the Tivo box does not break the GPLv2. (although the 
cynic in me might say that this could be a self-serving position on 
their behalf done for tactical reasons, to increase the perceived 
'justification' for the GPLv3.)

	Ingo

[*] actually, you can get them if you want to, because i very much trust 
    you :-)
