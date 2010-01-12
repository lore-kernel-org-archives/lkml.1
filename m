Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008Ab0ALPA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab0ALPA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 10:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924Ab0ALPA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 10:00:59 -0500
Received: from mail-qy0-f185.google.com ([209.85.221.185]:43584 "EHLO
	mail-qy0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab0ALPA6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 10:00:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZQKDNY87MbS/gWmiXoL++8XTFAqkNaoWoP6F1GhyLO/TWuXQSsFFFAdbNOFvobJ6Tv
         WJLUvqyg/WJGk083tsdKXEuB4A7RymUwbliRP/o/PMSbT0AHX0HKLxXG0lLdd9tXAUjS
         UvOkYe7yM8pD8/M/HWYL6S7bZD1Np4v2PJD+A=
MIME-Version: 1.0
In-Reply-To: <1263308127.4244.142.camel@laptop>
References: <4B4C3E4F.9060001@memeplex.com> <20100112145213.GB3925@hack>
	 <1263308127.4244.142.camel@laptop>
Date: Tue, 12 Jan 2010 23:00:57 +0800
Message-ID: <2375c9f91001120700r4c2e1e05l5e5be3ddc6a13da2@mail.gmail.com>
Subject: Re: Futex hang/lockup problem in 2.6.30+ on AMD64
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Athan <linux_kernel_aathan@memeplex.com>,
       linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Gong Cheng <chengg11@yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 10:55 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-01-12 at 22:52 +0800, Américo Wang wrote:
>
>> > $ uname -a
>> > Linux UK22 2.6.30-2-amd64 #1 SMP Fri Sep 25 22:16:56 UTC 2009 x86_64
>> > GNU/Linux
>
> Does a recent kernel work?
>
>

Ah, I just wanted to ask the same question, adding the original reporter
Gong Cheng into Cc...

Gong, could you reproduce it on the latest kernel? And what is your .config?

Thanks!
