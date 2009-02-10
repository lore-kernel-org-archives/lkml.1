Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbZBJOL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbZBJOL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755547AbZBJOLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:11:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54224 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509AbZBJOLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:11:12 -0500
Date: Tue, 10 Feb 2009 09:11:11 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 0/2] git pull request for tip/tracing/urgent
In-Reply-To: <20090210130411.GB8341@elte.hu>
Message-ID: <alpine.DEB.1.10.0902100910000.23505@gandalf.stny.rr.com>
References: <20090209151744.459736868@goodmis.org> <20090210130411.GB8341@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 10 Feb 2009, Ingo Molnar wrote:
> 
> hm, the branch does not exist anymore:
> 
>   fatal: Couldn't find remote ref tip/tracing/urgent/devel
>   fatal: Couldn't find remote ref tracing/urgent/devel
>   fatal: Couldn't find remote ref tracing/urgent

Grumble, it failed to push. I'll fix that.

> 
> In any case, please include this in the devel path not the urgent path.
> Urgent patches are for real regressions that occur with the upstream
> kernel and affect users. New uses of tracing code should be done on
> top of the tracing tree.

OK, good to know. I'll move those to the tip/tracing/ftrace branch. I do 
have a bug that needs fixing in urgent though. I'll get that out without 
these changes.

Thanks,

-- Steve

