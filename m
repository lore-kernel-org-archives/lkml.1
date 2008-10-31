Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbYJaQX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbYJaQX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 12:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYJaQXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 12:23:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60848 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbYJaQXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 12:23:18 -0400
Date: Fri, 31 Oct 2008 12:23:17 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] ftrace: update txt document
In-Reply-To: <alpine.DEB.1.10.0810311219470.22754@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0810311222200.22754@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810231921590.4182@gandalf.stny.rr.com> <20081026193339.91e0c644.randy.dunlap@oracle.com> <alpine.DEB.1.10.0810311102280.20404@gandalf.stny.rr.com> <alpine.DEB.1.10.0810311219470.22754@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008, Steven Rostedt wrote:
> Ingo,
> 
> Can you pull this and git it ready for Linus? Since it only modifies a 

s/git/get/

Wow, what a typo. It actually makes sense ;-)

-- Steve

> documentation text file, it is of very low risk. But it also reflects the 
> state of the current ftrace tracer that is in 2.6.28. Thus it would be 
> best to get it in for that release.
> 
> Thanks,
> 
> -- Steve
> 
> 
