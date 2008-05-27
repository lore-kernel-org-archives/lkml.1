Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbYE0Pg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbYE0Pg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758556AbYE0Pft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:35:49 -0400
Received: from www.tglx.de ([62.245.132.106]:54877 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758547AbYE0Pfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:35:48 -0400
Date: Tue, 27 May 2008 17:35:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: fix up cmdline recording
In-Reply-To: <Pine.LNX.4.58.0805221147300.14724@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.1.10.0805271735000.3295@apollo.tec.linutronix.de>
References: <Pine.LNX.4.58.0805221147300.14724@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008, Steven Rostedt wrote:
> The new work with converting the trace hooks over to markers broke the
> command line recording of ftrace. This patch fixes it again.

Applied, thanks

	 tglx
