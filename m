Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbZLBP3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbZLBP3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbZLBP3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:29:30 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:35788 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbZLBP33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:29:29 -0500
Date: Wed, 2 Dec 2009 20:59:30 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Spencer Candland <spencer@bluehost.com>,
       Am?rico Wang <xiyou.wangcong@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH -v2 1/2] sched, cputime: cleanups related to task_times()
Message-ID: <20091202152929.GE3545@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com>
 <4B01A8DB.6090002@bluehost.com>
 <20091117130851.GA3842@dhcp-lab-161.englab.brq.redhat.com>
 <1258464288.7816.305.camel@laptop>
 <20091119181744.GA3743@dhcp-lab-161.englab.brq.redhat.com>
 <4B05F835.10401@jp.fujitsu.com>
 <20091123100925.GB25978@dhcp-lab-161.englab.brq.redhat.com>
 <20091123101612.GC25978@dhcp-lab-161.englab.brq.redhat.com>
 <4B1624C7.7040302@jp.fujitsu.com>
 <1259767055.4003.1037.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1259767055.4003.1037.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2009-12-02 16:17:35]:

> Could you, in the future, please start a new thread for new patches?
> 

Yes, I almost missed it, cause I marked the thread as read. Let me
look


-- 
	Balbir
