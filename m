Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbZINCfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbZINCfN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 22:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbZINCfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 22:35:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40606 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbZINCfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 22:35:11 -0400
Subject: Re: [PATCH v4] ftrace: document basic ftracer/ftracer graph needs
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0909131854l511fbcb8ve8b66a5f3b3d2113@mail.gmail.com>
References: <20090614012457.GD5986@nowhere>
	 <1244948719-22216-1-git-send-email-vapier@gentoo.org>
	 <8bd0f97a0906230530j1cc0efc8i85e9234b2fa0417a@mail.gmail.com>
	 <20090623134319.GC3026@elte.hu>
	 <8bd0f97a0909131854l511fbcb8ve8b66a5f3b3d2113@mail.gmail.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Sun, 13 Sep 2009 22:35:12 -0400
Message-Id: <1252895712.20020.0.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-13 at 21:54 -0400, Mike Frysinger wrote:
> On Tue, Jun 23, 2009 at 09:43, Ingo Molnar wrote:
> > * Mike Frysinger wrote:
> >> On Sat, Jun 13, 2009 at 23:05, Mike Frysinger wrote:
> >> > While implementing ftracer and ftracer graph support, I found the exact
> >> > arch implementation details to be a bit lacking (and my x86 foo ain't
> >> > great).  So after pounding out support for the Blackfin arch, start
> >> > documenting the requirements/details.
> >>
> >> Steven: were you going to pick this up ?  or should i forward to Andrew ?
> >
> > The .32 development window for the tracing tree starts in about a
> > week. We'll probably fast-track your documentation bits to mainline
> > - but until then we try to watch for regressions and make sure -rc1
> > is round.
> 
> unless i missed something, this wasnt picked up

Ah, somehow this got put in my "done" pile. I'll review it tomorrow and
if there's no issue with it, I'll pull it in and pass it along.

Thanks,

-- Steve


