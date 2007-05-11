Return-Path: <linux-kernel-owner+w=401wt.eu-S1762096AbXEKQQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762096AbXEKQQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 12:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759314AbXEKQQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 12:16:37 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:49823 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757977AbXEKQQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 12:16:36 -0400
Date: Fri, 11 May 2007 09:19:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: kjhall@us.ibm.com, tpm@selhorst.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: remove invalid list address for TPM
Message-Id: <20070511091932.8a7aa843.randy.dunlap@oracle.com>
In-Reply-To: <20070511164207.24b1437e.sfr@canb.auug.org.au>
References: <20070511164207.24b1437e.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 16:42:07 +1000 Stephen Rothwell wrote:

> This address bounces with "550 Unknown user".
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  MAINTAINERS |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)

Hm, I get:

Your mail to 'tpmdd-devel' with the subject
    test only
Is being held until the list moderator can review it for approval.
The reason it is being held:
    Post by non-member to a members-only list

so what MAINTAINERS usually says in that case is "(subscribers-only)":

L:	linux-atm-general@lists.sourceforge.net (subscribers-only)


Also, the archive shows emails there on APR-30.

> -- 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bd558ac..421740d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3269,7 +3269,6 @@ W:	http://tpmdd.sourceforge.net
>  P:	Marcel Selhorst
>  M:	tpm@selhorst.net
>  W:	http://www.prosec.rub.de/tpm/
> -L:	tpmdd-devel@lists.sourceforge.net
>  S:	Maintained
>  
>  Telecom Clock Driver for MCPL0010



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
