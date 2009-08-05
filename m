Return-Path: <linux-kernel-owner+w=401wt.eu-S933931AbZHEJRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931AbZHEJRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 05:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933894AbZHEJRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 05:17:08 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:65502 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933810AbZHEJRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 05:17:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=C5D1BSTDChY4KJmeniLtLD9a1M4kGSxuotiqINWV1+MDmMJV4JyoiEDs6RhCW5B889
         v+PlUR0rLoE7SFYfjRt6zz5OkKxz6CoVokBW/qRHasxYeDVc4i7wmuhToEyjN+dGnKSo
         57MfTYYjO/DwtCLK2hTLNSq3usc5txtA7Z+4I=
MIME-Version: 1.0
In-Reply-To: <20090804151838.c5cb362b.akpm@linux-foundation.org>
References: <4A76D4DA.8090905@gmail.com>
	 <20090804151838.c5cb362b.akpm@linux-foundation.org>
Date: Wed, 5 Aug 2009 11:17:05 +0200
X-Google-Sender-Auth: f6487e437ca064cf
Message-ID: <10f740e80908050217i3e207bdct54460103e171c9ae@mail.gmail.com>
Subject: Re: [PATCH] serial167: Read buffer overflow
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roel Kluin <roel.kluin@gmail.com>, alan@redhat.com,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 5, 2009 at 00:18, Andrew Morton<akpm@linux-foundation.org> wrote:
> btw, m68k allmodconfig in current mainline is sick:
>
> And in linux-next m68k allmodconfig is dead as a doornail:

Will look at it (eventually)...

But recovering from a too-long absence and replacing the computer that
died before the absence
while keeping the mill of life running take its time...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
