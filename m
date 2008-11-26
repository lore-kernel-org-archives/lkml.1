Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbYKZCvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbYKZCvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 21:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbYKZCvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 21:51:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36187 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbYKZCvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 21:51:12 -0500
Date: Tue, 25 Nov 2008 21:51:10 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-return-tracer: set a more human readable
 output
In-Reply-To: <20081126024232.GA31342@elte.hu>
Message-ID: <alpine.DEB.1.10.0811252150490.26424@gandalf.stny.rr.com>
References: <492C90E5.8070907@gmail.com> <20081126003936.GA26937@elte.hu> <20081126021450.GA17617@elte.hu> <alpine.DEB.1.10.0811252121440.26424@gandalf.stny.rr.com> <20081126024232.GA31342@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Nov 2008, Ingo Molnar wrote:
> > This is probably fixed with my patch set.
> 
> yeah - but note that the graph-tracer rename came in the way of them. 
> Mind redoing your two patches ontop of latest tip/master?

I expected this. I'll rebase them again.

-- Steve

