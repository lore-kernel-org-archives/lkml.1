Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbYKQSJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbYKQSJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbYKQSJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:09:48 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:64128 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbYKQSJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:09:48 -0500
Message-ID: <4921B368.1010403@ct.jp.nec.com>
Date: Mon, 17 Nov 2008 10:09:44 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86: ia32_signal: remove using temporary variable
References: <491E4101.7010405@ct.jp.nec.com> <491E41C3.9010500@ct.jp.nec.com> <2375c9f90811150922x21e41faevcd7f1e9af45426e3@mail.gmail.com>
In-Reply-To: <2375c9f90811150922x21e41faevcd7f1e9af45426e3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang wrote:
> On Sat, Nov 15, 2008 at 3:28 AM, Hiroshi Shimamoto
> <h-shimamoto@ct.jp.nec.com> wrote:
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> Impact: cleanup
>>
>> No need to use temporary variable.
>> Also rename the variable same as kernel/signal_32.c.
> 
> 
> I think you mean arch/x86/kernel/signal_32.c, of course. :-)

Yep, it should be. I didn't keep correctness, sorry.

thanks,
Hiroshi Shimamoto

> 
>> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Reviewed-by: WANG Cong <wangcong@zeuux.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

