Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab0BTJGo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 04:06:44 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:61346 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab0BTJGl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 04:06:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sZuPAFllq+I3aaY8z8/S8c2CdVQUNjYDcGPoEVs2EfDuNTmbaU40eYEtMguc7phEki
         FYCzlQiT/uFin+Nh/+GQZoy92vyGPa9x0lTiDw3KSB/HYqkW9NXmdkSdEC2uxNAeQiuF
         d3f+kK1o5sg6ifC5SVmQNtuKgbPLZxF0RkWdU=
MIME-Version: 1.0
In-Reply-To: <1266656213.5347.0.camel@jlt3.sipsolutions.net>
References: <1264740107.20211.53.camel@pasglop>
	 <1266485775.6539.6.camel@jlt3.sipsolutions.net>
	 <alpine.LFD.2.00.1002180825000.4141@localhost.localdomain>
	 <1266518735.3829.4.camel@jlt3.sipsolutions.net>
	 <2375c9f91002192313j3fb84acje4c286c4f86457f3@mail.gmail.com>
	 <1266656213.5347.0.camel@jlt3.sipsolutions.net>
Date: Sat, 20 Feb 2010 17:06:39 +0800
Message-ID: <2375c9f91002200106j56b0298ds1a425fde8983d988@mail.gmail.com>
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 20, 2010 at 4:56 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2010-02-20 at 15:13 +0800, Américo Wang wrote:
>
>> Does my following untested patch help?
>
> Sorry, no. I'll hook up a screen to the box after I return from the
> fresh market.
>

Are you sure there is no difference? :-/

Also, could you please also apply the 4 patches from Eric?

You can get them here:
http://lkml.org/lkml/2010/2/11/334

Thanks much for your testing!
