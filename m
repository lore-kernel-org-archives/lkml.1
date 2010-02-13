Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab0BMJQV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 04:16:21 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:55952 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab0BMJQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 04:16:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=SdmWftPvvoA2LuLALWCGmuiCO8KqlX3+LdISy5vnKlrCQ3pqEb4yZFnJvplSi2hwFq
         OFBfx4mM2X1GELP6WF0ASZh6m+EU81e1GF8epdwjFgPJstkWKeHqA36NOG1gCBjdcEYp
         Wo7akJUHZf/XepAIL5n1zeAOQTeU4U3yHkQEc=
MIME-Version: 1.0
In-Reply-To: <20100213092433.93a1e8d5.sfr@canb.auug.org.au>
References: <alpine.LFD.2.00.1002121142100.3922@localhost.localdomain>
	 <20100213092433.93a1e8d5.sfr@canb.auug.org.au>
Date: Sat, 13 Feb 2010 10:16:16 +0100
X-Google-Sender-Auth: f7801574b0ba9d50
Message-ID: <10f740e81002130116j36bf1d5fv977616f4662c1009@mail.gmail.com>
Subject: Re: Linux 2.6.33-rc8
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 23:24, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Fri, 12 Feb 2010 11:49:33 -0800 (PST) Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>> I think this is going to be the last -rc of the series, so please do test
>> it out. A number of regressions should be fixed, and while the regression
>> list doesn't make me _happy_, we didn't have the kind of nasty things that
>> went on before -rc7 and made me worried.
>
> Well, if http://neuling.org/linux-next-linus.png is anything to go by, we
> should be having a very quiet 2.6.34 merge window, so there will be lots
> of time for fixing any left over mess. :-)

Interestingly, there's also a dip around 2.6.27, which was chosen as a
longer term stable release...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
