Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbXHWDOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbXHWDOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 23:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbXHWDOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 23:14:25 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4019 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbXHWDOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 23:14:25 -0400
Subject: Re: tpmdd maintainers
From: Joe Perches <joe@perches.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kent Yoder <shpedoikal@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <200708230259.l7N2x4X1023596@hera.kernel.org>
References: <200708230259.l7N2x4X1023596@hera.kernel.org>
Content-Type: text/plain
Date: Wed, 22 Aug 2007 20:14:22 -0700
Message-Id: <1187838862.32738.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-23 at 02:59 +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8e81cc13a88ce486a6b0a6ca56aba6985824917a
> Commit:     8e81cc13a88ce486a6b0a6ca56aba6985824917a
> Parent:     85770ffe4f0cdd4396b17f14762adc25a571a348
> Author:     Kent Yoder <shpedoikal@gmail.com>
> AuthorDate: Wed Aug 22 14:01:04 2007 -0700
> Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
> CommitDate: Wed Aug 22 19:52:44 2007 -0700
> 
>     tpmdd maintainers
>     
>     Fix up the maintainers info in the tpm drivers.  Kylene will be out for
>     some time, so copying the sourceforge list is the best way to get some
>     attention.
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 371fe67..abe5fa7 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3452,7 +3452,7 @@ S:	Maintained
>  
>  TPM DEVICE DRIVER
>  P:	Kylene Hall
> -M:	kjhall@us.ibm.com
> +M:	tpmdd-devel@lists.sourceforge.net
>  W:	http://tpmdd.sourceforge.net
>  P:	Marcel Selhorst
>  M:	tpm@selhorst.net

Perhaps you should take Kylene's name off too.


