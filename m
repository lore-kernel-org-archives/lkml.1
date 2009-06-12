Return-Path: <linux-kernel-owner+w=401wt.eu-S1760003AbZFLGWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbZFLGWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 02:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbZFLGWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 02:22:24 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:57431 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbZFLGWX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 02:22:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J3hyYC4YwFYcoJ+FWKUn4tLeojK891Io1D+QyG4jIfLZV7EUCkk1XlyJ4gX3n0icaN
         21Ts8SvgnF9feXJNxB5kbnHqV4CDz+jf7jJ3jZvnvfnsH/zA4ZWSMX6H0tx6hxKIaXbP
         ddW+2feWNK0Fm7H4WZ2TJejUFCZ9bGqaQGF2g=
MIME-Version: 1.0
In-Reply-To: <200906120114.n5C1EYNj009715@localhost.localdomain>
References: <200906120114.n5C1EYNj009715@localhost.localdomain>
Date: Fri, 12 Jun 2009 08:22:24 +0200
Message-ID: <10f740e80906112322k11a518dj3d059b19c086e0c6@mail.gmail.com>
Subject: Re: [git pull] m68knommu arch fixes
From: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: torvalds@linux-foundation.org, gerg@uclinux.org,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 03:14, Greg Ungerer<gerg@snapgear.com> wrote:
> Please pull to get fixes for the m68knommu arch.

> Jaswinder Singh Rajput (1):
>      headers_check fix: m68k, swab.h

Thanks!

Probably I won't have time to handle and submit any m68k patches
during this merge window,
so if anyone needs anything to be in 2.6.31, it would be nice if
somebody else could take care of
it.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
