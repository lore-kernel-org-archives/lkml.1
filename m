Return-Path: <linux-kernel-owner+w=401wt.eu-S932223AbZKBSaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223AbZKBSaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 13:30:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932205AbZKBSaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 13:30:15 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57825 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbZKBSaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:30:14 -0500
Date: Mon, 2 Nov 2009 13:29:53 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Luis Correia <luis.f.correia@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Johannes Berg <johannes@sipsolutions.net>,
       Jarek Poplawski <jarkao2@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2009-10-28
Message-ID: <20091102182953.GH14046@tuxdriver.com>
References: <1256886023.3555.5.camel@johannes.local> <20091030110616.GB6150@ff.dom.local> <20091030150223.GA2586@tuxdriver.com> <20091102091038.GA9044@elte.hu> <1257153807.3555.173.camel@johannes.local> <20091102100702.GA16963@elte.hu> <20091102170114.GE14046@tuxdriver.com> <efe7343f0911020932l21a570c8u9478568329d38e2c@mail.gmail.com> <4AEF1894.2010809@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AEF1894.2010809@xenotime.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 09:36:20AM -0800, Randy Dunlap wrote:
> Luis Correia wrote:
> > [huge snip]
> > 
> > This is going to be my last reply to this thread (even if I get to be insulted).
> > 
> > I'm not a coder, I'm a tester and administrator for the rt2x00 project.
> > I'm not happy about the current state of the rt2x00 in-kernel drivers.
> > I tend to agree that more could be done.
> > 
> > Even though I'm not a coder, I could be hipotetically responsable for
> > the current situation. It is my job function to motivate people to
> > work on the rt2x00 in-kernel drivers, but apparently I've failed here.
> > It's not an atitude problem, as some have suggested, it's just life.
> > 
> > About Bartlomiej, there is only one more thing that I'll say:
> > 
> > I've searched on my GMail archives and the only patch Bart has
> > provided so far for the rt2x00 project is this:
> > 
> > [PATCH] MAINTAINERS: rt2x00 list is moderated
> > 
> > Which, while technically correct, adds nothing to the project.
> 
> whatever.  That patch still needs to be applied.

And, in fact, it has been...already in linux-2.6:

	commit b5654f5e7fc414a6e69b3647db2b043257c9e62e
	Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
	Date:   Mon Oct 26 16:49:50 2009 -0700

	MAINTAINERS: rt2x00 list is moderated

	Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
	Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
	Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Hth...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
