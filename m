Return-Path: <linux-kernel-owner+w=401wt.eu-S1753572AbZLGGRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbZLGGRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 01:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbZLGGRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 01:17:00 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:56762 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbZLGGQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 01:16:59 -0500
Message-ID: <4B1C9DDB.90607@in.ibm.com>
Date: Mon, 07 Dec 2009 11:46:59 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: ego@in.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Gregory Haskins <ghaskins@novell.com>, maxk <maxk@qualcomm.com>
Subject: Re: -next: Nov 12 - kernel BUG at kernel/sched.c:7359!
References: <20091112195101.63263490.sfr@canb.auug.org.au> <4AFBF73B.5040500@in.ibm.com> <1258027820.4039.129.camel@laptop> <4AFBFE3D.80507@in.ibm.com> <1258028831.4039.152.camel@laptop> <1258045831.4039.736.camel@laptop>  <20091113095801.GA29977@in.ibm.com> <1258107368.4039.1149.camel@laptop> <1258108281.22655.5.camel@laptop> <4B0A5BA7.8020604@in.ibm.com> <1259156575.4027.514.camel@laptop> <4B18FB2E.1070200@in.ibm.com> <1259929010.17907.178.camel@laptop>
In-Reply-To: <1259929010.17907.178.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2009-12-04 at 17:36 +0530, Sachin Sant wrote:
>   
>> Ping on this patch. Still missing from linux-next.
>>     
>
> I know, it got stuck in my queue too long, but I handed it to Ingo
> yesterday, should appear in tip soonish.
Thanks Peter. 

The same problem appeared in 2.6.32-git1 (6ec22f9...) as well.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

