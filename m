Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbYBSAXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbYBSAXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 19:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750935AbYBSAXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 19:23:13 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:45819 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbYBSAXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 19:23:12 -0500
Date: Mon, 18 Feb 2008 19:22:31 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Kevin Winchester <kjwinchester@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.25-rc2-mm1
In-Reply-To: <20080218161558.d315f9a0.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0802181921490.14755@gandalf.stny.rr.com>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
 <47BA1DE3.7030407@gmail.com> <20080218161558.d315f9a0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 Feb 2008, Andrew Morton wrote:

> >
> > I don't think I've seen anyone else report this, but if I'm wrong, I'm
> > sure someone will point me to the thread.
>
> No, I think it's new.
>

> Looks like an ftrace-vs-lockdep problem.
>

Is there a .config around to look at?

Thanks,

-- Steve

