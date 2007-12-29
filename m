Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbXL2TdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbXL2TdT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 14:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbXL2TdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 14:33:00 -0500
Received: from mga06.intel.com ([134.134.136.21]:8828 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750948AbXL2Tc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 14:32:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,221,1196668800"; 
   d="scan'208";a="309343610"
Message-ID: <4776A07C.5090806@linux.intel.com>
Date: Sat, 29 Dec 2007 20:31:08 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org
Subject: Re: Top 9 kernel oopses/warnings for the week of December 29th, 2007
References: <477630CF.5070609@linux.intel.com> <alpine.LFD.0.9999.0712291116190.2778@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712291116190.2778@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 29 Dec 2007, Arjan van de Ven wrote:
>> It has been a quiet week due to the holidays, only 55 oops traces
>> have been collected.
> 
> This would be more useful if it was more readable. As it is, you seem to 
> have some formatting errors in your automation, where the things are 
> incorrectly grouped:

this is manual made; I'll blame thunderbird for now

let me see if I can send it again without corruption

> 
>> Rank 1: sysctl_head_finish
>> 	sysctl table check failed
>> 	Reported 7 times
>> 	Only reported for the proprietary madwifi driver
>> 	More info: http://www.kerneloops.org/search.php?search=sysctl_head_finish
>> 	Rank 2: __ieee80211_rx
>> 	Warning at net/mac80211/rx.c:1672
> 
> ie notice how that "Rank 2" got reported as if it was part of the "Rank 1" 
> issue. 
> 
> 		Linus

