Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbZEMOm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbZEMOm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbZEMOmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:42:49 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42275 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718AbZEMOms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:42:48 -0400
Date: Wed, 13 May 2009 20:12:33 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>, Vatsa <vatsa@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v2 0/2] Saving power by
	cpuevacuationsched_max_capacity_pct=n
Message-ID: <20090513144233.GO13394@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090513130541.21440.33364.stgit@drishya.in.ibm.com> <1242220497.26820.21.camel@twins> <20090513134556.GN13394@balbir.in.ibm.com> <1242222475.26820.22.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1242222475.26820.22.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-05-13 15:47:55]:

> On Wed, 2009-05-13 at 19:15 +0530, Balbir Singh wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-05-13 15:14:57]:
> > 
> > > On Wed, 2009-05-13 at 18:41 +0530, Vaidyanathan Srinivasan wrote:
> > > 
> > > > * Peter Zijlstra wanted more justifications for throttling at the core
> > > >   level.  Throttling may be a resource management problem rather than
> > > >   scheduler/load balancer
> > > 
> > > No, I mandate that it be thermal management. Any other reason and you've
> > > got a NAK.
> > 
> > We've been discussing hard limits from the resource management view
> > point. Bharata is working on a RFC that we should be able to share
> > soon
> 
> Right, and you well know I dislike them.
> 

Yes, but we hope to convince you with use cases and examples.

-- 
	Balbir
