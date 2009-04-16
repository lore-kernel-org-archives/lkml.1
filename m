Return-Path: <linux-kernel-owner+w=401wt.eu-S1758730AbZDPQWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730AbZDPQWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758324AbZDPQWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:22:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48041 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758669AbZDPQWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:22:18 -0400
Date: Thu, 16 Apr 2009 12:22:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip
In-Reply-To: <20090416161207.GB14658@elte.hu>
Message-ID: <alpine.DEB.2.00.0904161221360.20429@gandalf.stny.rr.com>
References: <20090416021830.556671772@goodmis.org> <20090416095135.GA18620@elte.hu> <alpine.DEB.2.00.0904160950340.5262@gandalf.stny.rr.com> <20090416161207.GB14658@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 16 Apr 2009, Ingo Molnar wrote:

> 
> -tip testing found a boot failure [boot hang]:
> 
> calling  event_trace_self_tests+0x0/0x3ec @ 1
> Running tests on trace events:
> Testing event kfree_skb: <7>bus: 'serio': driver_probe_device: 
> matched device serio1 wid
> bus: 'serio': really_probe: probing driver atkbd with device serio1
> 
> with the attached config.

Thanks,

I'll try it out. Looks like this tester can catch bad things well :-/

-- Steve

