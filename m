Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968AbXLEP3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbXLEP3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 10:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbXLEP3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 10:29:35 -0500
Received: from ccs17.jlab.org ([129.57.35.82]:41313 "EHLO ccs17.jlab.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbXLEP3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 10:29:35 -0500
Message-ID: <4756C3D9.9030107@jlab.org>
Date: Wed, 05 Dec 2007 10:29:29 -0500
From: Jie Chen <chen@jlab.org>
Organization: Jefferson Lab
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Simon Holm Th??gersen <odie@cs.aau.dk>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Possible bug from kernel 2.6.22 and above, 2.6.24-rc4
References: <4744966C.900@jlab.org> <4744ADA9.7040905@cosmosbay.com> <4744E0DC.7050808@jlab.org> <1195698770.11808.4.camel@odie.local> <4744F042.4070002@jlab.org> <20071204131707.GA4232@elte.hu>
In-Reply-To: <20071204131707.GA4232@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jie Chen <chen@jlab.org> wrote:
> 
>> Simon Holm Th??gersen wrote:
>>> ons, 21 11 2007 kl. 20:52 -0500, skrev Jie Chen:
>>> There is a backport of the CFS scheduler to 2.6.21, see
>>> http://lkml.org/lkml/2007/11/19/127
>>>
>> Hi, Simon:
>>
>> I will try that after the thanksgiving holiday to find out whether the 
>> odd behavior will show up using 2.6.21 with back ported CFS.
> 
> would be also nice to test this with 2.6.24-rc4.
> 
> 	Ingo
Hi, Ingo:

I just ran the same test on two 2.6.24-rc4 kernels: one with 
CONFIG_FAIR_GROUP_SCHED on and the other with CONFIG_FAIR_GROUP_SCHED 
off. The odd behavior I described in my previous e-mails were still 
there for both kernels. Let me know If I can be any more help. Thank you.

-- 
###############################################
Jie Chen
Scientific Computing Group
Thomas Jefferson National Accelerator Facility
12000, Jefferson Ave.
Newport News, VA 23606

(757)269-5046 (office) (757)269-6248 (fax)
chen@jlab.org
###############################################

