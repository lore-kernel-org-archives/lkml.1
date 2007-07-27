Return-Path: <linux-kernel-owner+w=401wt.eu-S938202AbXG0WJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938202AbXG0WJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 18:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936101AbXG0WIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 18:08:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:54958 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S936174AbXG0WIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 18:08:50 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+zrhRWj22z9lMb6OPQ1eLmm79yccDy2arbwmtbMc
	/dFB0cb1YCwE/9
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge
	plans for 2.6.23]
From: Mike Galbraith <efault@gmx.de>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Frank Kingswood <frank@kingswood-consulting.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ray Lee <ray-lk@madrabbit.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       ck list <ck@vds.kolivas.org>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <200707271345.55187.dhazelton@enter.net>
References: <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
	 <20070727030040.0ea97ff7.akpm@linux-foundation.org>
	 <1185531918.8799.17.camel@Homer.simpson.net>
	 <200707271345.55187.dhazelton@enter.net>
Content-Type: text/plain
Date: Sat, 28 Jul 2007 00:08:44 +0200
Message-Id: <1185574124.6342.31.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-27 at 13:45 -0400, Daniel Hazelton wrote:
> On Friday 27 July 2007 06:25:18 Mike Galbraith wrote:
> > On Fri, 2007-07-27 at 03:00 -0700, Andrew Morton wrote:

> > > So hrm.  Are we sure that updatedb is the problem?  There are quite a few
> > > heavyweight things which happen in the wee small hours.
> >
> > The balance in _my_ world seems just fine.  I don't let any of those
> > system maintenance things run while I'm using the system, and it doesn't
> > bother me if my working set has to be reconstructed after heavy-weight
> > maintenance things are allowed to run.  I'm not seeing anything I
> > wouldn't expect to see when running a job the size of updatedb.
> >
> > 	-Mike
> 
> Do you realize you've totally missed the point?

Did you notice that I didn't make one disparaging remark about the patch
or the concept behind it?   Did you notice that I took _my time_  to
test, to actually look at  the problem?  No, you're too busy running
your mouth to appreciate the efforts of others.
 
<snips load of useless spleen venting>

Do yourself a favor, go dig into the VM source.  Read it, understand it
(not terribly easy), _then_ come back and preach to me.

Have a nice day.

	-Mike

