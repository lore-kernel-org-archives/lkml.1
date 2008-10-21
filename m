Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109AbYJURfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbYJURfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 13:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbYJURfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 13:35:41 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:41676 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbYJURfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 13:35:40 -0400
Date: Tue, 21 Oct 2008 23:05:29 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 0/4] pending scheduler updates
Message-ID: <20081021173529.GG11679@linux.vnet.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20081017172701.047939625@chello.nl> <20081020120538.GD10594@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020120538.GD10594@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 02:05:38PM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Please apply
> 
> applied these to tip/sched/urgent:
> 
>  f9c0b09: sched: revert back to per-rq vruntime
>  a4c2f00: sched: fair scheduler should not resched rt tasks
>  ffda12a: sched: optimize group load balancer
> 
> (will wait with 4/4 until you and Mike come to a verdict.)

Is there any conclusion on Patch 4/4? It looks sane to me!

-- 
Regards,
vatsa
