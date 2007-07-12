Return-Path: <linux-kernel-owner+w=401wt.eu-S932829AbXGLMVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829AbXGLMVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762356AbXGLMVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:21:05 -0400
Received: from twin.jikos.cz ([213.151.79.26]:56344 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667AbXGLMVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:21:03 -0400
Date: Thu, 12 Jul 2007 14:20:24 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: v2.6.22.1-rt1
In-Reply-To: <20070712121355.GA10949@elte.hu>
Message-ID: <Pine.LNX.4.64.0707121418350.31463@twin.jikos.cz>
References: <20070712121355.GA10949@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007, Ingo Molnar wrote:

> we are pleased to announce the v2.6.22.1-rt1 kernel, which can be 
> downloaded from the usual place:
>    http://redhat.com/~mingo/realtime-preempt/
> more info about the -rt patchset can be found in the RT wiki:
>    http://rt.wiki.kernel.org

I wanted to ask this question a zillion times already but I have always 
forgotten - is there any repository for -rt (quilt, git) which would 
provide more 'broken-out' view of the patchset, or the only public thing 
is this one huge patch?

http://rt.wiki.kernel.org/index.php/Special:Search?search=quilt&go=Go 
didn't seem to provide too much information (the same for git, etc).

Thanks,

-- 
Jiri Kosina
