Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbZLSImX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbZLSImX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 03:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbZLSImW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 03:42:22 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:50690 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbZLSImV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 03:42:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=obqiJ5wgt0yKzI1C99KPzwweJWRFMJ6BuYnNDb9jSsA4RMHIR0xL/QmsVQveFIDRHk
         +uZdOlrumSCo8DA9GJjd4aC9cNnEGs3fE/CGK0fLDWUH8qMefS4QS/s+LZDjPULjOqYr
         CuBH3Dwgu/n2CTbkPeL7Fr36hkSGaI1h4cykA=
MIME-Version: 1.0
In-Reply-To: <20091219110457.d6c5de1f.sfr@canb.auug.org.au>
References: <20091219110457.d6c5de1f.sfr@canb.auug.org.au>
Date: Sat, 19 Dec 2009 09:42:19 +0100
X-Google-Sender-Auth: a00843ff25e1aaa5
Message-ID: <10f740e80912190042o474b6188ga32fcc4ff0846531@mail.gmail.com>
Subject: Re: linux-next: Tree for December 19
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 19, 2009 at 01:04, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> I said:
>> News:  there will be no linux-next releases until at least Dec 24 and,
>> more likely, Dec 29.  Have a Merry Christmas and take a break.  :-)
>
> Well, I decided I had time for one more so it will be based in -rc1).

Hurray!

But http://kisskb.ellerman.id.au/kisskb/buildresult/1852835/ shows
linux-next/m68k-allmodconfig fails
in security/keys/keyctl.c, while this got fixed in 2.6.33-rc1?? It
compiled fine in linus/m68k-allmodconfig,
as expected

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
