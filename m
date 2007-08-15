Return-Path: <linux-kernel-owner+w=401wt.eu-S936879AbXHOWh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936879AbXHOWh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 18:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757901AbXHOWhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 18:37:12 -0400
Received: from web50102.mail.re2.yahoo.com ([206.190.38.30]:29418 "HELO
	web50102.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754863AbXHOWhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 18:37:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=6VcZRunXyllifvCrSZutBPacdL0Yr/Xkwh8vm3fQihULAHucIHIPy9tHovmObsQXXYZQy1sKQu2gXNJxDLWhp/oL14mzRrawuNQmQ7Ov1GQyFChEAU5ayGj1mJ8eXN7sWZeDPRlVuOFgyr0FXEM5ecPFCjLF8orB9XDrh5i5fIM=;
X-YMail-OSG: VLxtoJ8VM1lG..3RyXe2ajC5hsuisJOK5DUeoXPm
Date: Wed, 15 Aug 2007 15:37:09 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Reply-To: dougthompson@xmission.com
Subject: Re: [PATCH] [174/2many] MAINTAINERS - EDAC-I3000
To: joe@perches.com, linux-kernel@vger.kernel.org, juhlenko@akamai.com,
       bluesmoke-devel@lists.sourceforge.net, akpm@linux-foundation.org
In-Reply-To: <46bff9b1.SvLoj3UoPCyo7tpM%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <985856.20761.qm@web50102.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f1dfcd2..c26b346 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1697,6 +1697,7 @@ M:	juhlenko@akamai.com
>  L:	bluesmoke-devel@lists.sourceforge.net
>  W:	bluesmoke.sourceforge.net
>  S:	Maintained
> +F:	drivers/edac/i3000_edac.c
>  
>  EDAC-I5000
>  P:	Doug Thompson
> 

Acked-by: Doug Thompson <dougthompson@xmission.com>

