Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbZBTRzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbZBTRzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbZBTRy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:54:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64906 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbZBTRy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:54:56 -0500
Date: Fri, 20 Feb 2009 12:54:55 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 5/5] ftrace, x86: do not depend on system state for kernel
 text info
In-Reply-To: <20090220173454.GK24538@elte.hu>
Message-ID: <alpine.DEB.2.00.0902201254180.13747@gandalf.stny.rr.com>
References: <20090220163846.709775139@goodmis.org> <20090220164046.528070886@goodmis.org> <20090220173454.GK24538@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 20 Feb 2009, Ingo Molnar wrote:
> 
> Since i suspect you'll rebase anyway, i'd suggest to squash this 
> patch into patch #2, with credit to Andrew added.

Yeah, there's enough things to fix to warrant a rebase.

Thanks,

-- Steve

