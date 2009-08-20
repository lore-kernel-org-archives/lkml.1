Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbZHTKda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbZHTKda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbZHTKda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:33:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbZHTKd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:33:29 -0400
Message-ID: <4A8D26BF.8090806@redhat.com>
Date: Thu, 20 Aug 2009 18:34:39 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Wu Fengguang <fengguang.wu@intel.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [Patch] proc: drop write permission on 'timer_list' and	'slabinfo'
References: <20090817094822.GA17838@elte.hu> <1250502847.5038.16.camel@penberg-laptop> <alpine.DEB.1.10.0908171228300.16267@gentwo.org> <4A8986BB.80409@cs.helsinki.fi> <alpine.DEB.1.10.0908171240370.16267@gentwo.org> <4A8A0B0D.6080400@redhat.com> <4A8A0B14.8040700@cn.fujitsu.com> <4A8A1B2E.20505@redhat.com> <20090818120032.GA22152@localhost> <4A8B652E.40905@redhat.com> <20090819023737.GA17710@localhost> <4A8BD67F.8020007@redhat.com> <4A8C48AB.1030700@cs.helsinki.fi>
In-Reply-To: <4A8C48AB.1030700@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Amerigo Wang wrote:
>> Pekka, could you please also take the patch attached below? It is 
>> just a trivial coding style fix. And it is based on the my previous 
>> patch.
>
> The last hunk was already in slab.git because I fixed your patch up by 
> hand. I applied the rest but can you please send proper patches in the 
> future? That is, no attachments and a "git am" friendly subject line. 
> Thanks!

Nice. Thanks!


