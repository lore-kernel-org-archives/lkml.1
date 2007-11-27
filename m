Return-Path: <linux-kernel-owner+w=401wt.eu-S1758008AbXK0OU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbXK0OU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 09:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757467AbXK0OUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 09:20:18 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50654 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757294AbXK0OUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 09:20:17 -0500
Date: Tue, 27 Nov 2007 20:02:57 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>,
       Dipankar <dipankar@in.ibm.com>
Subject: Re: [Patch 0/5] sched: group scheduler related patches (V4)
Message-ID: <20071127143257.GC22197@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20071119152258.GB31426@elte.hu> <20071119160647.GV3359@linux.vnet.ibm.com> <20071119190057.GA12650@elte.hu> <20071126050044.GA5304@linux.vnet.ibm.com> <20071126050905.GF5304@linux.vnet.ibm.com> <20071126202836.GA17012@elte.hu> <20071127050652.GA20083@linux.vnet.ibm.com> <20071127110910.GB16273@elte.hu> <20071127114246.GB22197@linux.vnet.ibm.com> <20071127125312.GA28019@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127125312.GA28019@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 01:53:12PM +0100, Ingo Molnar wrote:
> > Fine. I will resubmit this patchset then once we are into 2.6.25 
> > cycle.
> 
> no need (unless you have bugfixes) i'm carrying this around in the 
> scheduler git tree. (it will show up in sched-devel.git)

Cool .. Thx! It will get me some testing results (from those who test
sched-devel tree) and also will save me some maintenance trouble :)

-- 
Regards,
vatsa
