Return-Path: <linux-kernel-owner+w=401wt.eu-S1751555AbXCPEJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbXCPEJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 00:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbXCPEJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 00:09:24 -0400
Received: from pqueueb.post.tele.dk ([193.162.153.10]:59434 "EHLO
	pqueueb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbXCPEJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 00:09:23 -0400
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
	Take 2
From: Kasper Sandberg <lkml@metanurb.dk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>
In-Reply-To: <20070314050819.536207642@goodmis.org>
References: <20070314050819.536207642@goodmis.org>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 05:07:52 +0100
Message-Id: <1174018072.20200.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-14 at 01:08 -0400, Steven Rostedt wrote:
> [Hopefully fixed email client to make it to the list this time]
> [This series has changed by using git-diff -M]
<snip>
> Seems appropriate, but I really don't care what it's called.  One thing about
> this name, is that typing arch/x86<Tab> doesn't tab complete x86_64 anymore.
> But if you can think of something better, I'd be happy to apply it.
> 
sorry for being so late, but about what it could be called, well, what
about common_x86 or common/x86 or something?

<snip>
> 
> -- Steve
> 
> PS. Sorry for the spam. I need to figure out how to tame quilt mail!
> 
> 
> --
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

