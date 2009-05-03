Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbZECLSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbZECLSI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 07:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZECLRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 07:17:54 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:40712 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbZECLRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 07:17:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YrWWq3GJ0H8Y+fkj/AlZK7oz/MR7RROUGnB4rvsNhvvdMH4T86M7Df4h0Q5z7Ek/2W
         rDTZHOYKYhZ6/HY0aFc6vQpnvGK2Wwf846zlU0ex/qpUrnFTBeduomrOb/IxAAVUDLZS
         iJk/9rtbad1YnvOL0HLRsgm89+8BdPi30bPZ0=
MIME-Version: 1.0
In-Reply-To: <cover.1241105648.git.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
Date: Sun, 3 May 2009 13:17:52 +0200
Message-ID: <10f740e80905030417m3b67da38uecd6bd008b4c7e3f@mail.gmail.com>
Subject: Re: [PATCH 00/27] more non-ABI asm-generic headers
From: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 17:34, Arnd Bergmann <arnd@arndb.de> wrote:
> To avoid trouble with quilt mail, I'm now trying
> git-format-patch to generate them, hopefully this
> works a little better. Can anyone tell me why I can't
> add a 'To' header rather than just 'Cc' in
> git-format-patch?

I always specify the --to with git send-email.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
