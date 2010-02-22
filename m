Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab0BVJVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 04:21:13 -0500
Received: from mail-qy0-f175.google.com ([209.85.221.175]:59252 "EHLO
	mail-qy0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab0BVJVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 04:21:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TInP75Xz+OdxKr6V7cQGHWP1brAU+UGpAmudHn/Fq2v6LGB+HOSaHsablF1l7VwtR2
         Cy+YP+hTlRw/V1NXmKd5rv/4CzrqKxMOzJ60cBbMeoQXIf51A5OdILk2r7HWlOVvYQmj
         IcnsrVLP/CzV/wooLwxxcuDvxCFvUnVnY9wSg=
MIME-Version: 1.0
In-Reply-To: <1266830051.5609.6.camel@jlt3.sipsolutions.net>
References: <1264740107.20211.53.camel@pasglop>
	 <1266749023.5468.1.camel@jlt3.sipsolutions.net>
	 <7b6bb4a51002210255t5ceaeb84r1438461085446385@mail.gmail.com>
	 <7b6bb4a51002210312o2a1d070aneb54c107aeab6952@mail.gmail.com>
	 <1266750881.10419.1.camel@jlt3.sipsolutions.net>
	 <1266751349.10419.2.camel@jlt3.sipsolutions.net>
	 <2375c9f91002220034m1beec51co7385a1cdbbcce7d2@mail.gmail.com>
	 <1266829490.5609.0.camel@jlt3.sipsolutions.net>
	 <2375c9f91002220112q351044a4ycf4ee7dc2630c16d@mail.gmail.com>
	 <1266830051.5609.6.camel@jlt3.sipsolutions.net>
Date: Mon, 22 Feb 2010 17:21:10 +0800
Message-ID: <2375c9f91002220121o62426f07kd5a3eae128b7489f@mail.gmail.com>
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Xiaotian Feng <xtfeng@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 5:14 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2010-02-22 at 17:12 +0800, Américo Wang wrote:
>> Before other experts look at this, I think doing a bisect would be
>> very useful.
>
> I was afraid you'd say that, it'll take forever though since I need to
> walk over to it after every shutdown, see if it turned off and then turn
> it on again (and possibly off).... I guess I'll get started on that.
>

No problem.

Feel free to wait for the experts like Linus taking this. Leave as it is. ;)

Thanks.
