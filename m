Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917AbZC2JCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbZC2JCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 05:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbZC2JCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 05:02:24 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:45144 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbZC2JCX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 05:02:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=d+GlCNWt0g368XgJ/pvz7oXj718tBt3iRfOcnrzMq81lw+KVipBjvwMjhOWZ+WKWw9
         aIeiZitvff5ceXmtKXHtt4m/BahuvmtY8eVZGxQEgHdsc+W7Vkf4tE7QvXWorUlewHZr
         jiNtXQbGG/zSFNfAPTaFV6XVSfpPyl++FMClI=
MIME-Version: 1.0
In-Reply-To: <200903281727.52929.rob@landley.net>
References: <20090323180808.2c2ef1a7@nehalam>
	 <49C847C6.4030904@lougher.demon.co.uk>
	 <200903281727.52929.rob@landley.net>
Date: Sun, 29 Mar 2009 11:02:19 +0200
X-Google-Sender-Auth: 64928cd556a2d7d0
Message-ID: <10f740e80903290202h1f36b370ga39721536d52a90@mail.gmail.com>
Subject: Re: Squashfs 4.0 tools
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Landley <rob@landley.net>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org,
       squashfs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 00:27, Rob Landley <rob@landley.net> wrote:
> P.S I notice a squashfs-devel mailing list cc'd here, but there's no link to
> it from the squashfs.org page.  Buried in the middle of a lot of text is a
> link to the sourceforge squashfs project page, which has a link to "forums"
> which are not the same as mailing lists.

There should be a link to it somewhere on the SF project page...

> But it might be nice to at least _hint_ about its existence on the web page.
> The main page's "contact" section is your personal email and nothing else...

Yep. Fortunately we also have MAINTAINERS ;-)

| SQUASHFS FILE SYSTEM
| P:      Phillip Lougher
| M:      phillip@lougher.demon.co.uk
| L:      squashfs-devel@lists.sourceforge.net (subscribers-only)
| W:      http://squashfs.org.uk
| S:      Maintained

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
