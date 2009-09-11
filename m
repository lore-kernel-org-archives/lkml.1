Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbZIKMiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbZIKMiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 08:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZIKMiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 08:38:06 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55050 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZIKMiF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 08:38:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uiZAPAdDpDgK5aNEaxuIlMaGG3r+86OhSI3tOzeNrqXqfI5+9iFH32eCg0sdKgiYXL
         k7iyWn+pk1sRSCzonCp/senD1xM9r6HxL9h1/2aitmxfGsj4PzGMsHLh+FNtG+v/7Put
         0oalaV5nFi3JnOVgLAFf1ZUK+RM7V63tnp7VU=
MIME-Version: 1.0
Reply-To: q-funk@iki.fi
In-Reply-To: <20090818045048.GC11624@1wt.eu>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera> <200908131654.45227.rjw@sisk.pl>
	 <11fae7c70908130800q7b4a5293t5c373613d736d74@mail.gmail.com>
	 <200908132034.34951.rjw@sisk.pl>
	 <11fae7c70908161217p33830075p783880315a31b2e5@mail.gmail.com>
	 <20090816205706.GB3463@elte.hu>
	 <11fae7c70908161412v61fd233au5166e18f4c4d0931@mail.gmail.com>
	 <20090816213407.GA30245@elte.hu>
	 <11fae7c70908171402y18699abbs7a293fe9ff562388@mail.gmail.com>
	 <20090818045048.GC11624@1wt.eu>
Date: Fri, 11 Sep 2009 15:31:56 +0300
X-Google-Sender-Auth: c42337cab8a9c829
Message-ID: <11fae7c70909110531w6eecc0c9w7df8f24929384226@mail.gmail.com>
Subject: Re: [Bug #13941] x86 Geode issue
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <q-funk@iki.fi>
To: Willy Tarreau <w@1wt.eu>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/18 Willy Tarreau <w@1wt.eu>:
> On Tue, Aug 18, 2009 at 12:02:34AM +0300, Martin-Éric Racine wrote:
> (...)
>> > it's still a JPG - posting the transcribed oops in email text would
>> > certainly help more folks looking over it.
>> >
>> > (painful i know ...)
>>
>> I welcome suggestions for proper OCR software that can extract the
>> text displayed therein. Manually transcribing it is too error-prone to
>> even try.
>
> Well, there are less risks of errors retyping by hand than passing via
> an OCR. At least *you* know that everything you see are hex numbers, the
> OCR does not. Eventhough it's quite annoying to do that by hand, it
> generally takes less than 5 minutes to retype an oops, which is not that
> much. Of course, the serial cable to another machine to get a panic dump
> is the easiest solution ;-)

That would be assuming that a serial console is available.  This is
not the case here. No legacy port whatsoever.

Martin-Éric
