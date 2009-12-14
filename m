Return-Path: <linux-kernel-owner+w=401wt.eu-S1758695AbZLNWHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbZLNWHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758656AbZLNWHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:07:33 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:45810 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758593AbZLNWHZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:07:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ia45aR9rcrwCRMf4rCrxx0QvXGt1VV8rSZnwO8aG3nEyXq01FFPlwwHZZQ1A8t+cQl
         IElc0oyLnJ0X1CiSS3tagG1hONZ3pOhI09GLovrZOEErHWFIMhfZHCReuMPK4XpufCIR
         zYpkISPb4n8JBiOckcLs/nIoys9WmhkN2IRd4=
MIME-Version: 1.0
In-Reply-To: <200912141253.42017.arnd@arndb.de>
References: <20091205.193505.193701079.davem@davemloft.net>
	 <20091213.202037.229738549.davem@davemloft.net>
	 <d45a3acc0912132026w5ab6b3b3x3f211566779257d3@mail.gmail.com>
	 <200912141253.42017.arnd@arndb.de>
Date: Tue, 15 Dec 2009 09:07:23 +1100
Message-ID: <d45a3acc0912141407s23cdbc1cw8d5dfdbc0e1b556a@mail.gmail.com>
Subject: Re: [GIT]: Networking
From: andrew hendry <andrew.hendry@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Henner Eisen <eis@baty.hanse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That works for me. I have access to some X.25 networks for testing and
keep an eye on the mailing lists.

Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>

On Mon, Dec 14, 2009 at 10:53 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 14 December 2009, andrew hendry wrote:
>> Thanks, I didn't know X.25 was actively maintained. I get bounces.
>> Is the the maintainers out of date?
>
> From looking at the posts on the x.25 mailing list and the changes
> that went into the kernel during the last three years in that area,
> I think it is safe to say that you are now the maintainer ;-).
>
> The last mail on this topic from Henner Eisen was around 2001.
>
>> AX.25 NETWORK LAYER
>> M:      Ralf Baechle <ralf@linux-mips.org>
>>
>> X.25 NETWORK LAYER
>> M:      Henner Eisen <eis@baty.hanse.de>
>
> How about this change?
>
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5839,9 +5839,9 @@ F:        sound/soc/codecs/wm8350.c
>  F:     sound/soc/codecs/wm8400.c
>
>  X.25 NETWORK LAYER
> -M:     Henner Eisen <eis@baty.hanse.de>
> +M:     Andrew Hendry <andrew.hendry@gmail.com>
>  L:     linux-x25@vger.kernel.org
> -S:     Maintained
> +S:     Odd Fixes
>  F:     Documentation/networking/x25*
>  F:     include/net/x25*
>  F:     net/x25/
>
