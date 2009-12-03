Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbZLCAVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbZLCAVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 19:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbZLCAVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 19:21:43 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43964 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbZLCAVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 19:21:42 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B170485.9050603@jp.fujitsu.com>
Date: Thu, 03 Dec 2009 09:21:25 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Peter Zijlstra <peterz@infradead.org>,
       Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Spencer Candland <spencer@bluehost.com>,
       Am?rico Wang <xiyou.wangcong@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH -v2 1/2] sched, cputime: cleanups related to task_times()
References: <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com> <4B01A8DB.6090002@bluehost.com> <20091117130851.GA3842@dhcp-lab-161.englab.brq.redhat.com> <1258464288.7816.305.camel@laptop> <20091119181744.GA3743@dhcp-lab-161.englab.brq.redhat.com> <4B05F835.10401@jp.fujitsu.com> <20091123100925.GB25978@dhcp-lab-161.englab.brq.redhat.com> <20091123101612.GC25978@dhcp-lab-161.englab.brq.redhat.com> <4B1624C7.7040302@jp.fujitsu.com> <1259767055.4003.1037.camel@laptop> <20091202152929.GE3545@balbir.in.ibm.com>
In-Reply-To: <20091202152929.GE3545@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> * Peter Zijlstra <peterz@infradead.org> [2009-12-02 16:17:35]:
> 
>> Could you, in the future, please start a new thread for new patches?
>>
> 
> Yes, I almost missed it, cause I marked the thread as read. Let me
> look

OK, I will.

Maybe here I could post a link to new thread instead, to make tracking
problem from original thread to patch easy.


Thanks,
H.Seto

