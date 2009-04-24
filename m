Return-Path: <linux-kernel-owner+w=401wt.eu-S1754938AbZDXHDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbZDXHDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 03:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbZDXHDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 03:03:09 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:40364 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbZDXHDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 03:03:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=I/PaiUy2NwZ6jjO20MMv5l34QFuuMmgTkvOuznVGbypqY5EVzHnNJuPcFEk8ZZ0WMX
         j4y692V4qSw0KLyoRl2gwWdCHi0U17DQVKldcpRx4uqGltpvRHChWKMFiBVEp3UNHBd/
         LW41DNRJriUnzvrTbxf0c9sg9Kyb5GnV05MQQ=
MIME-Version: 1.0
In-Reply-To: <20090423193211.GA14892@redhat.com>
References: <20090423193211.GA14892@redhat.com>
Date: Fri, 24 Apr 2009 09:03:05 +0200
X-Google-Sender-Auth: 7ffea0947bf9464c
Message-ID: <10f740e80904240003r33606875sc477ea2282f628d2@mail.gmail.com>
Subject: Re: [PATCH 3/4] ptrace: remove PT_DTRACE from m68k, m68knommu
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Chris Zankel <chris@zankel.net>,
       David Howells <dhowells@redhat.com>, Greg Ungerer <gerg@uclinux.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Helge Deller <deller@gmx.de>, Hirokazu Takata <takata@linux-m32r.org>,
       Jeff Dike <jdike@addtoit.com>, Kyle McMartin <kyle@mcmartin.ca>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 21:32, Oleg Nesterov <oleg@redhat.com> wrote:
> m68k sets PT_DTRACE in trap_c() but never uses it.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
