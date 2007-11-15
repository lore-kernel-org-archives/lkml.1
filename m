Return-Path: <linux-kernel-owner+w=401wt.eu-S933282AbXKOWJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282AbXKOWJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762603AbXKOWJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:09:15 -0500
Received: from mx2.go2.pl ([193.17.41.42]:57935 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762053AbXKOWJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:09:14 -0500
Message-ID: <473CC3FE.5080509@o2.pl>
Date: Thu, 15 Nov 2007 23:11:10 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
User-Agent: Icedove 1.5.0.14pre (X11/20071020)
MIME-Version: 1.0
To: Jon Nelson <jnelson@jamponi.net>
CC: Michael Chan <mchan@broadcom.com>, netdev <netdev@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: tg3: strange errors and non-working-ness
References: <20071115094728.GB2366@ff.dom.local> <1195154603.6360.9.camel@dell>	 <cccedfc60711151117v70b285fbl79bbc92ced176d54@mail.gmail.com>	 <1195158200.6360.17.camel@dell> <cccedfc60711151221p322894f8i94c540fefb0e4827@mail.gmail.com>
In-Reply-To: <cccedfc60711151221p322894f8i94c540fefb0e4827@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Nelson wrote, On 11/15/2007 09:21 PM:
...

> NOTE: to avoid list noise, I can make a bug out of this on
> bugzilla.kernel.org and we can proceed from there if that is
> preferred.

Why avoid list noise? These lists are made just for this. But, since
this case needs a lot of space for your configs, maybe a lot of time,
and maybe a bit more people to have a look at this as well, bugzilla
could be very useful.

Of course, like Michael said, it would be better if you could do
at least short test with a version as new as possible.

Regards,
Jarek P.

PS: I've forgot to mention: lspci -vv, cat /proc/interrupts
and maybe the same for these other, working gig-e cards.
