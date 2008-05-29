Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbYE2QjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbYE2QjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 12:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbYE2Qiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 12:38:55 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35255 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbYE2Qiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 12:38:55 -0400
Date: Thu, 29 May 2008 22:17:50 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       pj@sgi.com, Balbir Singh <balbir@in.ibm.com>,
       aneesh.kumar@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com
Subject: Re: fair group scheduler not so fair?
Message-ID: <20080529164750.GD12836@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <4834B75A.40900@nortel.com> <20080527171528.GD30285@linux.vnet.ibm.com> <483C4F5A.2010104@nortel.com> <20080528163318.GG30285@linux.vnet.ibm.com> <483DA5E7.5050600@nortel.com> <20080529164607.GC12836@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529164607.GC12836@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 10:16:07PM +0530, Srivatsa Vaddagiri wrote:
> In summary, can you do this before running your tests:
> 
> 1. Apply updated patch below on top of 2.6.26-rc3 + Peter's patches
> (http://programming.kicks-ass.net/kernel-patches/sched-smp-group-fixes/)

Its quite a while since I downloaded Peter's patches and I hope it hasnt
changed! Once the results start looking good, I will request Peter to
roll it up in his patch stack.

-- 
Regards,
vatsa
