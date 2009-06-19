Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbZFSMK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbZFSMK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 08:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbZFSMKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 08:10:49 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:63902 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbZFSMKs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 08:10:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xCgeaoP7OEXXFJKIK8bM/0Jq6LVjSygkDeI6+RZdNSZzxBqi3K4EqewzufkdJX6+D3
         LsZXUMW6TD/VdZdpfMM47B+8lLC1KQDLWp4Ax6MxToKd9symgluKWMsDmY/E+IhtkHTE
         czNCaohmc98kHJA6fFwvh5x7sXGlEA8yxeaCE=
MIME-Version: 1.0
In-Reply-To: <e3bb2ff1b37b724181e958a1ffdb1f5bc1d0a5e5.1245345515.git.joe@perches.com>
References: <cover.1245345515.git.joe@perches.com>
	 <e3bb2ff1b37b724181e958a1ffdb1f5bc1d0a5e5.1245345515.git.joe@perches.com>
Date: Fri, 19 Jun 2009 16:10:49 +0400
Message-ID: <bc64b4640906190510u42134c06hb9ec2614851f8dfe@mail.gmail.com>
Subject: Re: [PATCH 4/5] MAINTAINERS: ieee802154 fix pattern typo
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sergey Lapin <slapin@ossfans.org>,
       linux-zigbee-devel@lists.sourceforge.net,
       David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/18 Joe Perches <joe@perches.com>:
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

Added to our for-linus branch, however I do not care if it will come to linus
via davem's or via akpm's tree.

> ---
>  MAINTAINERS |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f4175c5..2375de3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2850,7 +2850,7 @@ W:        http://apps.sourceforge.net/trac/linux-zigbee
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/lumag/lowpan.git
>  S:     Maintained
>  F:     net/ieee802154/
> -F:     drivers/ieee801254/
> +F:     drivers/ieee802154/
>
>  INTEGRITY MEASUREMENT ARCHITECTURE (IMA)
>  P:     Mimi Zohar
> --
> 1.6.3.1.10.g659a0.dirty
>
>



-- 
With best wishes
Dmitry
