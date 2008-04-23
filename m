Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbYDWHdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbYDWHdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 03:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbYDWHc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 03:32:57 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:59305 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbYDWHc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 03:32:56 -0400
Date: Wed, 23 Apr 2008 13:02:36 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Soft lockup regression from today's sched.git merge.
Message-ID: <20080423073236.GB12561@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080422.015931.70144614.davem@davemloft.net> <20080422091456.GC9939@elte.hu> <20080422.224212.32058127.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422.224212.32058127.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 10:42:12PM -0700, David Miller wrote:
> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 22 Apr 2008 11:14:56 +0200
> 
> Anyways, I'll work on the group sched lockup bug next.  As if I have
> nothing better to do during the merge window than fix sched tree
> regressions :-(

I've been able to reproduce this on a 128way ppc64 box here. Let me see
if I can get you a fix soon enough.

-- 
regards,
Dhaval
