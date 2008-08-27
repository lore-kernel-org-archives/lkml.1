Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbYH0AzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbYH0AzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 20:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbYH0AzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 20:55:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751953AbYH0AzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 20:55:01 -0400
Date: Tue, 26 Aug 2008 17:53:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: eparis@redhat.com, linux-kernel@vger.kernel.org, debora@linux.vnet.ibm.com,
       tpm@selhorst.net
Subject: Re: [PATCH] TPM: include subscribers-only notation in MAINTAINERS
Message-Id: <20080826175339.bb3b0e15.akpm@linux-foundation.org>
In-Reply-To: <1219423872.4765.14.camel@blackbox>
References: <1219420519.3613.16.camel@localhost.localdomain>
	<1219423872.4765.14.camel@blackbox>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2008 13:51:12 -0300
Rajiv Andrade <srajiv@linux.vnet.ibm.com> wrote:

> ---
>  MAINTAINERS |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 28c69aa..71bd3cb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4057,7 +4057,7 @@ W:	http://tpmdd.sourceforge.net
>  P:	Marcel Selhorst
>  M:	tpm@selhorst.net
>  W:	http://www.prosec.rub.de/tpm/
> -L:	tpmdd-devel@lists.sourceforge.net
> +L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
>  S:	Maintained
>

- patch title ("TPM: include subscribers-only notation in
  MAINTAINERS) is now wrong.

- patch has no changelog

- patch has no signoff.

I can (and often do) fix the first two things, and sometimes I'll even
fix the third, while notifying the submitter.

I would prefer to not have to do so though.
