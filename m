Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbXFNC4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbXFNC4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 22:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbXFNC4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 22:56:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57310 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752176AbXFNC4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 22:56:16 -0400
Date: Wed, 13 Jun 2007 19:55:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexandre Oliva <aoliva@redhat.com>
cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, "david@lang.hm" <david@lang.hm>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <or8xanl8jg.fsf@oliva.athome.lsd.ic.unicamp.br>
Message-ID: <alpine.LFD.0.98.0706131930120.14121@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
 <466BCBBC.90305@netone.net.tr> <Pine.LNX.4.64.0706100301520.6675@asgard.lang.hm>
 <f24d23310706100355j3af7e12fq2e0e345402e48ca2@mail.gmail.com>
 <20070610160531.GA12179@kroah.com> <f24d23310706121107y2ef218a4wc1c8f9a52fc9bdd7@mail.gmail.com>
 <20070612184110.GB7980@kroah.com> <orir9smp3u.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706131223051.14121@woody.linux-foundation.org>
 <or7iq7mx7f.fsf@oliva.athome.lsd.ic.unicamp.br> <20070613211432.GH10008@csclub.uwaterloo.ca>
 <orodjjlbu1.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706131549000.14121@woody.linux-foundation.org>
 <or8xanl8jg.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Jun 2007, Alexandre Oliva wrote:
> 
> So, TiVo includes a copy of Linux in its DVR.  

Stop right there.

You seem to make the mistake to think that software is something physical.

> TiVo retains the right to modify that copy of Linux as it sees fit.

No. If you were logical (which you are not), you would admit that 
 (a) physical property is very different from intellectual property (the 
     FSF seems to admit that when it suits their needs, not otherwise)
 (b) They never modified "a copy" of Linux - they simply replaced it with
     "another copy" of Linux. The only thing that actually got *modified* 
     was their hardware!

The first copy didn't "morph" into a second copy. There was no "physical" 
software that was molded.  They do need to follow the GPLv2, since clearly 
they _do_ distribute Linux, but you have all the same rights as they do 
with regard to the *software*. 

The fact that they maintained some control of the *hardware* (and some 
software they wrote too) they designed is _their_ choice.

What Tivo did and do, is to distribute hardware that can *contain* a copy 
of Linux (or just about anything else, for that matter - again, there's 
a difference between physical and intellectual property).

And their hardware (and firmware) will run some integrity checks on 
*whatever* copies of software they have.  This is all totally outside 
Linux itself.

Btw, according to your _insane_ notion of "a copy" of software, you can 
never distribute GPL'd software on a CD-ROM, since you've taken away the 
right of people to modify that CD-ROM by burning and fixating it. So 
according to your (obvously incorrect) reading of the GPLv2, every time 
Red Hat sends anybody a CD-ROM, they have restricted peoples right to 
modify the software on that CD-ROM bymaking it write-only.

See? Your reading of the license doesn't _work_. Mine does. What I say is 
that when you distribute software, you don't distribute "a copy" of 
software, you distribute the _information_ about the software, so that 
others can take it and modify it. And notice? My reading of the license 
must be the correct one, since my reading actually makes sense, unlike 
yours.

And yes, when Tivo distributes Linux, they give everybody else all the 
same rights they have - with respect to Linux! No, not with respect to 
their hardware, but that's a totally different thing, and if you cannot 
wrap your mind around the difference between "the software that is on a 
CD" and the "piece of plastic that is the CD", and see that when you 
replace "CD" with any other medium, the equation doesn't change, I don't 
know what to say.

> It doesn't give the recipients the same right.
> 
> Oops.
> 
> Sounds like a violation of the spirit to me.

Only if you extend the license to the *hardware*. Oops. Which it never did 
before. 

In other words, you basically try to change the rules. The GPLv2 clearly 
states that it's about software, not hardware. All the language you quoted 
talks about software.

In other words, the only way to argue that I'm wrong is to try to twist 
the meanings of the words, and say that words only mean one specific thing 
that _you_ claim are their meaning.

And I'm saying you act like Humpty Dumpty when you do. You can argue that 
way all you like, but your argument is nonsensical. It's akin to the 
argument that "God is perfect. Perfect implies existence. Therefore God 
exists".

That kind of argument only works if you *define* the words to suit your 
argument. But it's a logical fallacy.

And I'm saying that the GPLv2 can mroe straightforwardly be read the way I 
read it - to talk about software, and to realize that software is not "a 
copy", it's a more abstract thing. You get Linux when you buy a Tivo (or 
preferably - don't buy it, since you don't like it), and that means that 
they have to give you access to and control over the SOFTWARE. But nowhere 
in the GPL (in the preamble or anywhere else) does it talk about giving 
you control over the HARDWARE, and the only way you can twist the GPLv2 to 
say that is by trying to re-define what the words mean.

And then you call *me* confused? After you yourself admitted that the FSF 
actually agrees with me, and that what Tivo did was not a license 
violation?

Trust me, I'm not the confused person here.

I'm perfectly fine with other people wanting to extend the license to 
cover the hardware, but I am *not* perfectly fine with people then trying 
to claim I'm confused just because I don't agree with them.

Face it: the GPLv3 is a _new_ license. Making funamentally _different_ and 
_new_ restrictions that do not exist in the GPLv2, and do not exist in the 
preamble. Any language attempts to make it appear otherwise are just 
sophistry.

And btw, just to make it clear: as far as I'm concerned, you can read the 
preamble and the word "freedom" and "rigths" _your_ way. I'm not objecting 
to that at all. If you read it so that you think it's wrong to distribute 
GPL'd software on a CD-ROM, that's really not my problem. You do whatever 
you want to, and think the license means whatever you want to.

What I'm objecting to is how you claim that anybody that doesn't follow 
your interpretation is "confused". When clearly even the FSF lawyers agree 
that my interpretation was _correct_, and I don't think your 
interpretation even makes sense!

			Linus
