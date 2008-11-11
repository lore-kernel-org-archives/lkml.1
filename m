Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbYKKD1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbYKKD1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 22:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbYKKD1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 22:27:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34903 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbYKKD1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 22:27:05 -0500
Date: Mon, 10 Nov 2008 22:27:01 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/2] ftrace updates for 2.6.28
In-Reply-To: <20081111025808.946638585@goodmis.org>
Message-ID: <alpine.DEB.1.10.0811102225470.12447@gandalf.stny.rr.com>
References: <20081111025808.946638585@goodmis.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 10 Nov 2008, Steven Rostedt wrote:
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: devel
> 
> 
> Steven Rostedt (2):
>       ftrace: disable tracing on resize
>       ring-buffer: prevent infinite looping on time stamping
> 

Ingo,

I just pushed these two patches to tip/devel after solving a conflict with 
the first one.

-- Steve

