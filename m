Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbYLWCFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbYLWCFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 21:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYLWCFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 21:05:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60850 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbYLWCFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 21:05:30 -0500
Message-ID: <4950474E.70000@zytor.com>
Date: Mon, 22 Dec 2008 18:05:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu,
       tglx@linutronix.de, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: use logical apicid in x2apic_cluster's x2apic_cpu_mask_to_apicid_and()
References: <20081223013327.GA29686@linux-os.sc.intel.com> <495042F2.5080503@sgi.com>
In-Reply-To: <495042F2.5080503@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Suresh Siddha wrote:
>> From: Suresh Siddha <suresh.b.siddha@intel.com>
>> Subject: x86: use logical apicid in x2apic_cluster's x2apic_cpu_mask_to_apicid_and()
>>
>> Impact: fixes the broken interrupt delivery issue on generic x2apic platforms.
>>
>> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> Thanks Suresh for catching this!  You can add my
> 
> Acked-by: Mike Travis <travis@sgi.com>
> 

Applied to tip:cpus4096, thanks!

	-hpa
