Return-Path: <linux-kernel-owner+w=401wt.eu-S1761557AbXFQXlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761557AbXFQXlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 19:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759171AbXFQXlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 19:41:08 -0400
Received: from mail.suse.de ([195.135.220.2]:33723 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973AbXFQXlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 19:41:07 -0400
Date: Mon, 18 Jun 2007 01:40:14 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Daniel Hazelton <dhazelton@enter.net>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070617234014.GA4542@v2.random>
References: <20070615101007.0cbfd078@the-village.bc.nu> <orir9p10xw.fsf@oliva.athome.lsd.ic.unicamp.br> <4673CA7C.5040207@t-online.de> <orlkejrg4o.fsf@oliva.athome.lsd.ic.unicamp.br> <20070616181902.GB21478@ftp.linux.org.uk> <or1wgbras9.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org> <orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org> <or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 04:46:44PM -0300, Alexandre Oliva wrote:
> My perception is that the first easily dominates the second, and so
> you are better off without tivoization.

Your perception is quite flawed.

I see where you come from, I know your intentions are absolutely
genuine, but there's not a chance that by changing the GPL in any way
you want, you can move the needle on companies whose only real long
term threat is so broad and fundamental as the very existence of the
Internet! Stay away from any DRM issue since that is not a licensing
problem, and is a problem that is up to the economy to solve, all we
have to do is to write good code and grow the userbase, those
discussions are a total waste of time, and infact they're in the
interest of the pro-DRM people. See apple removal of drm mandated by
market forces (sure not mandated by the threat of GPLv3 ;).

Then (besides tivo that as said at the top is not a problem at all
regardless if it's legal or not with gplv2) there's the myth of
trusted computing apocalypse that promises an unbreakable DRM and no
computer capable of running a modified linux anymore, which cannot
materialize. At every respectable linux user group there's somebody
giving that TC speech. The thing, if I'm wrong and it really happens,
it means something went so fundamentally wrong that the symptom will
be a totally minor problem compared to the real cause that triggered
it. If nothing else wait the scenario to remotely materialize before
declaring preventive war to something purely theoretical, and _then_
release a v4 addressing it.

If all conspiracy theories should be added to v3 as potential threat,
then I would recommend to as well add a clause that if you're an alien
that wants to use some GPLv3 code in your alien-technology-driven ship
built to destroy planet earth, you can't unless you provide us with a
copy of your ship open specifications showing how to upload our
improved GPLv3 software to it, so we have a chance to build one too to
defend ourself LOL. Doesn't that sound fair enough too? I mean just in
case ;)

Back to the tivoization issue, the crypto key is the least of the
problems, the major linux cellphone vendor ships binary only modules
and I wouldn't even know how to upgrade the kernel regardless of any
crypto signature and even ignoring the binary only modules. If selling
the locked embedded package allows new market segments to grow around
linux (even if that's not _yet_ an ideal hacker-hackable cellphone)
that's still a net-positive because it sends a message to the venture
capital that may exploit the fact they're closed to grow market share
(see openmoko, not a "perception" of mine).

Open source licenses shouldn't forbid usages, not even the blatantly
unethical ones, "evil" is not tangible (I guess everything would be
easier in life if it was).

Let's tackle on the only real _tangible_ problem of gplv2 known
todate, that they can address with a few liner fix to gplv2. They
should _only_ do that, and release quickly a strightforward v3 that
nobody could ever pretend to argue about (they should have done that
already, more than half an year passed already and most of the time at
least here has been spent on purely theoretical things). They still
can do the right thing. All this arguing, busybox forking, are all
signals that something is wrong, it should start to ring a
bell. Frankly I think we all love the FSF and the GPL and we want to
help to avoid mistakes (I know I do).

I'm totally in favor to __experiment__ with the DRM clause but do that
on a new license. Leave GPL as it has always been, it works just
great, fix the only single tangible issue known todate, the rest is
all about conspiracy theories and at definining evil. Perfect fairness
cannot be obtained in this world, no matter what license or system you
apply.

Those developers that have been so totally trustful and used "any
later version" deserve better treatment (they deserve a quick fix too)
and you should obey to the promise of only modification in detail
according to point 9 or the "any later version" will not be
enforceable because outlawing a single usage means going the opposite
route of "promoting the reuse of the software" (written in gplv2,
search for it).

This whole email is irrelevant with the fact tivo may or may not be
legal with gplv2 depending on different countries. The single attempt
of trying to reduce the gpl userbase with new restriction, doesn't
qualify as a modification in detail here. For the record, I said the
first time quite anonymously in my blog back in Oct 06.
