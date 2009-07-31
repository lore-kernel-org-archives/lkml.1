Return-Path: <linux-kernel-owner+w=401wt.eu-S1751300AbZGaNg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbZGaNg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 09:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbZGaNgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 09:36:25 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:26987 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbZGaNgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 09:36:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EiDSppPp8VSwQvsF6f1zanLei5fdWyGCEiFGlJZ3u6KHjefDgAy5Vf3UJkLwV9Jkxv
         JnJehlJo9etpebNA+qSkSsyUbCWygNv/3GaGvy3mZa+2V+KYs+N28U3ho1aq2CWDS+Rl
         7v03NrsvYDeY7zr3aQ85TMg9Pib+Od3U4rBH4=
MIME-Version: 1.0
In-Reply-To: <812689.20578.qm@web37604.mail.mud.yahoo.com>
References: <812689.20578.qm@web37604.mail.mud.yahoo.com>
Date: Fri, 31 Jul 2009 16:36:24 +0300
Message-ID: <6d1efe520907310636g3c8fab76vc495169326fe77f1@mail.gmail.com>
Subject: Re: New MMC maintainer needed
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-embedded@vger.kernel.org,
       Nicolas Pitre <nico@cam.org>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
       manuel.lauss@gmail.com, mirq-linux@rere.qmqm.pl,
       Pavel Pisa <ppisa@pikron.com>,
       Jarkko Lavinen <jarkko.lavinen@nokia.com>, Ben Dooks <ben@fluff.org>,
       saschasommer@freenet.de, avorontsov@ru.mvista.com, ian@mnementh.co.uk,
       HaraldWelte@viatech.com, JosephChan@via.com.tw,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Pierre Ossman <pierre@ossman.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 7:59 AM, Alex Dubov<oakad@yahoo.com> wrote:
>
>> I'm afraid the time has come for me
>> to step down as maintainer for the
>> MMC/SD/SDIO subsystem and for someone else to take over the
>> rudder. It
>> is no secret that I haven't been able to give the
>> maintainer role the
>> resources it required, and as a result it has gone from
>> being a fun
>> hobby to a burdensome chore. I was hoping it was a
>> temporary slump, but
>> this has been the norm for over a year now, so it's time
>> for me to
>> throw in the towel.
>
> What an unfortunate thing.
>
> Franky speaking, I couldn't manage any time to work on Linux
> in the last year myself. I had such a great plans for Memstick
> and such, yet none advanced.
>
> At this rate, the future of the flash cards on Linux will
> become highly uncertain.
> :-(
>

Me too.

I had plans to reverse engineer and then write drivers for my ricoh 5
in one controller
for SD and memstick mode (especialy XD)
Now I know that RE part isn't the hardest probably, but writing the
core support for XD subsystem (your was rejected I see)

I am also an owner of a jmicron controller, and thanks to you memstick
on it is supported.

What to do now?

Best regards,
         Maxim Levitsky
