Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbZAMNEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbZAMNEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756252AbZAMNEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:04:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48486 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbZAMNEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:04:09 -0500
Date: Tue, 13 Jan 2009 08:04:05 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Shaohua Li <shaohua.li@intel.com>, ia64 <linux-ia64@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Sam Ravnborg <sam@ravnborg.org>,
       trivial@kernel.org, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 9/9] ftrace, trivial: fix typo "resgister" ->
 "register"
In-Reply-To: <20090113080352.GB23381@pengutronix.de>
Message-ID: <alpine.DEB.1.10.0901130802440.31098@gandalf.stny.rr.com>
References: <20090113061110.856268617@goodmis.org> <20090113061148.807298761@goodmis.org> <20090113080352.GB23381@pengutronix.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 13 Jan 2009, Uwe Kleine-K?nig wrote:

> On Tue, Jan 13, 2009 at 01:11:19AM -0500, Steven Rostedt wrote:
> > From: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
> > 
> > Signed-off-by: Uwe Kleine-K?nig <ukleinek@strlen.de>
> who ever will apply this patch, can you please take care that the '?' is
> substituted by '?' or if that is too hard, by 'oe'?

Ouch, that looks bad. I just used git am to apply it and ran it through a 
compile and boot up (never know when a comment change will break the build 
;-)

I did not look at how git checked it in.

Ingo, if you did not pull this, and since it is the last patch, I'll fix 
it in my tree.

-- Steve
