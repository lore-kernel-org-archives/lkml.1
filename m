Return-Path: <linux-kernel-owner+w=401wt.eu-S943929AbXHMNcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943929AbXHMNcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970563AbXHMJjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 05:39:25 -0400
Received: from ozlabs.org ([203.10.76.45]:44858 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S970579AbXHMJjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 05:39:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18112.9870.744182.247752@cargo.ozlabs.ibm.com>
Date: Mon, 13 Aug 2007 19:38:22 +1000
From: Paul Mackerras <paulus@samba.org>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-ppp@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [384/2many] MAINTAINERS - PPP PROTOCOL DRIVERS AND
 COMPRESSORS
In-Reply-To: <46bffb62.YUHsMJB9NIlhwots%joe@perches.com>
References: <46bffb62.YUHsMJB9NIlhwots%joe@perches.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

joe@perches.com writes:

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 62354a9..70667e6 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3679,6 +3679,7 @@ P:	Paul Mackerras
>  M:	paulus@samba.org
>  L:	linux-ppp@vger.kernel.org
>  S:	Maintained
> +F:	drivers/net/ppp_*

Except for drivers/net/ppp_synctty.c.

Paul.
