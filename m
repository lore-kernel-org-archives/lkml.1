Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbXICOvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbXICOvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 10:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbXICOux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 10:50:53 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52039 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750856AbXICOuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 10:50:52 -0400
Date: Mon, 3 Sep 2007 16:50:53 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jonathan Gray <jsg@goblin.cx>, Reyk Floeter <reyk@openbsd.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [reyk@openbsd.org: Re: That whole "Linux stealing our code"
	thing]
Message-ID: <20070903145053.GX16016@stusta.de>
References: <20070903132542.GA902@mail.netspace.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070903132542.GA902@mail.netspace.net.au>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2007 at 11:25:42PM +1000, Jonathan Gray wrote:

> This is a lot more relevant than much of the ongoing
> discussion, so perhaps people could take a moment to read it over.
> 
> ----- Forwarded message from Reyk Floeter <reyk@openbsd.org> -----
> 
> From: Reyk Floeter <reyk@openbsd.org>
> Date: Mon, 3 Sep 2007 13:23:04 +0200
> To: misc@openbsd.org
> Subject: Re: That whole "Linux stealing our code" thing
> 
> Hi!
> 
> I just returned from vacation where I was offline for about two weeks.
> So I totally missed the incidence and all the surrounding discussion.
> I'm just digging through many many mails in my inbox from OpenBSD
> users and developers, Linux people, GNU/freesoftware people, misc *BSD
> people, and obviously from some trolls.
> 
> I don't want to restart the discussion but I just want to say and
> repeat a few words:
> 
> - I will not release or agree to release my code under either the GPL
> or any kind of a "dual"-license.

It's your code and it's your choice.

(But note that you contributed to then dual-licenced code in the
 OpenBSD CVS and kept this code dual-licenced. For this code your
 contributions might be assumed dual-licenced.)

> - The ISC-style license must remain including the copyright notice and
> even the warranty term.

Full agreement (for not dual-licenced code).

> - Thanks to the OpenBSD community and especially to Theo de Raadt for
> entering into it and for defending my rights as the author of the
> controversial code.

The email of Theo that was forwarded to linux-kernel [1] centered around 
Theo telling people that picking one licence for Sam's dual-licenced 
code would "break the law".

He would have better made the mistake in Jiri's patch visible (and 
therefore better defended your copyright) if he wouldn't have obscured 
it with these pointless accusations...

> - This is eating our time. Every few weeks I get a new discussion
> about licensing of the atheros driver etc. blah blah. Why can't they
> just accept the license as it is and focus on more important things?
> 
> I will talk to different people to get the latest state and to think
> about the next steps. I don't even know if the issue has been solved
> in the linux tree.
>...

To clarify this myth once again:

The patch that mistakenly changed BSD-only code to GPL has never ever 
been in the Linux tree.

> Thanks!
> reyk

cu
Adrian

[1] http://lkml.org/lkml/2007/9/1/102

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

