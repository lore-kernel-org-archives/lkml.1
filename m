Return-Path: <linux-kernel-owner+w=401wt.eu-S1754310AbYGMBTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbYGMBTf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 21:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbYGMBT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 21:19:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:60339 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbYGMBT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 21:19:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,352,1212390000"; 
   d="scan'208";a="594341091"
Date: Sat, 12 Jul 2008 18:19:26 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make read_apic_id return final apicid
Message-ID: <20080713011926.GE1678@linux-os.sc.intel.com>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807111841.55403.yhlu.kernel@gmail.com> <200807111843.11157.yhlu.kernel@gmail.com> <200807111844.17084.yhlu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807111844.17084.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 06:44:16PM -0700, Yinghai Lu wrote:
> 
> also remove GET_APIC_ID when read_apic_id is used.
> 
> need to apply after
>         [PATCH] x86: mach_apicdef.h need to include before smp.h
> 
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
