Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab0APIq0 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 03:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304Ab0APIqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 03:46:25 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:65196 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab0APIqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 03:46:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=SVaYEc95uRjH/lCIdRNOx0SYJHs21Dv0s7BnuJFQEQ+QMlN2tQWEJIW8S12nbDU5Rr
         X+yCquuKGV1sa2lZCdcNokDjzl2tj5wbUbSPIjuUQnB+X5eULWiKoXaP7zuuTew2dVVu
         8dk+tYMtouU7T3hAKQHQX6hJxIqMztiEIm8U0=
MIME-Version: 1.0
In-Reply-To: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl>
References: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl>
Date: Sat, 16 Jan 2010 09:46:23 +0100
X-Google-Sender-Auth: c131d5ea19eb5623
Message-ID: <10f740e81001160046j401371caye170124439ff7b79@mail.gmail.com>
Subject: Re: Ubuntu 32-bit, 32-bit PAE, 64-bit Kernel Benchmarks
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Yuhong Bao <yuhongbao_386@hotmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 02:29, Yuhong Bao <yuhongbao_386@hotmail.com> wrote:
> Given that Linus was once talking about the performance penalties of PAE and HIGHMEM64G, perhaps you'd find these benchmarks done by Phoronix of interest:
> http://www.phoronix.com/scan.php?page=article&item=ubuntu_32_pae

Does anyone have (links to) compile benchmarks? Thx!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
