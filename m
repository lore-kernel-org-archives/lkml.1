Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbZFJBkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbZFJBkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 21:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZFJBkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 21:40:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51262 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbZFJBkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 21:40:24 -0400
Message-ID: <4A2F0F1D.7010101@cn.fujitsu.com>
Date: Wed, 10 Jun 2009 09:40:45 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH RESEND] ftrace: change the export format of	trace_kfree_skb()
References: <4A2DF91F.7030906@cn.fujitsu.com> <20090609182730.GA6057@nowhere>
In-Reply-To: <20090609182730.GA6057@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Frederic Weisbecker wrote:

> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Would you also be interested in adding the conversion from raw numeric protocol
> to its name defined in include/linux/if_ether.h
> 
Hi Frederic:

OK, I'll do it.

> I guess __print_flags() can be used for that.
> 

Thanks for you suggestion.
IMHO, __print_symbolic() is more suitable for this. :-)

> Thanks,
> Frederic.
> 
> 
 
> 
