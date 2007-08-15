Return-Path: <linux-kernel-owner+w=401wt.eu-S937110AbXHOWml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937110AbXHOWml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 18:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761509AbXHOWmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 18:42:25 -0400
Received: from web50111.mail.re2.yahoo.com ([206.190.39.137]:36740 "HELO
	web50111.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933510AbXHOWmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 18:42:24 -0400
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2007 18:42:24 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=oJftiJWEOh0h3SUUARhKABYh+j7u0ju3e02w1oauq/wHFtZ/HmJz0PEykQ+5iL/cQEfsOCu6ASI/+Tvfapp31n0EXHRKdCyEeG6wmMQ3NJa4hB01CFqap6rc7db894W3N7/lspD6yCmacLNZobMzxg5AGGVzGcDzXguVYAY1Azs=;
X-YMail-OSG: jnMjzrEVM1m_xoLNukYFSLKzjew8Hv_yb.T9C9Lbmo_4qn7p8GcmOgKeKg1hb7HfooQ3fPx7DjskLW6ELpVVuz.nbTfKGxc42oTY_1BIz12WBT1lqg7G4NVOepE5R3Zh6kLzYohsuX4Eog--
Date: Wed, 15 Aug 2007 15:35:43 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Reply-To: dougthompson@xmission.com
Subject: Re: [PATCH] [177/2many] MAINTAINERS - EDAC-PASEMI
To: joe@perches.com, linux-kernel@vger.kernel.org, egor@pasemi.com,
       bluesmoke-devel@lists.sourceforge.net, akpm@linux-foundation.org
In-Reply-To: <46bff9b7.YOpxeQjK7ftqm673%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <695719.8685.qm@web50111.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 569f89f..08e62f1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1723,6 +1723,7 @@ M:	egor@pasemi.com
>  L:	bluesmoke-devel@lists.sourceforge.net
>  W:	bluesmoke.sourceforge.net
>  S:	Maintained
> +F:	drivers/edac/pasemi_edac.c

Acked-by: Doug Thompson <dougthompson@xmission.com>

>  
>  EDAC-R82600
>  P:	Tim Small
> 

