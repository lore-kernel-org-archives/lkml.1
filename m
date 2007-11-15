Return-Path: <linux-kernel-owner+w=401wt.eu-S1763857AbXKOBT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763857AbXKOBT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 20:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbXKOBTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 20:19:18 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:36047 "EHLO
	outbound7-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754776AbXKOBTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 20:19:17 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <473B9EC1.4060908@am.sony.com>
Date: Wed, 14 Nov 2007 17:20:01 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: rt-preempt: problem compiling rt-preempt 2.6.23.1-rt11 on MIPS
References: <473B8F91.20704@am.sony.com> <alpine.LFD.0.9999.0711150143220.3265@localhost.localdomain> <Pine.LNX.4.58.0711142004080.1364@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0711142004080.1364@gandalf.stny.rr.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Nov 2007 01:18:54.0410 (UTC) FILETIME=[7CFA22A0:01C82725]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Looks like that may be just an artifact from older days.
> 
> I'll do some more tests, and it it truely is, I'll go and remove the added
> headers.

Thanks.

> I'm just about to release 2.6.24-rc2-rt1 and I'm sure mips as well as
> powrepc is badly broken.  Any help in getting these back up and working
> would be greatly appreciated.

I'll probably have some pretty basic questions.
If you don't mind an RT newbie helping, I'll do what I can. :-)

 -- Tim

BTW - I was just trying to cross-compile the IBM test programs
(rt-test-0.6) today, and had some problems.  I didn't want to
bug anyone until I took a closer look at it, but would it be
best to report problems with that here on LKML, on
linux-rt-users, or just directly to Darren Hart?
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

