Return-Path: <linux-kernel-owner+w=401wt.eu-S1765321AbXKOB2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765321AbXKOB2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 20:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbXKOB2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 20:28:13 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:34515 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465AbXKOB2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 20:28:12 -0500
Date: Wed, 14 Nov 2007 20:27:33 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tim Bird <tim.bird@am.sony.com>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: rt-preempt: problem compiling rt-preempt 2.6.23.1-rt11 on MIPS
In-Reply-To: <473B9EC1.4060908@am.sony.com>
Message-ID: <Pine.LNX.4.58.0711142026290.1557@gandalf.stny.rr.com>
References: <473B8F91.20704@am.sony.com> <alpine.LFD.0.9999.0711150143220.3265@localhost.localdomain>
 <Pine.LNX.4.58.0711142004080.1364@gandalf.stny.rr.com> <473B9EC1.4060908@am.sony.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 14 Nov 2007, Tim Bird wrote:

> > I'm just about to release 2.6.24-rc2-rt1 and I'm sure mips as well as
> > powrepc is badly broken.  Any help in getting these back up and working
> > would be greatly appreciated.
>
> I'll probably have some pretty basic questions.
> If you don't mind an RT newbie helping, I'll do what I can. :-)

We can use all the help we can get :-)

> BTW - I was just trying to cross-compile the IBM test programs
> (rt-test-0.6) today, and had some problems.  I didn't want to
> bug anyone until I took a closer look at it, but would it be
> best to report problems with that here on LKML, on
> linux-rt-users, or just directly to Darren Hart?


Things related to rt-test should go to Darren Hart and to linux-rt-users.
We only CC LKML on RT kernel issues.

-- Steve

