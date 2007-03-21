Return-Path: <linux-kernel-owner+w=401wt.eu-S932436AbXCUUiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbXCUUiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 16:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933849AbXCUUiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 16:38:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:16465 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932436AbXCUUiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 16:38:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,309,1170662400"; 
   d="scan'208"; a="200311863:sNHT21667737"
In-Reply-To: <46017E56.7050400@lwfinger.net>
References: <20070319205623.299d0378.akpm@linux-foundation.org>	<1174433034.62033.16.camel@localhost> <20070320223643.d8cbc3f6.akpm@linux-foundation.org> <46017E56.7050400@lwfinger.net>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <8B46B235-9F02-4A39-943A-9D33F6661D04@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.21-rc4-mm1 - problem with cpuidle routine
Date: Wed, 21 Mar 2007 13:39:58 -0700
To: Larry Finger <larry.finger@lwfinger.net>
X-Mailer: Apple Mail (2.752.3)
X-OriginalArrivalTime: 21 Mar 2007 20:38:01.0405 (UTC) FILETIME=[D17D26D0:01C76BF8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 21, 2007, at 11:49 AM, Larry Finger wrote:

> When I configure 'CPU Idle PM Support' on my HP dv2125nr notebook  
> with a Turion X64 X2 processor and
> X86_64 architecture selected, the computer freezes on bootup. I  
> have included a portion the
> configuration file and part of /var/log/boot.msg for my working  
> system. Please let me know if
> further info from my system is required. I would be happy to test  
> any patches, etc.
>
> Larry
>

Looking at this failure. Will get back to you once I have some update...

In the mean time, can you send me the complete boot message when you  
disable cpuidle and system boots ok.

Thanks,
~Venki
