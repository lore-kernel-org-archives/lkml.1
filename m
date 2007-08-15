Return-Path: <linux-kernel-owner+w=401wt.eu-S935627AbXHOWgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935627AbXHOWgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 18:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757901AbXHOWgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 18:36:18 -0400
Received: from web50106.mail.re2.yahoo.com ([206.190.38.34]:27579 "HELO
	web50106.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757738AbXHOWgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 18:36:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=lux6Lk2yj08Thk/j4NGBZbizVBXH2J8OZkopXWPOhapxNQW263VLFtfcNrfVfHBaXRK/T/JYIZnN9Pq6qQIvq6bFUJhNkVs/i/js65ijWAACOfByJEOCTO5ZKvqbijZ+TsuCYHRk/WhAxG7edfEaotHTyqt+mQmeVKiT3uKqbSc=;
X-YMail-OSG: j4KOSc0VM1mI8Sa6WHjxm0O0EqyxFVkiYBY4QAKLREi.nJVPGaN6JrC0Hi.EcpIpgg--
Date: Wed, 15 Aug 2007 15:36:15 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Reply-To: dougthompson@xmission.com
Subject: Re: [PATCH] [176/2many] MAINTAINERS - EDAC-I82975X
To: joe@perches.com, rdesikan@jetzbroadband.com, linux-kernel@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net, arvind@acarlab.com,
       akpm@linux-foundation.org
In-Reply-To: <46bff9b5.TZH103TWbdbm/d1A%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <370635.7688.qm@web50106.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c2ef686..569f89f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1715,6 +1715,7 @@ M:	arvind@acarlab.com
>  L:	bluesmoke-devel@lists.sourceforge.net
>  W:	bluesmoke.sourceforge.net
>  S:	Maintained
> +F:	drivers/edac/i82975x_edac.c
>  
>  EDAC-PASEMI
>  P:	Egor Martovetsky
> 

Acked-by: Doug Thompson <dougthompson@xmission.com>
