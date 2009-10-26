Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbZJZIKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbZJZIKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 04:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbZJZIKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 04:10:22 -0400
Received: from mail-gx0-f216.google.com ([209.85.217.216]:44928 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbZJZIKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 04:10:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QSCZksnwcBLK5p+joaS9hI7QHlmSye90ZrP2Fl2s0tHhBmQTLpxxdnrLuLsqE/AkI9
         Tw5adtwn5Hga17xNMrz7oLGnlwnJEypx6qx91qiVFKOZy2S2i6QTMY2mn7UDkNZQXdp0
         ITIqp/g0ct61x+qXHB/gybd2WtLNW5t5XCxAE=
MIME-Version: 1.0
In-Reply-To: <20091026073048.GC8162@elte.hu>
References: <20091023160257.GA30447@Krystal> <20091023160632.GA2198@Krystal>
	 <alpine.LNX.2.00.0910242300510.16628@swampdragon.chaosbits.net>
	 <20091026015357.GA6033@localhost>
	 <023001ca55e1$436e38e0$808410ac@zhaoleiwin>
	 <49b7c2350910252203o69811000w4551c01e6e2a10c7@mail.gmail.com>
	 <20091026073048.GC8162@elte.hu>
Date: Mon, 26 Oct 2009 17:10:26 +0900
Message-ID: <49b7c2350910260110l47d76cc5s35e87ca9082a9fa1@mail.gmail.com>
Subject: Re: Relicensing tracepoints and markers to Dual LGPL v2.1/GPL 
	v2,headers to Dual BSD/GPL
From: GeunSik Lim <leemgs1@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Jesper Juhl <jj@chaosbits.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Adrian Bunk <bunk@stusta.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       Michel Dagenais <michel.dagenais@polymtl.ca>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 4:30 PM, Ingo Molnar <mingo@elte.hu> wrote:
> Yes, the legality of such relicensing is questionable as that code was
> never developed outside of the kernel but as part of the kernel.
>
> But i also disagree with it on a technical level: code duplication is
> _bad_. Why does the code have to be duplicated in user-space like that?
> I'd like Linux tracing code to be in the kernel repo. Why isnt this done
> properly, as part of the kernel project - to make sure it all stays in
> sync?
It's right. I am not a special  lawyer about license issues currently.
But, Consider GPL v2 license with philosophical view. I think that this
re-licensing have a some problems in Linux kernel(GPL v2) at least.
> So for those two grounds i cannot give my permission for this
> relicensing, sorry.
I agree with your opinion.
>        Ingo
>



-- 
Regards,
GeunSik Lim ( Samsung Electronics )
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
