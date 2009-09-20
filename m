Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbZITQv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbZITQv5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 12:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbZITQvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 12:51:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45901 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637AbZITQvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 12:51:55 -0400
Date: Sun, 20 Sep 2009 18:51:58 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][TRIVIAL] Fix comment in drivers/ata/pata_hpt37x.c.
In-Reply-To: <m3zl8p3dc4.fsf@intrepid.localdomain>
Message-ID: <alpine.LNX.2.00.0909201851480.17028@wotan.suse.de>
References: <m3zl8p3dc4.fsf@intrepid.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-494598060-1253465518=:17028"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-494598060-1253465518=:17028
Content-Type: TEXT/PLAIN; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT

On Sun, 20 Sep 2009, Krzysztof Halasa wrote:

> A comment fix in drivers/ata/pata_hpt37x.c.
> 
> Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>
> 
> diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
> index 122c786..d0a7df2 100644
> --- a/drivers/ata/pata_hpt37x.c
> +++ b/drivers/ata/pata_hpt37x.c
> @@ -624,7 +624,7 @@ static struct ata_port_operations hpt374_fn1_port_ops = {
>  };
>  
>  /**
> - *	htp37x_clock_slot	-	Turn timing to PC clock entry
> + *	hpt37x_clock_slot	-	Turn timing to PC clock entry
>   *	@freq: Reported frequency timing
>   *	@base: Base timing
>   *

Applied to trivial queue, thanks Krzysztof.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
--168427776-494598060-1253465518=:17028--
