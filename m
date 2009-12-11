Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbZLKN62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbZLKN62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757724AbZLKN6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:58:24 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:2724 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295AbZLKN6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:58:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=fQeVRGilU+ESIeBZxyF+brEZaRcLo3ZGf4q/kc6Zr+Ie2YX7aWV2NFMYOqgjfwbIjl
         R3h2MUPwYDliQb8ecWIqt3tteKard5nwYnPS/RZJR+IYiVXQ9TEyFWXIsVFjYduev3Ha
         NIyU/1P+4G1qCIBF6SyECQXVCv+825G6cVuHc=
MIME-Version: 1.0
In-Reply-To: <200912111406.33424.arnd@arndb.de>
References: <OF24184D8B.2F7F8AA9-ON48257685.002069EF-48257685.00207E45@sunplusct.com>
	 <200912102225.05280.arnd@arndb.de>
	 <10f740e80912110454u172fc2cfye30da6ca0e0f0af0@mail.gmail.com>
	 <200912111406.33424.arnd@arndb.de>
Date: Fri, 11 Dec 2009 14:58:28 +0100
X-Google-Sender-Auth: 3db43c2a04d048cd
Message-ID: <10f740e80912110558g6c453d18ifeb4e02d5bd51973@mail.gmail.com>
Subject: Re: What's in asm-generic.git
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mike Frysinger <vapier.adi@gmail.com>, liqin.chen@sunplusct.com,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 14:06, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 11 December 2009, Geert Uytterhoeven wrote:
>> 10+ architectures already have sys_[sg]et_thread_area of have reserved
>> entries for it.
>
> No, those are just the ones that blindly copied the unistd.h file from i386.
> As I said, only i386 and mips implement it, and I would assume that this
> is unlikely to change.

M68k will have it in the near future...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
