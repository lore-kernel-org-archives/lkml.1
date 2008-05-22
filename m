Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbYEVOdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbYEVOdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 10:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYEVOdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 10:33:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39149 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbYEVOdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 10:33:22 -0400
Date: Thu, 22 May 2008 10:33:21 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, suresh.b.siddha@intel.com,
       aneesh.kumar@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com,
       vatsa@linux.vnet.ibm.com, David Bahi <DBahi@novell.com>
Subject: Re: [ANNOUNCE] sched: schedtop utility
In-Reply-To: <483545B4.BA47.005A.0@novell.com>
Message-ID: <Pine.LNX.4.58.0805221032250.14724@gandalf.stny.rr.com>
References: <483545B4.BA47.005A.0@novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 22 May 2008, Gregory Haskins wrote:

> Hi all scheduler developers,
>   I had an itch to scratch w.r.t. watching the stats in
> /proc/schedstats, and it appears that the perl scripts referenced in
> Documentation/scheduler/sched-stats.txt do not support v14 from HEAD so
> I whipped up a little utility I call "schedtop".

Greg,

Cool, I'll have to take a look when things get a little slower for me. But
when I get a chance, I'll make my comments then.

-- Steve

