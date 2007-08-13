Return-Path: <linux-kernel-owner+w=401wt.eu-S1762498AbXHMTeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762498AbXHMTeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 15:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938767AbXHMTdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 15:33:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:29601 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934777AbXHMTdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 15:33:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ErMK2Jpybb7P24JEBsfex9HsOw7PEoZcOi9A0EcfQm//7cc3MuKC4goBXwQHaRJ1EXFhp7C7awXHJy04KcveHAS7WLGWnF6zXHwLv8fmuxO8cECILQcUJ92lUH+uhrgMPWK91/Gw4O92YfJev15zYaK743Sf11zvn4djDShMe4Q=
Message-ID: <46C0B235.1030302@gmail.com>
Date: Mon, 13 Aug 2007 21:34:13 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: joe@perches.com
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [324/2many] MAINTAINERS - MOXA SMARTIO/INDUSTIO SERIAL
 CARD (MXSER 2.0)
References: <46bffaed.zgG/64zMGWFNDCEO%joe@perches.com>
In-Reply-To: <46bffaed.zgG/64zMGWFNDCEO%joe@perches.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

joe@perches.com napsal(a):
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 451735d..3404f8a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3114,6 +3114,9 @@ P:	Jiri Slaby
>  M:	jirislaby@gmail.com
>  L:	linux-kernel@vger.kernel.org
>  S:	Maintained
> +F:	Documentation/moxa-smartio
> +F:	drivers/char/moxa.c
> +F:	drivers/char/mxser*

Only mxser_new.*


-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
