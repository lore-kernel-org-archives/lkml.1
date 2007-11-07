Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbXKGPmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbXKGPmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 10:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbXKGPm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 10:42:27 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:37892 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbXKGPm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 10:42:26 -0500
Date: Wed, 7 Nov 2007 10:41:53 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: 2.6.23.1-rt9 (and others)
In-Reply-To: <1194413959.8827.66.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.58.0711071040210.8572@gandalf.stny.rr.com>
References: <1194413959.8827.66.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Virus-Scan-Result: Scanner unlicensed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 7 Nov 2007, Steven Rostedt wrote:

> This is a special announcement for the latest -rt patches. This is
> actually announcing more than one tree (pay close attention to the
> differences between -rt7, -rt8 and -rt9).
>

[...]

>   2.6.23.1-rt9
>
>    - RT balancing by CPU priorities (Gregory Haskins)

-rt9 has been found to break UP compilation, so -rt10 has been released
with the fix.

>
>
> Now benchmarks against 2.6.23.1-rt7 -rt8 and -rt9 would be greatly
> appreciated.  These three are all present in

So please compare -rt7, -rt8 and -rt10.

-- Steve

>
>   http://www.kernel.org/pub/linux/kernel/projects/rt/
>
