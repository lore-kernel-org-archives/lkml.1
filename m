Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbYAGAfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbYAGAfc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 19:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYAGAfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 19:35:24 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:19414 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYAGAfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 19:35:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Z7S/0FHwwPFVmqnTRbuqQoGySIdI3BmzFQoavxQ7uj7fvbMGNg5gWPajffJnEuJxwNMAnukgICYnIL0RBQyoWiIpsx22AZfHuthHd/RZq/O3LGrHYa18bEq7k4kbbHWF9krnCkkRG0ERIdD556SnkkRkmCCalJVUBh4oskqt1EQ=
Message-ID: <478173C4.8090507@gmail.com>
Date: Mon, 07 Jan 2008 09:35:16 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mark Lord <lkml@rtr.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Linux 2.6.24-rc7
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <478169AD.3020808@rtr.ca> <alpine.LFD.1.00.0801061605240.3148@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801061605240.3148@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Linus Torvalds wrote:
> On Sun, 6 Jan 2008, Mark Lord wrote:
>> We're still missing the sata_qstor regression fix from Tejun,
>> and the patch from Venkatesh Pallipadi that reinstates max_cstate
>> in sysfs for !CPU_IDLE.
> 
> I'm not seeing those in my inbox. I don't go out trolling for patches, 
> because I expect that if the author of the patch really wants me to apply 
> it, he'd send it upstream.
> 
> But I know a number of people are on vacation, and I suspect some of these 
> fixes are just queued up, waiting for that.  E.g. I think Jeff is supposed 
> to be back this week, etc..

Yeap, I have two patches pending for #upstream-fixes.

http://article.gmane.org/gmane.linux.ide/26750
http://article.gmane.org/gmane.linux.ide/26822

Jeff, can you ack those?

Thanks.

-- 
tejun
