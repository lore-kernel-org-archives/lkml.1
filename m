Return-Path: <linux-kernel-owner+w=401wt.eu-S1751042AbXDHMcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042AbXDHMcP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 08:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbXDHMcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 08:32:15 -0400
Received: from ping.uio.no ([129.240.78.2]:41597 "EHLO ping.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbXDHMcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 08:32:15 -0400
From: ilmari@ilmari.org (Dagfinn Ilmari =?utf-8?Q?Manns=C3=A5ker?=)
To: Pavel Machek <pavel@ucw.cz>
Cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
       MarekVa@ucw.cz
Subject: Re: [PATCH 29/90] ARM: OMAP: Palm Tungsten|T support
Organization: Program-, Informasjons- og Nettverksteknologisk Gruppe, UiO
References: <11757100214151-git-send-email-tony@atomide.com>
	<11757100242980-git-send-email-tony@atomide.com>
	<1175710026446-git-send-email-tony@atomide.com>
	<11757100281957-git-send-email-tony@atomide.com>
	<11757100302964-git-send-email-tony@atomide.com>
	<1175710033286-git-send-email-tony@atomide.com>
	<117!57100403021-git-send-email-tony@atomide.com>
	<11757100423982-git-send-email-tony@atomide.com>
	<20070406120923.GB3866@ucw.cz>
	<20070408120740.GC5431@flint.arm.linux.org.uk>
	<20070408121238.GB4310@ucw.cz>
Mail-Copies-To: nobody
Date: Sun, 08 Apr 2007 13:31:58 +0100
In-Reply-To: <20070408121238.GB4310@ucw.cz> (Pavel Machek's message of "Sun, 8
	Apr 2007 12:12:39 +0000")
Message-ID: <d8jslbbujwh.fsf@nygaard.ping.uio.no>
User-Agent: Gnus/5.110004 (No Gnus v0.4) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Exiscan-Spam-Score: -7.8 (-------)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> Hi!
>
>> > > From: =?utf-8?q?Marek_Va=C5=A1ut?= <marek.vasut@gmail.com>
>> > 
>> > EEk.
>> > 
>> > > Signed-off-by: Marek Vašut <marek.vasut@gmail.com>
>> > 
>> > Eek2.
>> 
>> As I see it, that eek2 is correct UTF-8, and since the body charset was
>> utf-8 I don't see this as a problem.
>
> I do not think eek2 is correct utf-8. It seems to short for that. (It
> should be s with v over it.

It is correct. From the original raw message:

| Content-Type: text/plain; charset=UTF-8
| Content-Transfer-Encoding: quoted-printable
[…]
| Signed-off-by: Marek Va=C5=A1ut <marek.vasut@gmail.com>

0xC5 0xA1 is an UTF-8-encoded U+0161 LATIN SMALL LETTER S WITH CARON.

-- 
ilmari
"A disappointingly low fraction of the human race is,
 at any given time, on fire." - Stig Sandbeck Mathisen
