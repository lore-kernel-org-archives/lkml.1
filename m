Return-Path: <linux-kernel-owner+w=401wt.eu-S1764227AbXGZNxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764227AbXGZNxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 09:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbXGZNx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 09:53:26 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:46404 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbXGZNxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 09:53:25 -0400
Message-ID: <46A8A74F.6060608@fr.ibm.com>
Date: Thu, 26 Jul 2007 15:53:19 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Mel Gorman <mel@skynet.ie>
CC: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Shaohua Li <shaohua.li@intel.com>
Subject: Re: 2.6.23-rc1-mm1
References: <20070725040304.111550f4.akpm@linux-foundation.org> <200707251323.04594.lenb@kernel.org> <20070725115804.5b8efe83.akpm@linux-foundation.org> <200707251926.44656.lenb@kernel.org> <20070726094142.GA13365@skynet.ie>
In-Reply-To: <20070726094142.GA13365@skynet.ie>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On (25/07/07 19:26), Len Brown didst pronounce:
>> On Wednesday 25 July 2007 14:58, Andrew Morton wrote:
>>> On Wed, 25 Jul 2007 13:23:04 -0400
>>> Len Brown <lenb@kernel.org> wrote:
>>>
>>>> Andrew, you want to re-pull the acpi tree, or do you want me to send
>>>> you some patches on top of the current mm?
>>> I'd appreciate a fix for this one, please - I'll drop it int he hot-fixes
>>> directory as quite a few people seem to be hitting this.
>> Maybe simpler for mm1 to go backwards in time rather than forwards.
>> This should fix the problem at hand.
>>
> 
> I see this made it to the hot-fix directory. It fixes the problem for me
> on a standalone x86 laptop. At least the kernel built and booted.

I just booted a x86_64 blade with it. 

Thanks !

C.
