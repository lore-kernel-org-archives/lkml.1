Return-Path: <linux-kernel-owner+w=401wt.eu-S933481AbYBMQ5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933481AbYBMQ5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759292AbYBMQ5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:57:32 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:46031 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757690AbYBMQ5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:57:31 -0500
Date: Wed, 13 Feb 2008 22:36:48 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Regression in latest sched-git
Message-ID: <20080213170648.GA28410@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20080212185355.GA6320@linux.vnet.ibm.com> <1202845208.6247.82.camel@lappy> <20080213030035.GA3402@linux.vnet.ibm.com> <1202907078.20209.3.camel@lappy> <20080213163444.GA19570@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213163444.GA19570@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 10:04:44PM +0530, Dhaval Giani wrote:
> I know I am missing something, but aren't we trying to reduce latencies
> here?

I guess Peter is referring to the latency in seeing fairness results. In
other words, with single rq approach, you may require more time for the groups 
to converge on fairness.

-- 
Regards,
vatsa
