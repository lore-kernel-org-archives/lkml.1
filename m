Return-Path: <linux-kernel-owner+w=401wt.eu-S933397AbYB2WqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397AbYB2WqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 17:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760054AbYB2WqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 17:46:08 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52587 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759307AbYB2WqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 17:46:07 -0500
Message-ID: <47C88B46.3030806@jp.fujitsu.com>
Date: Fri, 29 Feb 2008 17:46:30 -0500
From: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       vatsa <vatsa@linux.vnet.ibm.com>, Kei Tokunaga <ktokunag@redhat.com>,
       Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Subject: Re: A strange behavior of sched_fair
References: <47C5E977.2010401@jp.fujitsu.com> <1204277686.6243.52.camel@lappy> <1204279909.6243.64.camel@lappy> <20080229194213.GA21249@elte.hu> <47C8692D.1030701@jp.fujitsu.com> <20080229203202.GA27212@elte.hu>
In-Reply-To: <20080229203202.GA27212@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote, (2008/02/29 15:32):
> * Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com> wrote:
> 
>> Hi Ingo, Peter,
>>
>> Thanks for the patch, Peter.  I modified it a bit to compile and 
>> confirmed the issue did not occur on my ia64 box.  I am attaching the 
>> revised patch below.
> 
> thanks, queued it up. Could you send me your Tested-by (and Acked-by) 
> lines?

Tested-by: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>

Thanks,
Kei

