Return-Path: <linux-kernel-owner+w=401wt.eu-S1759120AbZDQAch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759120AbZDQAch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759121AbZDQAcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:32:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58797 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759103AbZDQAcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:32:14 -0400
Message-ID: <50694D6B4B4A4881BBEA649E4B5797E7@zhaoleiwin>
From: "Zhaolei" <zhaolei@cn.fujitsu.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>
References: <49D5E3EE.70201@cn.fujitsu.com> <49D5E44B.3080104@cn.fujitsu.com> <alpine.DEB.2.00.0904062153120.29426@gandalf.stny.rr.com> <alpine.DEB.2.00.0904161053590.6495@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/2] ftrace: Code cleanup for kernel/trace/trace_events_stage_*.h
Date: Fri, 17 Apr 2009 08:31:50 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n3H0XGqu007247

* From: "Steven Rostedt" <rostedt@goodmis.org>
> 
> On Mon, 6 Apr 2009, Steven Rostedt wrote:
> 
>> 
>> On Fri, 3 Apr 2009, Zhaolei wrote:
>> 
>> > Add TRACE_FORMAT's define for trace_events_stage_2.h.
>> > Although it is already defined in trace_events_stage_1.h, we should make each
>> > function independence.
>> > 
>> > Move TP_fast_assign's define from trace_events_stage_2.h to
>> > trace_events_stage_3.h because it is used there.
>> > 
>> > Unify TRACE_EVENT's 5th argument's name to "assign"
>> > 
>> > Impact: cleanup, no functionality changed
>> > 
>> > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
>> 
>> I see what you are doing here, but I'm a little hesitant to apply it.
>> I'm getting ready to travel, so I do not have the time to look deeper at 
>> this today. I'll try to do it while I'm traveling.
> 
> Hi Zhao,
> 
> As you probably noticed, the staging code has been combined into 
> include/trace/ftrace.h
> 
> Is this patch (or a variant) still needed?
Hello, Steven 

I see your patchset, it is nice.
This patch is no use now, please ignore it.

Thanks
Zhaolei
> 
> -- Steve
> 
> 
>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
