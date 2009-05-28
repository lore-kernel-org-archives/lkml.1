Return-Path: <linux-kernel-owner+w=401wt.eu-S1762377AbZE1Osn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762377AbZE1Osn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbZE1Osg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:48:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64905 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbZE1Osg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:48:36 -0400
Date: Thu, 28 May 2009 10:48:35 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: wuzhangjin@gmail.com, linux-mips@linux-mips.org,
       LKML <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nicholas Mc Guire <der.herr@hofr.at>, wuzj@lemote.com
Subject: Re: [PATCH] mips-specific ftrace support
In-Reply-To: <alpine.LFD.2.00.0905281644210.3397@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0905281048130.24399@gandalf.stny.rr.com>
References: <73465d64a9a6773936f5eab3735a69f651c13187.1243458732.git.wuzj@lemote.com> <alpine.DEB.2.00.0905280948410.27708@gandalf.stny.rr.com> <alpine.LFD.2.00.0905281644210.3397@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 28 May 2009, Thomas Gleixner wrote:
> > >  include/linux/clocksource.h    |    4 +-
> > >  kernel/sched_clock.c           |    2 +-
> > >  kernel/trace/ring_buffer.c     |    3 +-
> > >  kernel/trace/trace_clock.c     |    2 +-
> > >  scripts/Makefile.build         |    1 +
> > >  scripts/recordmcount.pl        |   31 +++-
> 
> The changes to these generic files need to be separate as well.

Acked

-- Steve

