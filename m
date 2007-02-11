Return-Path: <linux-kernel-owner+w=401wt.eu-S1750751AbXBKRbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750751AbXBKRbi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 12:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750750AbXBKRbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 12:31:38 -0500
Received: from mga06.intel.com ([134.134.136.21]:39142 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750748AbXBKRbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 12:31:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,311,1167638400"; 
   d="scan'208"; a="195479217:sNHT21701946"
Message-ID: <45CF52F4.3060108@linux.intel.com>
Date: Sun, 11 Feb 2007 20:31:32 +0300
From: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: current git breaks resume
References: <20070209190307.GC6152@kernel.dk> <200702110002.38328.lenb@kernel.org> <20070211165302.GO6458@kernel.dk>
In-Reply-To: <20070211165302.GO6458@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Sun, Feb 11 2007, Len Brown wrote:
>   
>> On Friday 09 February 2007 14:03, Jens Axboe wrote:
>>     
>>> Hi,
>>>
>>> Unfortunately I'm a little short on time as I'll be travelling tomorrow,
>>> but of course preparing a new kernel for the laptop is something you
>>> want to do right before leaving. So I discovered that the current (well
>>> as of yesterday, HEAD is 5986a2ec35836a878350c54af4bd91b1de6abc59)
>>> doesn't resume on my x60. 2.6.20 works fine, so something broke since
>>> then.
>>>       
>> resume from RAM, or resume from disk?
>>     
>
> Resume from RAM, I never use suspend-to-disk.
>
>   
Jens,
Could you please test the patch I've sent?

Thanks,
    Alex.
