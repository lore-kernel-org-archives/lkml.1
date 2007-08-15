Return-Path: <linux-kernel-owner+w=401wt.eu-S934667AbXHOWii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934667AbXHOWii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 18:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932497AbXHOWiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 18:38:06 -0400
Received: from web50106.mail.re2.yahoo.com ([206.190.38.34]:29675 "HELO
	web50106.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932738AbXHOWiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 18:38:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=y3L4/CfIUnnuIFEEWTujCNWUa/W7vTY7x2F9m6CZBodyvI1nwHo0SJfPAFtYNXkFIc5nQ4uUps/PjinNGke2ZikWLy1AhcABNsqHjdM4JKIkMqbyb2oB0DGJc0FGyctM/iKpbSiUsNCkXB06JeylNx4jn6ck9SCNd/lQCMgwNNA=;
X-YMail-OSG: h8ynWSkVM1mxWg.a1el9mrIEc8qd1Le8.EYmc5X0gHsIgIqMrHosBRgyGu25GhBvodv7jj74SA0do07hO_vOpDkzcJMWPYGsawSTD6doMvm5syFwLc57r9LT7jFOWm2fm1S9qkJ7r2SVx5U-
Date: Wed, 15 Aug 2007 15:38:03 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Reply-To: dougthompson@xmission.com
Subject: Re: [PATCH] [172/2many] MAINTAINERS - EDAC-E752X
To: joe@perches.com, mark.gross@intel.com, linux-kernel@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net, akpm@linux-foundation.org
In-Reply-To: <46bff9ae.GbQ+uKdS5rg6P1L+%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <295289.8518.qm@web50106.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 78e5b0c..678cca3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1674,6 +1674,7 @@ M:	dougthompson@xmission.com
>  L:	bluesmoke-devel@lists.sourceforge.net
>  W:	bluesmoke.sourceforge.net
>  S:	Maintained
> +F:	drivers/edac/e752x_edac.c
>  
>  EDAC-E7XXX
>  P:	Doug Thompson
> 

Acked-by: Doug Thompson <dougthompson@xmission.com>


