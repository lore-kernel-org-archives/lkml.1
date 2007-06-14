Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005AbXFNTIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbXFNTIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXFNTIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:08:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbXFNTIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:08:31 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kevin Fox <Kevin.Fox@pnl.gov>, Daniel Hazelton <dhazelton@enter.net>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<alpine.LFD.0.98.0706131549000.14121@woody.linux-foundation.org>
	<or8xanl8jg.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706132042.02728.dhazelton@enter.net>
	<1181837191.21942.24.camel@zathras.emsl.pnl.gov>
	<alpine.LFD.0.98.0706140923250.14121@woody.linux-foundation.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 16:07:44 -0300
In-Reply-To: <alpine.LFD.0.98.0706140923250.14121@woody.linux-foundation.org> (Linus Torvalds's message of "Thu\, 14 Jun 2007 09\:32\:24 -0700 \(PDT\)")
Message-ID: <orsl8ucq2n.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 14 Jun 2007, Kevin Fox wrote:
>> 
>> The hardware isn't directly covered by the GPL, correct. But, if they
>> want to use the software on the hardware, they have to comply with the
>> GPL.

> Only with the GPLv3.

This is not true.  The terms of the GPLv2 that say you can't impose
further restrictions on the exercise of the freedoms apply to the
software under GPLv2 and GPLv3 just the same way.

> Do you like licenses that force the licensee to give money back?

> So why do you like licenses that force the licensee to give access to 
> hardware back?

I don't know where the 'back' in the second question amounts to, but
it definitely isn't about GPLv3.

In fact, the GPL isn't about giving anything back.  It's about passing
on.

So both requirements, as you phrased them, would be equally wrong.

So let's change the question to turn them into forms of passing on:

  Do you like licenses that force the licensee to pass money on?

  Do you like licenses that force the licensee to pass on access to
  hardware?

This is still bad.  This is still not what the GPLv3 is about.
There's no requirement to let the user go wild and do whatever she
likes on the hardware.

The only requirement is the one that was always there: to respect the
freedoms of the users of the software, i.e., let them modify and share
the software, not imposing any further restrictions, by whatever
means.

So the second question would be correctly phrased as 

  Do you like licenses that force the licensee to pass on the right to
  modify the software in the hardware containing it?

Or, reframing it:

  Do you like licenses that permit the licensee to deny others the
  right to modify the software in the hardware containing it?

> It's a form of "extra compensation" that the GPLv2 never had.

No, sir, it's still respect for the freedoms.  The same "in kind"
contribution as always.

> The GPLv2 talks about giving access to the *source* code.

It does.  But that's not all.  Even GPLv1 went further than that.

> Can people really not see the difference, and why I might think it's a 
> fundamental difference, and why I might choose to say that the GPLv3 is a 
> worse license?

Since someone brought liberal (Original BSD, Modified BSD, MIT, etc)
licenses into the picture, and you expressed dislike for them, let me
pick that up for a moment.

> The license doesn't encode my fundamental beliefs of "fairness".  I
> think the BSD license encourages a "everybody for himself"
> mentality, and doesn't encourage people to work together, and to
> merge.

And then you say what TiVO does is ok, saying:

> Oh, but you want to hack the hardware to accept it? That's a totally
> different issue. If so, buy a Neuros OSD box.

Sounds a lot like the very "everybody for himself" attitude you
dislike.

So can you please explain to me how enabling TiVO to deny others the
freedom that it received "in kind", failing to keep with the "in kind"
spirit of the GPL, encourage people to work together, and to merge?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
