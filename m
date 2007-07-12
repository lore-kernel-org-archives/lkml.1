Return-Path: <linux-kernel-owner+w=401wt.eu-S935439AbXGLQmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935439AbXGLQmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762408AbXGLQmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:42:35 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:46302 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbXGLQme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:42:34 -0400
Subject: Re: [announce] split-up -rt patch-queue, v2.6.22.1-rt2
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070712153717.GA7442@elte.hu>
References: <20070712153717.GA7442@elte.hu>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 09:33:18 -0700
Message-Id: <1184257998.7974.44.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 17:37 +0200, Ingo Molnar wrote:
> We are pleased to announce something we've been working on for some 
> time: a finegrained, split-up patch queue of the -rt kernel patch. From 
> now on (as of 2.6.22.1-rt2) it will be part of every upstream -rt 
> release and it is available from the -rt download site:
> 
>    http://redhat.com/~mingo/realtime-preempt/
> 
> the -rt patch-queue consists of 374 patches at the moment, which do:
> 
>    698 files changed, 27920 insertions(+), 9603 deletions(-)

Is the number of patches relevant to you ? It seems like some patches
could be boken out more. For instance there could be a per-architecture
patch dedicated to converting spinlocks to raw spinlocks .. I was
looking at preempt-realtime-i386.patch ..

Daniel

