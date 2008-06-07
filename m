Return-Path: <linux-kernel-owner+w=401wt.eu-S1765831AbYFGWHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765831AbYFGWHH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 18:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764845AbYFGVxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 17:53:35 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:40151 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764589AbYFGVxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 17:53:33 -0400
Message-ID: <484B0355.9030000@linux.vnet.ibm.com>
Date: Sun, 08 Jun 2008 03:23:25 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [mmotm] __build_sched_domains panic
References: <484AFC5A.3070006@linux.vnet.ibm.com> <19f34abd0806071444l4b142b00q348ff7a270f40344@mail.gmail.com>
In-Reply-To: <19f34abd0806071444l4b142b00q348ff7a270f40344@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> On Sat, Jun 7, 2008 at 11:23 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> Hi, Andrew,
>>
>> I have an x86_64 system with 4 CPUs and 4GB memory and I see the following
>> panic, when I boot with fake NUMA nodes. I am still investigating the problem. I
>> was trying to use this setup to verify KAMEZAWA's fix for the memcgroup page
>> migration problem.
> 
> Hi :)
> 
> This is already fixed. Actually, it was just caused by a missing patch.
> 
> You need a953e4597abd51b74c99e0e3b7074532a60fd031 from the -tip tree.

Thanks for the update!

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
