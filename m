Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbYAGPHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbYAGPHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 10:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756773AbYAGPG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 10:06:58 -0500
Received: from rtr.ca ([76.10.145.34]:1512 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756767AbYAGPG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 10:06:57 -0500
Message-ID: <4782400D.2040802@rtr.ca>
Date: Mon, 07 Jan 2008 10:06:53 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, abelay@novell.com,
       lenb@kernel.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, rjw@sisk.pl
Subject: Re: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
References: <20071130142058.816d1693.akpm@linux-foundation.org>	<924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com>	<4750CC78.9070105@rtr.ca>	<20071130190227.1976e682@laptopd505.fenrus.org>	<4750D180.6080001@rtr.ca>	<20071130191816.3e744205@laptopd505.fenrus.org>	<4750D585.1030200@rtr.ca>	<477C2143.8090406@rtr.ca>	<924EFEDD5F540B4284297C4DC59F3DEE4FC485@orsmsx423.amr.corp.intel.com>	<477C622F.6010304@rtr.ca>	<20080104021619.GA15409@linux-os.sc.intel.com>	<47814958.3070208@rtr.ca> <20080106231848.762e93c1.akpm@linux-foundation.org>
In-Reply-To: <20080106231848.762e93c1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>..
> umm, OK, I queued it for 2.6.24.  I'll give people a day or so to comment
> on this.
> 
> I had to invent some silly changlelog for it.  Please review it for
> accuracy and completeness?
..
> From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
> 
> This was writeable in 2.6.23 but the cpuidle merge made it read-only.  But
> some people's scripts (ie: Mark's) were writing to it.
..

Actually, the cpuidle changes made it not appear at all in sysfs.

Thanks, Andrew & Venki.
