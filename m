Return-Path: <linux-kernel-owner+w=401wt.eu-S936968AbXHOWhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936968AbXHOWhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 18:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934453AbXHOWhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 18:37:36 -0400
Received: from web50107.mail.re2.yahoo.com ([206.190.38.35]:48835 "HELO
	web50107.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934759AbXHOWhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 18:37:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=sMZaTBaA5QyWi816k5VbVxFEPmwsZD7+962NqP8qZ3oA5r/zY2hp+v6NeGRffLFcSQWj31lceeoegkL7x5uv9yOd2BO1BPT1iXUmSTT8ARvnW5MF3iq5+xgUxPcrPHoyXKOiP3LbfdaqJdfcVQ9mNb5g67VtM/SWfE6SeNd0oJ0=;
X-YMail-OSG: 8bPZmsUVM1nmvT7YVEgNlxc0LcdRJpsm3H8Cw9GWD6m2cjWeHADCkHkRs.X38zEmwg--
Date: Wed, 15 Aug 2007 15:37:33 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Reply-To: dougthompson@xmission.com
Subject: Re: [PATCH] [173/2many] MAINTAINERS - EDAC-I82443BXGX
To: joe@perches.com, tim@buttersideup.com, linux-kernel@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net, akpm@linux-foundation.org
In-Reply-To: <46bff9b0.9D/6y4yqs/baIclk%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <264990.26637.qm@web50107.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 678cca3..f1dfcd2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1689,6 +1689,7 @@ M:	tim@buttersideup.com
>  L:	bluesmoke-devel@lists.sourceforge.net
>  W:	bluesmoke.sourceforge.net
>  S:	Maintained
> +F:	drivers/edac/i82443bxgx_edac.c
>  
>  EDAC-I3000
>  P:	Jason Uhlenkott
> 

Acked-by: Doug Thompson <dougthompson@xmission.com>

