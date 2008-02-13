Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbYBMSKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbYBMSKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbYBMSKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 13:10:08 -0500
Received: from relay1.sgi.com ([192.48.171.29]:45395 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750861AbYBMSKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 13:10:05 -0500
Message-ID: <47B33278.3060408@sgi.com>
Date: Wed, 13 Feb 2008 10:10:00 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@elte.hu, tglx@linutronix.de, ak@suse.de, clameter@sgi.com,
       steiner@sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       len.brown@intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/4] acpi: change cpufreq tables to per_cpu variables
References: <20080208233738.108449000@polaris-admin.engr.sgi.com>	<20080208233738.427702000@polaris-admin.engr.sgi.com> <20080212153356.d2be3248.akpm@linux-foundation.org>
In-Reply-To: <20080212153356.d2be3248.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 08 Feb 2008 15:37:40 -0800
> Mike Travis <travis@sgi.com> wrote:
> 
>> Change cpufreq tables from arrays to per_cpu variables in
>> drivers/acpi/processor_thermal.c
>>
>> Based on linux-2.6.git + x86.git
> 
> I fixed a bunch of rejects in "[PATCH 1/4] cpufreq: change cpu freq tables
> to per_cpu variables" and it compiles OK.  But this one was beyond my
> should-i-repair-it threshold, sorry.

Should I rebase all the pending patches on 2.6.25-rc1 or 2.6.24-mm1
(or some other combination)?

Thanks,
Mike
