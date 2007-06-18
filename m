Return-Path: <linux-kernel-owner+w=401wt.eu-S933517AbXFRX0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517AbXFRX0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 19:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764927AbXFRX0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 19:26:01 -0400
Received: from allen.werkleitz.de ([80.190.251.108]:40260 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762556AbXFRX0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 19:26:00 -0400
Date: Tue, 19 Jun 2007 01:25:49 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Daniel Hazelton <dhazelton@enter.net>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070618232549.GA22170@linuxtv.org>
References: <4673CA7C.5040207@t-online.de> <orlkejrg4o.fsf@oliva.athome.lsd.ic.unicamp.br> <20070616181902.GB21478@ftp.linux.org.uk> <or1wgbras9.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org> <orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org> <or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br> <20070618155016.GA31892@linuxtv.org> <or645lcdg7.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <or645lcdg7.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 87.162.100.158
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007, Alexandre Oliva wrote:
> 
> People talk a lot about TiVo here, but do they the faintest idea of
> how the conversations with TiVo are proceeding?  I thought so...

Oh, if you know something we don't, could you please fill us in?
And who was it who coined the "Tivoization" term, thus putting
TiVo into focus?

> So, you see, when people who oppose anti-tivoization measure the
> outcome for the community, they only look at the second possibility,
> assuming the vendor would immediately switch to some other software.
> As if that was easy for the vendor, and as if the software sucked so
> much that the vendor was just looking for a reason to switch.
> 
> But since the software is good, and moving to another software would
> be costly in various dimentions, the vendor has an incentive to stick
> with the software they have.

Hm, you only talk about people who already use free software,
but I tried to make you aware of the importance of
_promoting_ free software, i.e. winning new people and
companies for the free software idea.

I think the majority of embedded devices still run proprietary
RTOSes, and the majority of desktops still run Windows or Mac OS.
Don't you want to change that?

There are dozens of proprietary RTOSes, and along with
them dozens of proprietary toolchains, development environments
and trace/debug tools. Companies which worked in this field
for decades have invested money to create proprietary software
on top of them, and to train their staff to use them. Those companies
won't switch to Linux lightly. And it won't be a singular event,
but a process. They might start low, and maybe (hopefully) might
become well-playing free software contributors. But if you raise
the entry barrier too high, they won't get started at all.

OK, I don't have experience talking to big companies, but
I have talked to people working for smaller ones. They are
aware of the trend towards Linux, but are afraid that the
obligations of the GPL might be impractical for them.
Then they only have the choice to not use Linux, or to use
"creative workarounds".

It's true that what these companies do might have little direct benefit
for users buying their products, however the long term benefits of
getting the people in these companies exposed to free software ideas,
and in contact with the free software community, can only be
positive -- I think it's more important to spread the general
idea of free software into as many minds as possible than to
ensure that few follow the pure spirit of the FSF free software
definition in every detail.

> So you see, the picture of anti-tivozation is not as bleak as people
> try to frame it.  In fact, it's not bleak at all.  If one out of 10,
> maybe even 1 out of 100 vendors start respecting users' freedoms, when
> faced with anti-tivoization provisions, the community will already win
> big time, because each vendor is likely to have thousands of
> customers, some of which will use the freedoms to serve the goals of
> the community, in the very terms the community claims to care about.

Does this multiplicator also apply to new companies
which start using free software for their products?

I think the FSF strategy is suboptimal. The Linux
strategy works better for promoting free software.

In the end I want my devices to be open and hackable, too,
and I'm sure it will take an effort to convince companies
to open up. But I'm not convinced that the GPLv3 is a
step in the right direction towards that goal.


Johannes
