Return-Path: <linux-kernel-owner+w=401wt.eu-S1423584AbXEAOUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423584AbXEAOUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 10:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423574AbXEAOUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 10:20:19 -0400
Received: from rtr.ca ([64.26.128.89]:1462 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423586AbXEAOUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 10:20:08 -0400
Message-ID: <46374C94.8020204@rtr.ca>
Date: Tue, 01 May 2007 10:20:04 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Andi Kleen <ak@suse.de>, ebiederm@xmission.com, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [30/30] x86_64: Add missing !X86_PAE dependincy to the
 2G/2G split.
References: <20070501557.815359000@suse.de> <20070501035829.1C93D13CAF@wotan.suse.de> <20070501043735.GR31925@holomorphy.com> <46374171.1050009@rtr.ca> <20070501141714.GT19966@holomorphy.com>
In-Reply-To: <20070501141714.GT19966@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>..
> On Tue, May 01, 2007 at 09:32:33AM -0400, Mark Lord wrote:
>> You need to go search the archives and read the *extensive* thread
>> on this from when it was introduced.  Lots of high profile kernel
>> developers were in on this one.
> 
> Various good points were raised. The NX bit requiring
> 3-level pagetables suggests that 3-level pagetables without highmem
> would be valuable, at which point the unaligned splits to avoid highmem
> with 3-level pagetables gain additional relevance. I'll queue that up
> to be written along with split pmd affairs, and check for features
> dependent on 4-level pagetables, too.

Excellent!  That would be super to have in there, William.

Cheers!
