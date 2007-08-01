Return-Path: <linux-kernel-owner+w=401wt.eu-S1760807AbXHAH0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760807AbXHAH0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 03:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756284AbXHAH0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 03:26:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:37397 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751742AbXHAH0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 03:26:40 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/7Imo/5eP7Po9BxeskW4NZI5sVlzW1l2xibLfaVL
	SeKmXheDprs/QU
Subject: Re: CFS review
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070801071230.GA16375@elte.hu>
References: <p734pkbyuu4.fsf@bingen.suse.de>
	 <20070711174252.GA16793@elte.hu>
	 <20070711211638.GE18767@one.firstfloor.org>
	 <20070711214649.GK14435@v2.random>
	 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0707130415520.1818@scrub.home>
	 <1184302024.6709.11.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0707131728070.1817@scrub.home>
	 <1184389456.6632.13.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0708010439050.1817@scrub.home>
	 <20070801071230.GA16375@elte.hu>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 09:26:35 +0200
Message-Id: <1185953195.6388.21.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-01 at 09:12 +0200, Ingo Molnar wrote:
> Roman,
> 
> Thanks for the testing and the feedback, it's much appreciated! :-) On
> what platform did you do your tests, and what .config did you use (and
> could you please send me your .config)?
> 
> Please also send me the output of this script:
> 
>   http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh
> 
> (if the output is too large send it to me privately, or bzip2 -9 it.)
> 
> Could you also please send the source code for the "l.c" and "lt.c" apps
> you used for your testing so i can have a look. Thanks!

I haven't been able to reproduce this with any combination of features,
and massive_intr tweaked to his work/sleep cycle.  I notice he's
collecting stats though, and they look funky.  Recompiling.

	-Mike

