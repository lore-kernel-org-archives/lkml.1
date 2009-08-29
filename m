Return-Path: <linux-kernel-owner+w=401wt.eu-S1751561AbZH2F3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561AbZH2F3i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 01:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbZH2F3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 01:29:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54968 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbZH2F3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 01:29:36 -0400
Message-ID: <4A98BCA7.5080400@cn.fujitsu.com>
Date: Sat, 29 Aug 2009 13:29:11 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] tracing: block-able ring_buffer consumer
References: <4A95F71C.1060607@cn.fujitsu.com> <alpine.DEB.2.00.0908262333580.18923@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0908262333580.18923@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: : ISVW-6.0.0.2339-3.52.0.1010-13974000
X-TM-AS-Result: : No
X-TM-AS-Category-Info: : 31:0.000000
X-TM-AS-MatchedID: : 1-150567-139010
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Thu, 27 Aug 2009, Lai Jiangshan wrote:
> 
>> The first patch fixes a bug of splice_read for ring_buffer, and makes
>> rb_get_reader_page() can be easily used by block-able/poll-able codes.
>>
>> The other patches make consumer block-able and poll-able.
> 
> Hi Lai,
> 
> Thanks, I'll take a look at these patches tomorrow.
> 
> -- Steve
> 


Hi, Steven

Thanks, could you give some comments?

Regards,

Lai

