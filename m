Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbYKCUQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbYKCUQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbYKCUQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:16:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46067 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbYKCUQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:16:16 -0500
Date: Mon, 3 Nov 2008 15:16:14 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ftrace: update txt document
In-Reply-To: <alpine.DEB.1.10.0811031514120.16323@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0811031515260.16323@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810231921590.4182@gandalf.stny.rr.com> <20081026193339.91e0c644.randy.dunlap@oracle.com> <alpine.DEB.1.10.0810311102280.20404@gandalf.stny.rr.com> <alpine.DEB.1.10.0811031514120.16323@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 3 Nov 2008, Steven Rostedt wrote:

> 
> Impact: Documentation update only
> 
> A lot of changes have gone into ftrace. This patch updates
> the ftrace.txt document.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Note, the only change with this patch from v2 is that I added an Impact 
line and the Acked-by in the change log.

-- Steve

