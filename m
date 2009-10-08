Return-Path: <linux-kernel-owner+w=401wt.eu-S1756374AbZJHAdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbZJHAdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 20:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbZJHAc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 20:32:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55962 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755433AbZJHAc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 20:32:59 -0400
Message-ID: <4ACD32D0.8010904@cn.fujitsu.com>
Date: Thu, 08 Oct 2009 08:31:12 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_event: Remove include/linux/perf_counter.h
References: <4ACC5F6D.7020809@cn.fujitsu.com> <1254908212.26976.229.camel@twins> <20091007094108.GA26272@elte.hu>
In-Reply-To: <20091007094108.GA26272@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
>> On Wed, 2009-10-07 at 17:29 +0800, Xiao Guangrong wrote:
>>> Remove include/linux/perf_counter.h because it's not used anymore after
>>> one of Ingo's patch:
>> The intent was to keep it around for one more release so as to not 
>> inconvenience userspace that relied on it too much, ie. give them time 
>> to convert.
> 
> yeah. There's no real cost in keeping it around. We can remove it in .34 
> or .35.
> 

Ah, my mistake, sorry for disturb you all.

Thanks,
Xiao

