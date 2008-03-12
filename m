Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbYCLOJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbYCLOJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 10:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbYCLOJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 10:09:00 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:37110 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751355AbYCLOJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 10:09:00 -0400
Message-ID: <47D7E3E0.3040401@linux.vnet.ibm.com>
Date: Wed, 12 Mar 2008 19:38:32 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [RFC/PATCH 03/17] sched: rt-group: full hierarchy support for
 the rt groups
References: <20080309170850.256853000@chello.nl> <20080309170926.354453000@chello.nl> <20080312082532.GB3784@linux.vnet.ibm.com> <661de9470803120129l66497656o948c13c6c0c26766@mail.gmail.com> <1205314176.8514.219.camel@twins>
In-Reply-To: <1205314176.8514.219.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, 2008-03-12 at 13:59 +0530, Balbir Singh wrote:
>> On Wed, Mar 12, 2008 at 1:55 PM, Dhaval Giani
>> <dhaval@linux.vnet.ibm.com> wrote:
>>         On Sun, Mar 09, 2008 at 06:08:53PM +0100, Peter Zijlstra
>>         wrote:
>>         > Update the -rt bits to support the full hierarchy support
>>         started by Dhaval.
>>         >
>>         
>>         
>>         Thanks for the effort. Just a very minor comment. I will try
>>         these out
>>         and give more feedback.
>>         
>>         
>>         > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>         
>>
>> Shouldn't this have Dhaval's signed-off-by as well? Dhaval do you want
>> to sign-off on these patches?
> 
> He can Ack it, but the 3rd patch was not authored by him.
> 

My bad, I saw his sign-off on the first two patches. I got confused due to the
order in which my mailer received the patches.



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
