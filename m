Return-Path: <linux-kernel-owner+w=401wt.eu-S1758133AbZFCOMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133AbZFCOMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbZFCOMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:12:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61229 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbZFCOMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:12:48 -0400
Date: Wed, 3 Jun 2009 10:12:49 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: linux-kernel@vger.kernel.org
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 0/3] [GIT PULL] ring-buffer: fixes for discard
In-Reply-To: <20090603140308.805778104@goodmis.org>
Message-ID: <alpine.DEB.2.00.0906031010530.14994@gandalf.stny.rr.com>
References: <20090603140308.805778104@goodmis.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 3 Jun 2009, Steven Rostedt wrote:

> 
> Ingo,
> 
> Please pull the latest tip/tracing/ftrace-3 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace-3
> 
> 
> Steven Rostedt (2):
>       ring-buffer: try to discard unneeded timestamps
>       ring-buffer: discard timestamps that are at the start of the buffer
> 
> Tim Bird (1):
>       ring-buffer: fix bug in ring_buffer_discard_commit

Sorry for the spam, but my quilt mail is failing to send out the first 
patch due to a missing '>' in Tim's email in his Signed-off-by. I'll fix 
it, rebase and resend.

Again, sorry about the spam :-(

-- Steve

