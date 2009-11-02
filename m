Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbZKBRTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbZKBRTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:19:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZKBRTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:19:03 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:53753 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbZKBRTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:19:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Jku3nVeHM1jLPg0c3o2KrqMeRulDtitMfGqTV35z2ASfGvfh7pTQovG41HYPbn4OST
         RFm3XZwy4KKzxBLpWhGR2WdEpLzpNqVwV+bCqIttbxE1dNR23uOn1vw0EUs08RY6w24M
         VAZyJhtULpbaCEwq1E12P0qwS6saqy0PcDoZk=
MIME-Version: 1.0
In-Reply-To: <20091102164621.GF30802@alberich.amd.com>
References: <1257114179.6833.47.camel@dimm>
	 <20091102164621.GF30802@alberich.amd.com>
Date: Mon, 2 Nov 2009 18:19:05 +0100
Message-ID: <b647ffbd0911020919s5e986ch521584a8f5e76e33@mail.gmail.com>
Subject: Re: [ RFC, PATCH - 1/2 ] x86-microcode: refactor microcode output 
	messages
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>, Andreas Mohr <andi@lisas.de>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/2 Andreas Herrmann <herrmann.der.user@googlemail.com>:
> On Sun, Nov 01, 2009 at 11:22:59PM +0100, dimm wrote:
>>
>> Hi,
>>
>>
>> this is in response to Mike's patch "Limit the number of microcode
>> messages".
>>
>> What's about the following (yet preliminary and not thoroughly tested)
>> approach?
>
> Hmm, patch-1 doesn't apply:
>
>  patching file arch/x86/include/asm/microcode.h
>  patching file arch/x86/kernel/microcode_amd.c
>  Hunk #1 succeeded at 152 (offset -4 lines).
>  Hunk #2 succeeded at 240 (offset -7 lines).
>  patch: **** malformed patch at line 99: size_t size)

Hmm, maybe my mailer has got it inlined wrongly... whatever, sorry for
that, I'll resend the patches later today.

> [ ... ]
>
> I'd like to test it but would need patches that do apply ...

Great, I'll send the patches later today.


>
> Thanks,
> Andreas
>

-- 

-- Dmitry
