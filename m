Return-Path: <linux-kernel-owner+w=401wt.eu-S1764138AbZCYSqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764138AbZCYSqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755532AbZCYSqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:46:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54101 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760137AbZCYSqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:46:39 -0400
Date: Wed, 25 Mar 2009 14:46:37 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/5][RFC] tracing: move function profiler data out of
 function struct
In-Reply-To: <alpine.DEB.2.00.0903251439180.5675@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0903251443090.5675@gandalf.stny.rr.com>
References: <20090325035646.662994901@goodmis.org> <20090325040832.443420395@goodmis.org> <20090325100746.GI2341@elte.hu> <alpine.DEB.2.00.0903251142470.5675@gandalf.stny.rr.com> <20090325174446.GE14250@elte.hu> <alpine.DEB.2.00.0903251354020.5675@gandalf.stny.rr.com>
 <20090325180203.GB25518@elte.hu> <alpine.DEB.2.00.0903251411260.5675@gandalf.stny.rr.com> <20090325183513.GE28366@elte.hu> <alpine.DEB.2.00.0903251439180.5675@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Mar 2009, Steven Rostedt wrote:
> 
> that was me doing the struct from memory. Because I had already switched 
> out of that branch :-/

Note to self (and others)...

 git show <branch>:<file>

works for things like this.

-- Steve
