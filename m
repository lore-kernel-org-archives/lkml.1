Return-Path: <linux-kernel-owner+w=401wt.eu-S1760445AbYCGOQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760445AbYCGOQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 09:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbYCGOPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 09:15:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41952 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbYCGOPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 09:15:52 -0500
Date: Fri, 7 Mar 2008 09:15:49 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: mingo@elte.he, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] RESEND: fix cpus_allowed settings
In-Reply-To: <20080307120644.7031.14474.stgit@novell1.haskins.net>
Message-ID: <Pine.LNX.4.58.0803070915310.24538@gandalf.stny.rr.com>
References: <20080307120644.7031.14474.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 7 Mar 2008, Gregory Haskins wrote:

> Hi Ingo, Steve,
>   I sent this patch a few weeks ago along with the migration_disable
> series.  I think the controversy with the migration_disable feature
> may have resulted in this fix being overlooked.  This patch is against
> -rt, but the bug theoretically affects both -rt and sched-devel/mainline.
> I can also whip up a sched-devel based patch if you like, but I think it
> will apply trivially to both places.
>
> Please consider it for inclusion.

Thanks, I'll apply it to the -rt queue.

-- Steve

