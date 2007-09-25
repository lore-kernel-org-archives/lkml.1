Return-Path: <linux-kernel-owner+w=401wt.eu-S1759305AbXIYIES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305AbXIYIES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbXIYIEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:04:01 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:48715 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209AbXIYID6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:03:58 -0400
Message-ID: <46F8C09F.4050707@linux.vnet.ibm.com>
Date: Tue, 25 Sep 2007 13:32:39 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.23-rc7-mm1: panic in scheduler
References: <1190668373.5030.10.camel@localhost> <46F82C88.1080907@linux.vnet.ibm.com> <661de9470709250002u73c1089dx94870586ce23b5b5@mail.gmail.com>
In-Reply-To: <661de9470709250002u73c1089dx94870586ce23b5b5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> On 9/25/07, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>> Exactly same call trace is produced over IA64 Madison (up to 9M cache) with 8 cpu's.
>> --
> 
> Hi, Kamalesh,
> 
> Could you please reproduce the problem or share the steps to reproduce
> the problem?
> 
> Thanks,
> Balbir
> -

Hi Balbir,

Yes, i am able to reproduce the problem. The problem can be reproduced
using the ltprunall.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
