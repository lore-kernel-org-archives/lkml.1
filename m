Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbXIZNbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbXIZNbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 09:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756538AbXIZNb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 09:31:29 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:52244 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbXIZNb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 09:31:28 -0400
Date: Wed, 26 Sep 2007 19:00:37 +0530
To: Jaswinder Singh <jaswinderlinux@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: realtime preemption performance difference
Message-ID: <20070926133037.GA22760@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <3f9a31f40709240448h4a9e8337t437328b5c675ecd5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40709240448h4a9e8337t437328b5c675ecd5@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: ankita@in.ibm.com (Ankita Garg)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaswinder,

On Mon, Sep 24, 2007 at 05:18:01PM +0530, Jaswinder Singh wrote:
> Hi all,
> 
> I want to check performance difference by using realtime preemption patch :
> 
> http://www.kernel.org/pub/linux/kernel/projects/rt/
> 
> Please let me know from where I can download samples to test realtime
> preemption performance difference.
> 

You can obtain several -rt testcases from the RT wiki:
http://rt.wiki.kernel.org/index.php/Main_Page Here we have testcases/benchmarks
for measuring scheduling latencies, priority preemption, signaling latencies, etc
and other important information on the patchset.

Hope this helps!

> Can someone please share performance numbers for your hardware:-
> 
> 1. Interrupt latency
> 2. Task switching time
> 3. hard-realtime scheduling latency
> 
> Thank you,
> 
> Jaswinder Singh.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs, 
Bangalore, India   
