Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbXFMXtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbXFMXtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 19:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756477AbXFMXto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 19:49:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865AbXFMXtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 19:49:43 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<466BCBBC.90305@netone.net.tr>
	<Pine.LNX.4.64.0706100301520.6675@asgard.lang.hm>
	<f24d23310706100355j3af7e12fq2e0e345402e48ca2@mail.gmail.com>
	<20070610160531.GA12179@kroah.com>
	<f24d23310706121107y2ef218a4wc1c8f9a52fc9bdd7@mail.gmail.com>
	<20070612184110.GB7980@kroah.com>
	<orir9smp3u.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706131223051.14121@woody.linux-foundation.org>
	<or7iq7mx7f.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070613211432.GH10008@csclub.uwaterloo.ca>
	<orodjjlbu1.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706131549000.14121@woody.linux-foundation.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Wed, 13 Jun 2007 20:49:23 -0300
In-Reply-To: <alpine.LFD.0.98.0706131549000.14121@woody.linux-foundation.org> (Linus Torvalds's message of "Wed\, 13 Jun 2007 16\:02\:09 -0700 \(PDT\)")
Message-ID: <or8xanl8jg.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 13, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 13 Jun 2007, Alexandre Oliva wrote:
>> 
>> [...] Our General Public Licenses are designed to make sure that you have
>> the freedom to distribute copies of free software (and charge for
>> this service if you wish), that you receive source code or can get
>> it if you want it, that you can change the software or use pieces of
>> it in new free programs; and that you know you can do these things.
>> 
>> To protect your rights, we need to make restrictions that forbid
>> anyone to deny you these rights or to ask you to surrender the
>> rights.  These restrictions translate to certain responsibilities
>> for you if you distribute copies of the software, or if you modify
>> it.
>> 
>> [...] if you distribute copies of such a program, whether gratis or
>> for a fee, you must give the recipients all the rights that you have
>> 
>> 
>> Can anyone show me how any of the provisions of GPLv3 fails to meet
>> this spirit?

> What kind of logic is that? It sounds like "Can you prove that God doesn't 
> exist?"

By this reasoning, it sounds like you've been claiming that "God does
exist", even though you can't prove it.

It shouldn't be anywhere that difficult to show that the GPLv3 fails
to meet the spirit of the GPLs.  You just have to show a single
counter-example.  Since there are so many objections to the changes,
it shouldn't be that hard.  Can you at least try?

> The fact is, Tivo didn't take those rights away from you, yet the FSF says 
> that what Tivo did was "against the spirit". That's *bullshit*.

Oh, good, let's take this one.

  if you distribute copies of such a program, [...]
  you must give the recipients all the rights that you have

So, TiVo includes a copy of Linux in its DVR.  

TiVo retains the right to modify that copy of Linux as it sees fit.

It doesn't give the recipients the same right.

Oops.

Sounds like a violation of the spirit to me.

Sounds like plugging this hole would retain the same spirit.

> In other words, GPLv3 restricts rights that do not need to be restricted, 

That's correct.  They don't need to be restricted.  The whole idea of
copyleft, implemented through the GPL, is not based on needs, but
rather on the wish to defend the freedoms established in the preamble
from those who would rather not respect them.

Do you deny that TiVo prevents you (or at least a random customer)
from modifying the copy of Linux that they ship in their DVR?

Do you deny that they can still do it themselves?

> Think of it this way: what if the GPLv3 had an addition saying "You can 
> not use this software to make a weapon".

This would make GPLv3 a non-Free Software license.

But the GPLv3 last call draft doesn't say anything along these lines.

You can use the software as much as you like, even in DVRs, and even
to implement DRM in them, as long as you respect the users' freedoms
to change and share the software.  Per the GPLv3 (paraphrased), if it
is possible to install modified versions of the covered program in the
device, you must tell the recipient how to do it.  Otherwise, the
freedom to modify the program is being too severely limited.

And, in the particular case of TiVo, it's a case of distributing
incomplete source code, of refraining from including functional
portions of the source code.

> In other words, GPLv3 *restricts* peoples freedoms more than it
> protects them.

While you look at it from the point of view of TiVo, who wants to be
free to prohibit people from modifying the workings of the device it
sells while it can still modify it itself, and it does that in order
to prohibit people from removing locks that stop them from doing
things they're legally entitled to do, I see a lot more prohibitions
than freedoms in what TiVo does.  I don't understand why you'd stand
up for it.  Is it more important that a single company be allowed to
impose prohibitions on others in order for its business model to work,
than to maintain the spirit of hacking and sharing that enabled Free
Software and Linux to flourish?

Do you expect Linux would have flourished if computers had locks that
stopped people from modifying Linux in them?

> where I added the "that you can do so in place on your devices, even if 
> those devices weren't licensed under the GPL".

You're mistakenly focusing on the device.  As you say, the device is
not under the license.

What's under the license is the software in it.  And that license
spirit requires the distributor to pass on the right to modify the
software.

> I don't know if you've followed US politics very much over the last
> six years, but there's been a lot of "protecting our freedoms" going
> on. And it's been ugly. Maybe you could realize that sometimes
> "protecting your freedom" is *anything*but*!

Is this why you're overreacting?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
