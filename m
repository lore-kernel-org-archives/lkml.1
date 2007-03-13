Return-Path: <linux-kernel-owner+w=401wt.eu-S932953AbXCMHx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbXCMHx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 03:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932899AbXCMHx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 03:53:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:54743 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932113AbXCMHx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 03:53:26 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19HmFwFmJ5HuKL40sRaRtcMl5GdU8jKV6nuL2wWf5
	4IST2rWPTCsjL2
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200703131653.39415.kernel@kolivas.org>
References: <200703111457.17624.kernel@kolivas.org>
	 <8cd998d50703121551u44ea3d85g2541503373f461f4@mail.gmail.com>
	 <1173762639.7944.45.camel@Homer.simpson.net>
	 <200703131653.39415.kernel@kolivas.org>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 08:53:18 +0100
Message-Id: <1173772398.10004.27.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 16:53 +1100, Con Kolivas wrote:
> On Tuesday 13 March 2007 16:10, Mike Galbraith wrote:

> > It's not "offensive" to me, it is a behavioral regression.  The
> > situation as we speak is that you can run cpu intensive tasks while
> > watching eye-candy.  With RSDL, you can't, you feel the non-interactive
> > load instantly.  Doesn't the fact that you're asking me to lower my
> > expectations tell you that I just might have a point?
> 
> Yet looking at the mainline scheduler code, nice 5 tasks are also supposed to 
> get 75% cpu compared to nice 0 tasks, however I cannot seem to get 75% cpu 
> with a fully cpu bound task in the presence of an interactive task.

(One more comment before I go.  You can then have the last word this
time, promise :)

Because the interactivity logic, which was put there to do precisely
this, is doing it's job?

>  To me 
> that means mainline is not living up to my expectations. What you're saying 
> is your expectations are based on a false cpu expectation from nice 5. You 
> can spin it both ways.

Talk about spin, you turn an example of the current scheduler working
properly into a negative attribute, and attempt to discredit me with it.

The floor is yours.  No reply will be forthcoming.

	-Mike

