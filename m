Return-Path: <linux-kernel-owner+w=401wt.eu-S1030801AbXDRCb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030801AbXDRCb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 22:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031317AbXDRCb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 22:31:59 -0400
Received: from omta05sl.mx.bigpond.com ([144.140.93.195]:53413 "EHLO
	omta05sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030801AbXDRCb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 22:31:58 -0400
Message-ID: <46258311.2000909@bigpond.net.au>
Date: Wed, 18 Apr 2007 12:31:45 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <46241677.7060909@bigpond.net.au> <20070417025704.GM8915@holomorphy.com> <462445EC.1060306@bigpond.net.au> <20070417053147.GN8915@holomorphy.com> <46246A7C.8050501@bigpond.net.au> <20070417064109.GP8915@holomorphy.com> <46247E86.5090706@bigpond.net.au> <20070417104141.GV8915@holomorphy.com> <4624D027.4040500@bigpond.net.au> <462565EF.4030200@bigpond.net.au> <20070418020329.GS2986@holomorphy.com>
In-Reply-To: <20070418020329.GS2986@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta07sl.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Wed, 18 Apr 2007 02:31:50 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>> Peter Williams wrote:
>>> William Lee Irwin III wrote:
>>>> I was tempted to restart from scratch given Ingo's comments, but I
>>>> reconsidered and I'll be working with your code (and the German
>>>> students' as well). If everything has to change, so be it, but it'll
>>>> still be a derived work. It would be ignoring precedent and failure to
>>>> properly attribute if I did otherwise.
>>> I can give you a patch (or set of patches) against the latest git 
>>> vanilla kernel version if that would help.  There have been changes to 
>>> the vanilla scheduler code since 2.6.20 so the latest patch on 
>>> sourceforge won't apply cleanly.  I've found that implementing this as a 
>>> series of patches rather than one big patch makes it easier fro me to 
>>> cope with changes to the underlying code.
> On Wed, Apr 18, 2007 at 10:27:27AM +1000, Peter Williams wrote:
>> I've just placed a single patch for plugsched against 2.6.21-rc7 updated 
>> to Linus's git tree as of an hour or two ago on sourceforge:
>> <http://downloads.sourceforge.net/cpuse/plugsched-6.5-for-2.6.21-rc7.patch>
>> This should at least enable you to get it to apply cleanly to the latest 
>> kernel sources.  Let me know if you'd also like this as a quilt/mq 
>> friendly patch series?
> 
> A quilt-friendly series would be most excellent if you could arrange it.

Done:

<http://downloads.sourceforge.net/cpuse/plugsched-6.5-for-2.6.21-rc7.patch-series.tar.gz>

Just untar this in the base directory of your Linux kernel source and 
Bob's your uncle.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
