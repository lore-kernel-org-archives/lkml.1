Return-Path: <linux-kernel-owner+w=401wt.eu-S1757157AbYGQHRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbYGQHRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbYGQHRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:17:06 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42691 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbYGQHRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:17:04 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5340"; a="4618066"
Message-ID: <487EF1E9.2040101@qualcomm.com>
Date: Thu, 17 Jul 2008 00:16:57 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: a.p.zijlstra@chello.nl, mingo@elte.hu, dmitry.adamushko@gmail.com,
       torvalds@linux-foundation.org, pj@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpu hotplug, sched: Introduce cpu_active_map	and	redosched
 domain managment (take 2)
References: <1216122229-4865-1-git-send-email-maxk@qualcomm.com> <487DAD86.BA47.005A.0@novell.com> <487E6BD7.3020006@qualcomm.com> <487E7B6C.BA47.005A.0@novell.com>
In-Reply-To: <487E7B6C.BA47.005A.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Gregory Haskins wrote:
> Well, admittedly I am not entirely clear on what problem is being solved as
> I was not part of the original thread with Linus.  My impression of what you
> were trying to solve was to eliminate the need to rebuild the domains for a
> hotplug event (which I think is a good problem to solve), thus eliminating
> some complexity and (iiuc) races there.
> 
> However, based on what you just said, I am not sure I've got that entirely
> right anymore.  Can you clarify the intent (or point me at the original thread)
> so we are on the same page?
Here is the link to the original thread
	http://lkml.org/lkml/2008/7/11/328
And here is where Linus explained the idea
	http://lkml.org/lkml/2008/7/12/137

I'll reply to the rest of your email tomorrow (can't keep my yes open any
longer :)).

Max
