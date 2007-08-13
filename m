Return-Path: <linux-kernel-owner+w=401wt.eu-S968653AbXHMORU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968653AbXHMORU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S944263AbXHMLRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:17:04 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34683 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S944325AbXHMLRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:17:01 -0400
Date: Mon, 13 Aug 2007 06:16:01 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [289/2many] MAINTAINERS - LINUX FOR POWERPC
Message-ID: <20070813061601.50bbefe0@zod.rchland.ibm.com>
In-Reply-To: <46bffaa9.Up0nOpoPeVCIyvqc%joe@perches.com>
References: <46bffaa9.Up0nOpoPeVCIyvqc%joe@perches.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007 23:31:05 -0700
joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c643ebe..1d1da70 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2775,6 +2775,8 @@ W:	http://www.penguinppc.org/
>  L:	linuxppc-dev@ozlabs.org
>  T:	git kernel.org:/pub/scm/linux/kernel/git/paulus/powerpc.git
>  S:	Supported
> +F:	arch/powerpc
> +F:	include/asm-powerpc/

There's also the arch/ppc, include/asm-ppc directories until they get
removed.

josh
