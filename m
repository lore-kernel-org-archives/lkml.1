Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab0CNOeL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 10:34:11 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:45213 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab0CNOeG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 10:34:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mSDVil9xWHCgM1NwTDGfYs+7D5tkRs84ynVntVHBgGp3JsIvCotcN5pDaVkpp2teAp
         +GGl+VU8rqtuD4+wkzeZJCXKD3JPqpXPC/vQ7SA1abwpj0m/C6cuYGZv3zKVPowhHxNC
         3IynlCW9k1+vhI0vVe2XSvGed4LEgTa1OF71w=
MIME-Version: 1.0
In-Reply-To: <20100313.181754.107699673.davem@davemloft.net>
References: <20100313.181754.107699673.davem@davemloft.net>
Date: Sun, 14 Mar 2010 15:34:03 +0100
X-Google-Sender-Auth: 1fbcafb88ab62d7d
Message-ID: <10f740e81003140734p30959952ld4563d2b22d834af@mail.gmail.com>
Subject: Re: [GIT]: Sparc
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sun, Mar 14, 2010 at 03:17, David Miller <davem@davemloft.net> wrote:
> David S. Miller (1):
>      sparc64: Add very basic XVR-1000 framebuffer driver.

Have you ever looked into getting offb to work on sparc64?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
