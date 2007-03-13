Return-Path: <linux-kernel-owner+w=401wt.eu-S1753145AbXCMGaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbXCMGaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 02:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbXCMGaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 02:30:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:39006 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753145AbXCMGaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 02:30:12 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19se/wcrltsI4EFNQxdJknE99Pl5F8gREy6mOaSSS
	8imvB3nYU0BSrv
Subject: Re: [ck] Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 
	2.6.21-rc3-mm2
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: michael chang <thenewme91@gmail.com>, ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200703131716.31979.kernel@kolivas.org>
References: <200703111457.17624.kernel@kolivas.org>
	 <b14e81f00703121438q6cdaffd0vdb08e0386961f057@mail.gmail.com>
	 <1173766107.7944.76.camel@Homer.simpson.net>
	 <200703131716.31979.kernel@kolivas.org>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 07:30:09 +0100
Message-Id: <1173767409.10004.7.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 17:16 +1100, Con Kolivas wrote:
> On Tuesday 13 March 2007 17:08, Mike Galbraith wrote:
> > Virtual or physical cores has nothing to do with the interactivity
> > regression I noticed.  Two nice 0 tasks which combined used 50% of my
> > box can no longer share that box with two nice 5 tasks and receive the
> > 50% they need to perform.  That's it. From there, we wandered off into a
> > discussion on the relative merit and pitfalls of fairness.
> 
> And again, with X in its current implementation it is NOT like two nice 0 
> tasks at all; it is like one nice 0 task. This is being fixed in the X design 
> as we speak.

Shrug.  I don't live then, I live now.  I have expressed my concerns,
and will now switch from talk back to listen mode.

	-Mike

