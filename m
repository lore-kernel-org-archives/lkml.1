Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbYKGO3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbYKGO3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 09:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbYKGO3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 09:29:35 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43198 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751437AbYKGO3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 09:29:34 -0500
Date: Fri, 7 Nov 2008 15:29:23 +0100
From: Pavel Machek <pavel@suse.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Cyril Hrubis <metan@ucw.cz>, Dmitry <dbaryshkov@gmail.com>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, Dirk@opfer-online.de,
       arminlitzel@web.de, pavel.urban@ct.cz, thommycheck@gmail.com
Subject: Re: 2.6.28-rc3-git1: spitz still won't boot
Message-ID: <20081107142923.GA1616@ucw.cz>
References: <20081031150601.GA1457@ucw.cz> <20081105142329.GA1724@ucw.cz> <bc64b4640811050713i4cfb1216x822274150e929e02@mail.gmail.com> <20081105173303.GC2038@elf.ucw.cz> <bc64b4640811051500m3ea38b31o54210ba0a12b01cf@mail.gmail.com> <20081106080416.GA1531@ucw.cz> <20081106191424.GA2273@atrey.karlin.mff.cuni.cz> <f17812d70811070523k59a57d49tac1ab1e5b78d1db4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d70811070523k59a57d49tac1ab1e5b78d1db4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-11-07 21:23:41, Eric Miao wrote:
> Well, IIRC spitz still needs the patch to change the vmlinux.ld.S.
> Did you guys ever try that?

I never heard about that patch, do you have it handy?

								Pavel

> On Fri, Nov 7, 2008 at 3:14 AM, Cyril Hrubis <metan@ucw.cz> wrote:
> > Hi,
> >> I do not have serial cable :-(,
> >
> > Okay I have one that works for sl5500, it needs external power on
> > sl-cxxx but it should be easy to fix.
> >
> > --
> > metan
> >

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
