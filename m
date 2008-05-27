Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbYE0Pfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbYE0Pfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756935AbYE0PfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:35:15 -0400
Received: from www.tglx.de ([62.245.132.106]:54823 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865AbYE0PfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:35:13 -0400
Date: Tue, 27 May 2008 17:34:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: set_ftrace_notrace feature
In-Reply-To: <Pine.LNX.4.58.0805221145040.14724@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.1.10.0805271734290.3295@apollo.tec.linutronix.de>
References: <Pine.LNX.4.58.0805221145040.14724@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008, Steven Rostedt wrote:
> While debugging latencies in the RT kernel, I found that it would be nice
> to be able to filter away functions from the trace than just to filter
> on functions.

Applied, thanks

	 tglx
