Return-Path: <linux-kernel-owner+w=401wt.eu-S1765899AbZAOOsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765899AbZAOOsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 09:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762753AbZAOOrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 09:47:25 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:17137 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762958AbZAOOrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 09:47:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=seMGOwxlXVfiPq7FH/vm+UER3ziP/ZFbvbU8TeuXJSdkJjP/KgxJBhshmZY/1mP8W+
         draWNoAk/PsiWaIxgyRS8xyht5nBlKZPbHhnz1IRd7tS0xFgFHoqPhRp8YovaZeN1rPZ
         j1ZDm02ZntkFB15Fukqm8cYrUFooYBw37On1s=
MIME-Version: 1.0
In-Reply-To: <20090115143717.GA11991@uranus.ravnborg.org>
References: <1231836016.3212.41.camel@jaswinder.satnam>
	 <Pine.LNX.4.64.0901140954250.27308@anakin>
	 <3f9a31f40901140129i1389f47frf32808f3a695a118@mail.gmail.com>
	 <20090114153825.GB32082@uranus.ravnborg.org>
	 <3f9a31f40901140759s1542e6cclae1808b796c2b1a9@mail.gmail.com>
	 <Pine.LNX.4.64.0901141732450.26663@anakin>
	 <20090114201513.GC1556@uranus.ravnborg.org>
	 <20090115111134.GB22850@elte.hu>
	 <20090115143717.GA11991@uranus.ravnborg.org>
Date: Thu, 15 Jan 2009 20:17:22 +0530
Message-ID: <3f9a31f40901150647n7ef5b2dfuf5c588f584c2a472@mail.gmail.com>
Subject: Re: [PULL -tip] fixed few make headers_check warnings
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Jaswinder Singh Rajput <jaswinder@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam,

On Thu, Jan 15, 2009 at 8:07 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>
> I can disable the warnings around -rc7 if we think they are too noisy
> when we release the next kernel.
>

I will like to question the approach how you get this number '-rc7'

Do you think people can bear this noise till -rc7 or they will solve
all these warnings before -rc7

--
JSR
