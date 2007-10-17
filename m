Return-Path: <linux-kernel-owner+w=401wt.eu-S1761189AbXJQXAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761189AbXJQXAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 19:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762305AbXJQW7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 18:59:46 -0400
Received: from rtr.ca ([76.10.145.34]:2459 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762260AbXJQW7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 18:59:45 -0400
Message-ID: <471693DF.4020608@rtr.ca>
Date: Wed, 17 Oct 2007 18:59:43 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kristen.c.accardi@intel.com, linux-kernel@vger.kernel.org, greg@kroah.com,
       pcihpd-discuss@lists.sourceforge.net, tytso@mit.edu
Subject: Re: [PATCH 0/4] Fix PCIe hotplug for non-ACPI ExpressCard slots (version
 2)
References: <4714C0A6.1030204@rtr.ca>	<4714D700.7060008@rtr.ca>	<20071016084634.8a0d695a.kristen.c.accardi@intel.com>	<47150565.5090102@rtr.ca>	<20071016114328.a96e8bcb.kristen.c.accardi@intel.com>	<47150982.6050102@rtr.ca>	<471509FE.7080505@rtr.ca>	<47151191.40406@rtr.ca>	<20071016130757.ed2f2ce4.kristen.c.accardi@intel.com>	<4715217D.2000803@rtr.ca>	<20071016214143.GC21815@kroah.com>	<471533AF.60100@rtr.ca>	<47156B14.2080608@rtr.ca> <20071017150243.1c21fea4.akpm@linux-foundation.org>
In-Reply-To: <20071017150243.1c21fea4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 16 Oct 2007 21:53:24 -0400
> Mark Lord <lkml@rtr.ca> wrote:
> 
>> Fix PCIe Hotplug so that it works with ExpressCard slots on Dell notebooks
>> in conjunction with the modparam of pciehp_force=1.
>>
>> The PCIe Hotplug driver has two shortcomings when used on Dell notebooks
>> which lack ACPI BIOS support for PCIe hotplug:
> 
> You just sent four patches all of which are identified as "Fix PCIe hotplug
> for non-ACPI ExpressCard slots (version 2)".  Please do not do this.

Eh?  They were labelled as 1/4, 2/4, 3/4, and 4/4.
But I'll make the rest of the subject line unique as well on resubmit, then.

Thanks.

So far, two postings, and zero comments from anyone on the actual code.

Cheers
