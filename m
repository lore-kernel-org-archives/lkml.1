Return-Path: <linux-kernel-owner+w=401wt.eu-S1752963AbZIUQat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbZIUQat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 12:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbZIUQar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 12:30:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010AbZIUQaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 12:30:46 -0400
Date: Mon, 21 Sep 2009 09:29:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC] [GIT PULL] "Performance Counters" -> "Performance Events"
 rename
In-Reply-To: <20090921134111.GA25578@elte.hu>
Message-ID: <alpine.LFD.2.01.0909210928570.4950@localhost.localdomain>
References: <20090921134111.GA25578@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 21 Sep 2009, Ingo Molnar wrote:
> 
> Please consider pulling the following tree (which is relative to the 
> perfcounters-fixes-for-linus pull request i just sent) that renames 
> "performance counters" to "performance events":

Fine, pulled. But it conflicted with the tracers tree. I fixed it up, but 
somebody more well-versed in the code should double-check.

		Linus
