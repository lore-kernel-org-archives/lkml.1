Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbYHVQxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbYHVQxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 12:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYHVQxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 12:53:08 -0400
Received: from igw1.br.ibm.com ([32.104.18.24]:45671 "EHLO igw1.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbYHVQxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 12:53:07 -0400
Subject: [PATCH] TPM: include subscribers-only notation in MAINTAINERS
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, debora@linux.vnet.ibm.com, tpm@selhorst.net
In-Reply-To: <1219420519.3613.16.camel@localhost.localdomain>
References: <1219420519.3613.16.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 22 Aug 2008 13:51:12 -0300
Message-Id: <1219423872.4765.14.camel@blackbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 28c69aa..71bd3cb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4057,7 +4057,7 @@ W:	http://tpmdd.sourceforge.net
 P:	Marcel Selhorst
 M:	tpm@selhorst.net
 W:	http://www.prosec.rub.de/tpm/
-L:	tpmdd-devel@lists.sourceforge.net
+L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 TRIVIAL PATCHES
-- 
1.5.4.5



On Fri, 2008-08-22 at 11:55 -0400, Eric Paris wrote:
> Include subscribers-only notation in the MAINTAINERS information for the
> tpm development mailing list so people like me don't get rejected
> sending mails to closed lists next time.
> 
> ---
> 
>  MAINTAINERS |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 663485b..44f8006 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4132,7 +4132,7 @@ W:	http://tpmdd.sourceforge.net
>  P:	Marcel Selhorst
>  M:	tpm@selhorst.net
>  W:	http://www.prosec.rub.de/tpm/
> -L:	tpmdd-devel@lists.sourceforge.net
> +L:	tpmdd-devel@lists.sourceforge.net (subscribers-only)
>  S:	Maintained
> 
>  TRIVIAL PATCHES
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

