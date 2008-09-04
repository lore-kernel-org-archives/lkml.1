Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYIDRvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYIDRvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 13:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYIDRvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 13:51:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:55573 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbYIDRvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 13:51:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,320,1217833200"; 
   d="scan'208";a="612780655"
Date: Thu, 4 Sep 2008 10:51:40 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [patch 1/5] x2apic: fix reserved APIC register accesses in print_local_APIC()
Message-ID: <20080904175139.GN14481@linux-os.sc.intel.com>
References: <20080904000237.746216000@linux-os.sc.intel.com> <20080904110631.GC8668@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904110631.GC8668@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 04:06:31AM -0700, Ingo Molnar wrote:
> 
> applied the following patches tip/irq/sparseirq:

Ingo, Shouldn't this go to tip/x86/x2apic ? Thanks.

>  0f48966: dmar: fix dmar_parse_dev() devices_cnt error condition check
>  2283240: dmar: use list_for_each_entry_safe() in dmar_dev_scope_init()
>  3f1fdb3: dmar: initialize the return value in dmar_parse_dev()
>  f12c73e: dmar: fix using early fixmap mapping for DMAR table parsing
>  2c72d93: x2apic: fix reserved APIC register accesses in print_local_APIC()
> 
> thanks Suresh!
> 
>         Ingo
