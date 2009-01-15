Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbZAOQqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbZAOQqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 11:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZAOQqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 11:46:36 -0500
Received: from relay3.sgi.com ([192.48.171.31]:59704 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752658AbZAOQqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 11:46:35 -0500
Message-ID: <496F6862.5070104@sgi.com>
Date: Thu, 15 Jan 2009 08:46:26 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Tony Luck <tony.luck@intel.com>, IA64 <linux-ia64@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       David Howells <dhowells@redhat.com>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       linux-am33-list@redhat.com, "David S. Miller" <davem@davemloft.net>,
       SPARC <sparclinux@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: crash: IP: [<ffffffff80478092>] __bitmap_intersects+0x48/0x73
 [PATCH supplied]
References: <496BF6D5.9030403@sgi.com> <20090113130048.GB31147@elte.hu> <496CAF5A.3010304@sgi.com> <496D0F46.2010907@sgi.com> <496D2172.6030608@sgi.com> <20090114165431.GA18826@elte.hu> <20090114165524.GA21742@elte.hu> <20090114175126.GA21078@elte.hu> <496E78BA.5040609@sgi.com> <20090115101617.GH5833@elte.hu>
In-Reply-To: <20090115101617.GH5833@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Subject: irq: fix build errors referencing old kstat.irqs array
> 
> i've picked this up into tip/cpus4096, thanks Mike,
> 
> 	Ingo

I sent it as a patch because I wasn't sure if you wanted in the
cpus4096 branch or the sparseirqs branch.

Thanks,
Mike
