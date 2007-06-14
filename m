Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbXFNVGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbXFNVGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 17:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756619AbXFNVG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 17:06:28 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:48955 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756599AbXFNVG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 17:06:26 -0400
Date: Thu, 14 Jun 2007 17:06:25 -0400
To: Dave Neuer <mr.fred.smoothie@pobox.com>
Cc: Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070614210625.GL10008@csclub.uwaterloo.ca>
References: <20070610160531.GA12179@kroah.com> <f24d23310706121107y2ef218a4wc1c8f9a52fc9bdd7@mail.gmail.com> <20070612184110.GB7980@kroah.com> <orir9smp3u.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706131223051.14121@woody.linux-foundation.org> <or7iq7mx7f.fsf@oliva.athome.lsd.ic.unicamp.br> <20070613211432.GH10008@csclub.uwaterloo.ca> <orodjjlbu1.fsf@oliva.athome.lsd.ic.unicamp.br> <20070614175305.GI10008@csclub.uwaterloo.ca> <161717d50706141324y303f3d89n54447b7cb387979c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161717d50706141324y303f3d89n54447b7cb387979c@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 04:24:19PM -0400, Dave Neuer wrote:
> Oh, come on: you're not serious, right? Something indeed prevents me
> -- the fact that I'm not a hardware manufacturer, I don't have fabs,
> outsource vendors to provide me w/ designs, ASICs, etc. Nor to I have
> the money to pay one-off prices for various components if they're even
> available in batches that small.

Yes I am serious.  I wouldn't want to buy any such locked down hardware,
but that still doesn't mean that I don't think it fits within the spirit
of the GPLv2.

> This argument seems totally disingenuous to me. The GPLv<3 was written
> in a time when the majority of sotware to which the license was
> applied was written for general purpose computers. The "user" was the
> owner of the computer, and Freedom 0 was about letting that user RUN
> modified copies of the software.
> 
> Things have changed a lot; we're surrounded by embedded computers, and
> Freedom 0 seems to strongly imply I should have the right to run
> modified versions of the Free Software I own on the hardware I OWN. Or
> is the future of Open Source that you'll be able to hack on free
> software as long as you work for Intel, Red Hat, TiVO, Google or OSDL?
> Or own many-thousand-$$ fab printer?

I think it depends on the type of hardware.  Certainly I agree some
types of hardware really should not allow you to change the code on them
due to the potential risks from doing so.  Hence if a license starts to
get into the grey area that covers such things, it is getting onto some
thin ice that is probably should stay off.  You risk excluding things
you didn't intend to exclude while almost certainly still missing things
you would like to have excluded.  I agree that for many devices I could
buy, being able to change the code on it would be great, and that there
generally is no good reason to deny me from doing it, but I don't think
it is worth the risk to put such a requirement into the license, and I
certainly never read the GPLv2 to in any way imply such a thing.
Apparently from what I can see, Linus never read any such thing in it
either when he chose to use it.  In fact I think you have to already
have a very narrow preset view in order to read the GPLv2 in such as
way as to think it intended to prevent such things.

> Look, I totally respect Linus' and others' position that the license
> is an inappropriate way to enforce what they feel are hardware design
> decisions, but can we dispense w/ the silly argument that the intent
> of the GPL is fullfilled as long as the user is allowed to modify the
> software where modify means "imagine a world where they'd be able to
> run" it?

It seems many people really do feel that it is fulfilled.  They may
think it is a stupid hardware design and they may also chose not to buy
such hardware, but at the same time they can be perfectly willing to say
that as long as the modified sources are provided, that is good enough
since further development of the source can be done, never mind what you
can do with that particular locked down door stop the code was modified
to support.  Not everyone views the world through the eyes of RMS.

--
Len Sorensen
