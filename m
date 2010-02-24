Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab0BXEb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 23:31:27 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49408 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab0BXEb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 23:31:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KdG2XvB9m/uWINsNiuyuHbmSBDKb1h29BM7erseAG1KIRs+LSs0I1V7FWn3lvuntej
         mzmkACtF1YSp2ZpyR+O+uc0Ncc9dWV8qTgwi7TcB9/xTqHAEysTCHBJwk5cVgurmHL8M
         Qzsuch5unbgjveEpzLsuWLO28BGpgH4kT8Olc=
MIME-Version: 1.0
In-Reply-To: <20100223130128.GB30382@aftab>
References: <22dbbef21002222241h711402f1me6b60ac7502cccd4@mail.gmail.com>
	 <22dbbef21002222243s7afb8e2cy1c783a29fe22ac55@mail.gmail.com>
	 <20100223065953.GB32503@liondog.tnic>
	 <22dbbef21002222331o6a59dc25mea3fc7e62dae6710@mail.gmail.com>
	 <20100223095025.GA18559@liondog.tnic>
	 <22dbbef21002230337i104c63dcm5d59064ca48a07f0@mail.gmail.com>
	 <20100223130128.GB30382@aftab>
Date: Wed, 24 Feb 2010 09:53:35 +0530
Message-ID: <22dbbef21002232023u59025f44oc4cfc89b03150880@mail.gmail.com>
Subject: Re: QUERY: Inclusion of header files in kernel header files
From: viresh kumar <viresh.linux@gmail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Borislav Petkov <petkovbb@googlemail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just to make sure: with "I'd" I meant "I would", i.e. actually _you_
> could send a patch fixing that by explaining the problem in the commit
> message :).
>

Yes boris, i will do that if everybody agrees.

>> Actually this issue is not present only in bus.h, but some other
>> kernel header files.
>> Like: arch/arm/include/asm/clkdev.h don't include list.h file but
>> using struct list_head
>>

> Well, you should talk to the arm maintainer about that task and whether
> it is desirable.

i will float a patch for the same in linux-arm mailing list.

viresh.
