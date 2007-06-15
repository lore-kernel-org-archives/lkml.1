Return-Path: <linux-kernel-owner+w=401wt.eu-S1757974AbXFOEUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974AbXFOEUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 00:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbXFOET7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 00:19:59 -0400
Received: from 24-75-174-210-st.chvlva.adelphia.net ([24.75.174.210]:39876
	"EHLO sanosuke.troilus.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750729AbXFOET6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 00:19:58 -0400
To: david@lang.hm
Cc: Alexandre Oliva <aoliva@redhat.com>, Florin Malita <fmalita@gmail.com>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <alpine.LFD.0.98.0706131957440.14121@woody.linux-foundation.org>
	<ortztbgi03.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706140305.50095.dhazelton@enter.net>
	<orr6oefpg4.fsf@oliva.athome.lsd.ic.unicamp.br>
	<46717C58.8050501@gmail.com>
	<ord4zye6iv.fsf@oliva.athome.lsd.ic.unicamp.br>
	<4671A528.5040300@gmail.com>
	<or1wge9pwr.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070614234507.GA3860@nostromo.devel.redhat.com>
	<or1wge6jii.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070615023944.GC3760@nostromo.devel.redhat.com>
	<ortzt951av.fsf@oliva.athome.lsd.ic.unicamp.br>
	<Pine.LNX.4.64.0706142047070.29630@asgard.lang.hm>
From: Michael Poole <mdpoole@troilus.org>
Date: Fri, 15 Jun 2007 00:19:56 -0400
In-Reply-To: <Pine.LNX.4.64.0706142047070.29630@asgard.lang.hm> (david@lang.hm's message of "Thu\, 14 Jun 2007 20\:50\:09 -0700 \(PDT\)")
Message-ID: <87zm31zw5v.fsf@graviton.dyn.troilus.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm writes:

> On Fri, 15 Jun 2007, Alexandre Oliva wrote:
>
>> Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
>>
>> On Jun 14, 2007, Bill Nottingham <notting@redhat.com> wrote:
>>
>>> OK. Let's take this to the simple and logical conclusion. A signed
>>> filesystem image containing both GPL and non-GPL code. From your
>>> point A, this is a derived work.
>>
>> I claim the signature is derived from the GPLed bits, yes.  Whether
>> that's a derived work, in the legal sense, I'm not qualified to say.
>
> it's also derived from the non-GPLed bits as well.
>
> so if it were a derived work in a legal sense (nessasary for your
> argument to have any legal meaning) then it's now illegal to make and
> distribute a checksum of a CD that contains software with incompatible
> licenses.

It is not necessary for the end item to be a derived work in order for
the GPL to apply.  A literal copy is not a derived work; a translation
is not a derived work; an executable version of a program is not a
derived work of its source code; and so forth.

What is necessary is that the "work based on the [GPLed] Program" be
more than a mere aggregation of the GPLed component(s) with non-GPLed
components.  The fact that part of the work-as-a-whole is a descriptor
of the GPLed part does not mean all descriptions the GPLed part are
governed by the GPL.  The critical factor is that the GPLed part will
not function properly without the DRM signature.

Michael Poole
